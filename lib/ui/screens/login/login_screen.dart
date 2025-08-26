import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:research_mantra_official/constants/assets.dart';
import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/images/login_images/login_images_provider.dart';
import 'package:research_mantra_official/providers/login/login_provider.dart';
import 'package:research_mantra_official/providers/login/login_state.dart';
import 'package:research_mantra_official/services/check_connectivity.dart';
import 'package:research_mantra_official/services/secure_storage.dart';
import 'package:research_mantra_official/services/url_launcher_helper.dart';
import 'package:research_mantra_official/ui/components/button.dart';
import 'package:research_mantra_official/ui/Screens/home/home_navigator.dart';
import 'package:research_mantra_official/ui/components/cacher_network_images/circular_cached_network_image.dart';
import 'package:research_mantra_official/ui/components/common_expires/expire.dart';
import 'package:research_mantra_official/ui/components/common_images_checker/common_image_checker.dart';
import 'package:research_mantra_official/ui/components/dynamic_promo_card/service/promo_manager.dart';
import 'package:research_mantra_official/ui/screens/otpscreen/otp_verification.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';

class LoginWidget extends ConsumerStatefulWidget {
  const LoginWidget({super.key});

  @override
  ConsumerState<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends ConsumerState<LoginWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<String> images = [];
  bool isDispose = false;

