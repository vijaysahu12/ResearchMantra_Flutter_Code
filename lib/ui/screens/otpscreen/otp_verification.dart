// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/providers/login/login_state.dart';
import 'package:research_mantra_official/services/check_connectivity.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';
import 'package:research_mantra_official/ui/components/popupscreens/userregistrationpopup/user_registration_popup.dart';
import 'package:research_mantra_official/ui/screens/home/home_navigator.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:research_mantra_official/utils/utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pinput/pinput.dart';
import '../../../providers/login/login_provider.dart';
import '../../../utils/toast_utils.dart';
import '../../components/button.dart';
import '../../themes/text_styles.dart';

class OtpVerificationScreenWidget extends ConsumerStatefulWidget {
  final String mobileNumberController;
  final String countryCode;
  const OtpVerificationScreenWidget(
      {super.key,
      required this.mobileNumberController,
      required this.countryCode});

  @override
  ConsumerState<OtpVerificationScreenWidget> createState() =>
      _OtpVerificationScreenWidget();
}

class _OtpVerificationScreenWidget
    extends ConsumerState<OtpVerificationScreenWidget> {
  final TextEditingController otpController = TextEditingController();
  final UserSecureStorageService _commonDetails = UserSecureStorageService();
  String deviceInfo = fetchingdeviceInfo;
  bool isLoading = false;

  bool emptyFieldsError = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _focusNode.requestFocus();
    _fetchDeviceInfo();

    super.initState();
  }

  Future<void> _fetchDeviceInfo() async {
    String? info = await getDevice();
    setState(() {
      deviceInfo = info ?? faildedtoGetDeviceInfo;
    });
  }

//function for checking otp is enter or not
  void handleOtpVerification(BuildContext context) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;
    setState(() {
      isLoading = true;
    });

    final enteredOtp = otpController.text;
    bool areOtpFieldEmpty = enteredOtp.isEmpty && enteredOtp.length < 6;

    setState(() => emptyFieldsError = areOtpFieldEmpty);
    if (!areOtpFieldEmpty) {
      ref.read(loginProvider.notifier).otpLoginVerificationAndGetSubscription(
          enteredOtp, deviceInfo, currentVersion);
      setState(() {
        isLoading = false;
      });
    } else {
      ToastUtils.showToast(pleaseEnterAValidOtp, errorText);
      setState(() {
        isLoading = false;
      });
    }
  }

//function for Show User Details popUp
  void showUserProfileDetailsFillPopUpScreen(BuildContext context) async {
    final Map<String, dynamic> userDetails =
        await _commonDetails.getUserDetails();

    String? storedMobileNumber = userDetails['mobileNumber'];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          // ignore: deprecated_member_use
          return WillPopScope(
              onWillPop: () async => false,
              child: Center(
                  child:
                      UserRegistrationPopUp(mobile: storedMobileNumber ?? '')));
        });
      },
    );
  }