  // final TextEditingController _countryCodeController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  bool isLoading = true;
  bool _emptyFieldsError = false;
  String countryCode = "+91";
  Country selectedCountry = Country(
      phoneCode: "91",
      countryCode: "IN",
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: "India",
      example: "India",
      displayName: "India",
      displayNameNoCountryCode: "IN",
      e164Key: "");

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      PromoManager().tryShowPromo(context, disable: true);
      await ref
          .read(loginScreenImagesProvider.notifier)
          .getLoginScreenImagesList(loginScreenurlEndpoint);
      await _initializeImages();
      bool isConnected =
          await CheckInternetConnection().checkInternetConnection();
      if (isConnected) {
        await httpClient.postOthers(
            "$other?message=${await userDetails.getRefreshToken() ?? "Refresh Token is  not there"} ____   ${await userDetails.getUserDetails() ?? "no Data"} ---Login Screen Secure storage check");

        // print("Hello world ${await userDetails.getUserDetails()}");
      }
    });
  }

  _initializeImages() async {
    if (!isDispose) {
      final loginScreenImagesState = ref.watch(loginScreenImagesProvider);
      final String imagesJson =
          json.encode(loginScreenImagesState.loginScreenImages);
      final List<dynamic> imagesList = json.decode(imagesJson);

      // Check if any of the images have an expiration date that has passed
      final List<dynamic> nonExpiredImages =
          ExpirationUtils.filterExpiredImages(imagesList);
      // Filter available images by checking their existence
      final List<String> availableImages =
          await CommonImagesChecker().filterAvailableImages(nonExpiredImages);

      if (!mounted) return;
      setState(() {
        images = availableImages;
        isLoading = false;
      });
    }
  }

  // Listen to changes in the login state
  void _listenToLoginStateChanges(WidgetRef ref) {
    ref.listen<LoginState>(loginProvider, (prevState, loginState) {
      if (loginState.isUserAuthenticated) {
        handleLoginSuccess(context);
      } else if (loginState.isotpSentSuccessfully &&
          loginState.isNotFromOtpScreen) {
        handleOtpSentSuccess(context);
      } else if (loginState.isLoginFailed) {
        // Show login failed message using ToastUtils
        ToastUtils.showToast(loginState.message, 'error');
      } else if (loginState.retyLimitReached) {
        // Show retry limit reached message using ToastUtils
        ToastUtils.showToast(loginState.message, 'error');
      }
    });
  }

  void _checkAllFields() {
    // final locale = AppLocalizations.of(context)!;
    // final loginState = ref.watch(loginProvider);
    // if (loginState.error != null) ToastUtils.showToast(locale.loginError, null);
    // if (_emptyFieldsError) ToastUtils.showToast(locale.emptyFieldsError, null);
  }

  // Handle navigation after successful login
  void handleLoginSuccess(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (ctx) => const HomeNavigatorWidget()));
  }

  // Handle navigation after OTP sent successfully
  void handleOtpSentSuccess(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (ctx) => OtpVerificationScreenWidget(
                  mobileNumberController: _mobileNumberController.text,
                  countryCode: countryCode,
                )));
  }

  void _navigateToPolicies() async {
    await UrlLauncherHelper.launchUrlIfPossible(policiesUrl);
  }

  @override
  void dispose() {
    // _countryCodeController.dispose();
    _mobileNumberController.dispose();
    isDispose = true;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    _listenToLoginStateChanges(ref);

    return Scaffold(
        backgroundColor: theme.primaryColor,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              SizedBox(height: 40.h),
              _buildCarouselSlider(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.065),
              Padding(
                padding: EdgeInsets.all(20.h),
                child: Column(
                  children: [
                    _buildForm(context),
                    _buildButtons(context),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    _buildDescription(context),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  int _currentIndex = 0;
  Key carouselImageKey = UniqueKey();

  Widget _buildCarouselSlider() {
    final theme = Theme.of(context);
    return Column(
      children: [
        // Images are loading state showing loader
        if (isLoading)
          Container(
            margin: const EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height * 0.3,
            child: commonLoadingBuilder(
              250,
              250,
            ),
          )

        // Images list not empty and not expired, we are displaying the images
        else if (images.isNotEmpty)
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
            margin: const EdgeInsets.only(top: 30),
            child: Semantics(
              label: 'Carousel Slider',
              child: CarouselSlider(
                key: carouselImageKey,
                items: images.map((imagePath) {
                  return CircularCachedNetworkLoginScreenImages(
                    imageURL: '$profileScreenAdvertisementImageUrl/$imagePath',
                  );
                }).toList(),
                options: CarouselOptions(
                  // height: MediaQuery.of(context).size.height * 0.35,
                  aspectRatio: 1.5,
                  autoPlay: (images.length) == 1 ? false : true,
                  initialPage: _currentIndex,
                  enableInfiniteScroll: (images.length) == 1 ? false : true,
                  reverse: false,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(seconds: 2),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
              ),
            ),
          )
        // Images list is empty or any image is expired, display the default image
        else if (images.isEmpty)
          Semantics(
            label: 'Default login image',
            child: Container(
              margin: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.33,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imagea, // Your default image asset path
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        const SizedBox(
          height: 10,
        ),
        if (images.length > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: images.asMap().entries.map((entry) {
              final int index = entry.key;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _currentIndex = index;
                    carouselImageKey = UniqueKey();
                  });
                },
                child: Container(
                  width: 12.0,
                  height: 3.0,
                  margin: const EdgeInsets.symmetric(horizontal: 6.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: _currentIndex == index
                        ? theme.indicatorColor
                        : theme.shadowColor,
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  // Build the form widget
  Widget _buildForm(BuildContext context) {
    final theme = Theme.of(context);
    final height = MediaQuery.of(context).size.width;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: theme.focusColor, width: 1))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment
                  .center, // Ensures alignment of content in Row
              children: [
                // Country Picker
                GestureDetector(
                  onTap: () {
                    showCountryPicker(
                      countryListTheme: const CountryListThemeData(
                        bottomSheetHeight: 500,
                      ),
                      context: context,
                      onSelect: (value) {
                        setState(() {
                          selectedCountry = value;
                          countryCode = value.phoneCode;
                        });
                      },
                    );
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 1),
                        child: Text(
                          "${selectedCountry.flagEmoji} +${selectedCountry.phoneCode}",
                          style: TextStyle(
                            fontSize: height * 0.04, // Set a standard font size
                            color: theme.primaryColorDark,
                            fontFamily: fontFamily,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(
                          width:
                              8), // Space between country code and input field
                    ],
                  ),
                ),
                // Mobile Number Input
                Expanded(
                  child: TextFormField(
                    controller: _mobileNumberController,
                    maxLength: 12,
                    decoration: InputDecoration(
                      counterText: '', // Hides the character counter
                      hintText: "Enter WhatsApp Number",
                      labelStyle: TextStyle(
                        color: theme.shadowColor,
                        fontWeight: FontWeight.w600,
                      ),
                      border: InputBorder.none, // Removes all borders
                    ),
                    style: TextStyle(
                      fontSize:
                          height * 0.04, // Match font size for consistency
                      color: theme.primaryColorDark,
                      fontFamily: fontFamily,
                      fontWeight: FontWeight.w600,
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: iAmAgreeToTermsAndCondition,
                        style: TextStyle(
                          color: theme.primaryColorDark,
                          fontFamily: fontFamily,
                          fontSize: height * 0.03,
                        )),
                    TextSpan(
                      text: termsConditionText,
                      style: TextStyle(
                          fontSize: height * 0.03,
                          color: theme.indicatorColor,
                          fontFamily: fontFamily,
                          fontWeight: FontWeight.w600),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          bool checkConnection = await CheckInternetConnection()
                              .checkInternetConnection();
                          if (checkConnection) {
                            _navigateToPolicies();
                          }
                        },
                    )
                  ]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Build the buttons widget
  Widget _buildButtons(BuildContext context) {
    final theme = Theme.of(context);
    // final locale = AppLocalizations.of(context)!;
    final loginState = ref.watch(loginProvider);

    return Column(
      children: [
        Button(
          textColor: theme.floatingActionButtonTheme.foregroundColor,
          isLoading: loginState.isLoading,
          text: "Login",
          // locale.login,
          onPressed: () => _handleLogin(),
          backgroundColor: theme.indicatorColor,
          semanticsLabel: 'Login button',
        ),
      ],
    );
  }

//Build Small description Widget
  Widget _buildDescription(BuildContext context) {
    final theme = Theme.of(context);
    final height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite,
              color: theme.disabledColor,
              size: 40,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loginscreenWelcometext1,
                    style: TextStyle(
                        fontSize: height * 0.014,
                        color: theme.primaryColorDark,
                        fontFamily: fontFamily,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    loginscreenWelcometext2,
                    style: TextStyle(
                        fontSize: height * 0.013,
                        color: theme.primaryColorDark,
                        fontFamily: fontFamily,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Handle the login process
  void _handleLogin() async {
    bool isConnected =
        await CheckInternetConnection().checkInternetConnection();
    if (isConnected) {
      setState(() {
        _emptyFieldsError = selectedCountry.phoneCode.isEmpty ||
            _mobileNumberController.text.isEmpty;
      });
      _checkAllFields();
      if (!_emptyFieldsError) {
        ref.read(loginProvider.notifier).login(
            selectedCountry.phoneCode, _mobileNumberController.text, true);
      }
    } else {
      ToastUtils.showToast(noInternetConnectionText, "");
    }
  }
}