//function for handleOtpSuccess
  void handleOtpSuccess(BuildContext context, bool isExistinguser) {
    if (isExistinguser == false) {
      showUserProfileDetailsFillPopUpScreen(context);
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (ctx) => const HomeNavigatorWidget(),
        ),
        (route) => false,
      );
    }
  }

  void _handleResend() async {
    _toggleTimer();
    bool isConnected =
        await CheckInternetConnection().checkInternetConnection();

    if (isConnected) {
      ref
          .read(loginProvider.notifier)
          .login(widget.countryCode, widget.mobileNumberController, false);
    }
  }

  final ValueNotifier<int> _timeLeft = ValueNotifier<int>(0);
  Timer? _timer;

  void _startTimer() {
    _timeLeft.value = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft.value > 0) {
        _timeLeft.value--;
      } else {
        _timer?.cancel();
        _timeLeft.value = 0; // Stop at 0
      }
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    _timeLeft.value = 0; // Reset to 30 seconds
  }

  void _toggleTimer() {
    if (_timeLeft.value == 0) {
      _resetTimer();
      _startTimer();
    } else {
      _resetTimer();
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final height = MediaQuery.of(context).size.height;
    ref.watch(loginProvider);

    ref.listen<LoginState>(loginProvider, (LoginState? _, LoginState state) {
      if (state.otpIsVerified) {
        // showUserProfileDetailsFillPopUpScreen(context);
        handleOtpSuccess(context, state.isExistingUser);
      }
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios)),
      ),
      backgroundColor: theme.primaryColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.28,
                ),
                Text(
                  enteryourVerificationCodeText,
                  style: TextStyle(
                      fontSize: height * 0.022,
                      fontWeight: FontWeight.w600,
                      color: theme.primaryColorDark,
                      fontFamily: fontFamily),
                ),
                const SizedBox(
                  height: 40,
                ),
                _buildForOtpText(theme, height),
                const SizedBox(
                  height: 20,
                ),
                _buildOtpTextfields(context, theme, height),
                SizedBox(
                  height: 15.h,
                ),
                _buildButtons(context),
                SizedBox(
                  height: 10.h,
                ),
                _buildSwitchingButtons(context, height),
                SizedBox(
                  height: 50.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //widget for Text
  Widget _buildForOtpText(theme, height) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
        text: whatsappCheckStatementOne,
        style: TextStyle(
            fontSize: height * 0.016,
            fontWeight: FontWeight.w500,
            color: theme.primaryColorDark,
            fontFamily: fontFamily),
      ),
      TextSpan(
        text:
            " ${widget.countryCode}${widget.mobileNumberController.toString()}.",
        style: TextStyle(
            fontSize: height * 0.018,
            fontWeight: FontWeight.w600,
            color: theme.primaryColorDark,
            fontFamily: fontFamily),
      ),
    ]));
  }

  Widget _buildOtpTextfields(BuildContext context, theme, height) {
    return Column(
      children: [
        Center(
          child: Pinput(
            length: 6,
            showCursor: true,
            controller: otpController,
            focusNode: _focusNode,
            onChanged: (value) {
              setState(() {
                otpController.text = value;
              });
            },
            crossAxisAlignment: CrossAxisAlignment.start,
            scrollPadding: const EdgeInsets.only(left: 20, right: 20),
            keyboardType: TextInputType.number,
            // androidSmsAutofillMethod:
            //     AndroidSmsAutofillMethod.smsUserConsentApi,
            pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
            onCompleted: (pin) => print(pin),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            defaultPinTheme: PinTheme(
              width: 56,
              height: 56,
              textStyle: TextStyle(
                fontSize: height * 0.02,
                color: theme.primaryColorDark,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: theme.shadowColor),
              ),
            ),
            submittedPinTheme: PinTheme(
              width: 56,
              height: 56,
              textStyle: TextStyle(
                fontSize: height * 0.02,
                color: theme.primaryColorDark,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    final theme = Theme.of(context);
    // final locale = AppLocalizations.of(context)!;
    final loginState = ref.watch(loginProvider);
    return Column(
      children: [
        if (loginState.error != null) Text("Error", style: textSmall),
        Button(
          textColor: theme.floatingActionButtonTheme.foregroundColor,
          isLoading: loginState.isLoading,
          text: "Enter otp",
          onPressed: () => handleOtpVerification(context),
          backgroundColor: theme.indicatorColor,
        ),
      ],
    );
  }

  Widget _buildSwitchingButtons(BuildContext context, height) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(
                changeMobileNumberText,
                style: TextStyle(
                  fontSize: height * 0.014,
                  color: theme.primaryColorDark,
                  fontFamily: fontFamily,
                ),
              ),
            ),
            ValueListenableBuilder(
                valueListenable: _timeLeft,
                builder: ((context, value, child) {
                  return GestureDetector(
                    onTap: () => _timeLeft.value > 0 ? null : _handleResend(),
                    child: Text(
                      _timeLeft.value > 0
                          ? _timeLeft.value >= 10
                              ? "Time Remaining: 00: $value"
                              : "Time Remaining: 00: 0$value"
                          : resendCode,
                      style: TextStyle(
                          fontSize: height * 0.014,
                          fontFamily: fontFamily,
                          color: theme.primaryColorDark,
                          fontWeight: FontWeight.w500),
                    ),
                  );
                })),
          ],
        ),
      ],
    );
  }
}
