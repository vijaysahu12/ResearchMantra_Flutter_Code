// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/providers/userpersonaldetails/user_personal_details_provider.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';

import 'package:research_mantra_official/ui/Screens/home/home_navigator.dart';
import 'package:research_mantra_official/ui/components/button.dart';
import 'package:research_mantra_official/ui/components/common_controllers/common_text_controllers.dart';
import 'package:research_mantra_official/ui/components/popupscreens/common_textspan.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

// ignore: must_be_immutable
class UserRegistrationPopUp extends ConsumerStatefulWidget {
  String mobile;
  UserRegistrationPopUp({
    super.key,
    required this.mobile,
  });

  @override
  ConsumerState<UserRegistrationPopUp> createState() => _UserDataDialogState();
}

class _UserDataDialogState extends ConsumerState<UserRegistrationPopUp> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final UserSecureStorageService _commonDetails = UserSecureStorageService();
  String? selectedGender;
  String _nameError = '';
  String _emailError = '';
  String _mobileError = '';
  String _cityError = '';

  @override
  void initState() {
    selectedGender = maleGenderValue;
    _mobileController.text = widget.mobile;
    super.initState();
  }

  //function for handleManageUserDetails
  void handleManageUserDetails() async {
    final String mobileUserPublicKey = await _commonDetails.getPublicKey();
    try {
      await ref
          .read(getUserPersonalDetailsStateNotifierProvider.notifier)
          .manageUserPersonalDetailsProvider(
              true,
              mobileUserPublicKey,
              _nameController.text,
              _emailController.text,
              widget.mobile,
              _cityController.text,
              selectedGender ?? "",
              "01-01-1990",
              null, () {
        Navigator.pop(context);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (ctx) => const HomeNavigatorWidget()),
          (route) => false,
        );
      });
    } catch (error) {
      print('Error occurred: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userPersonalDetailsState =
        ref.watch(getUserPersonalDetailsStateNotifierProvider);
    final theme = Theme.of(context);
    // if (userPersonalDetailsState.isUserDetailsUpdatedForInitialDetails) {
    //   Navigator.pop(context);
    // }

    return SingleChildScrollView(
      child: Dialog(
        backgroundColor: theme.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildNameContainer(context),
                    SizedBox(
                      height: 10.h,
                    ),
                    _buildEmailContainer(context),
                    SizedBox(
                      height: 10.h,
                    ),
                    _buildMobileContainer(context),
                    SizedBox(
                      height: 10.h,
                    ),
                    _buildCityContainer(context),
                    SizedBox(
                      height: 10.h,
                    ),
                    _buildGenderContainer(context),
                    SizedBox(
                      height: 10.h,
                    ),
                    _buildButtonContainer(context, userPersonalDetailsState),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameContainer(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CommonTextSpan(
          mandatoryFieldName: 'Full Name',
        ),
        CommonTextEditController(
          namedController: _nameController,
          hintText: 'Enter Your Name',
          readOnly: false,
          maxTextfieldLength: 25,
          inputFormatters:
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
        ),
        const SizedBox(height: 5),
        Text(
          _nameError,
          style: TextStyle(
            color: theme.disabledColor,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailContainer(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CommonTextSpan(
          mandatoryFieldName: 'Email Id',
        ),
        CommonTextEditController(
          namedController: _emailController,
          hintText: 'Enter Email Id',
          readOnly: false,
          maxTextfieldLength: 40,
        ),
        const SizedBox(height: 5),
        Text(
          _emailError,
          style: TextStyle(
            color: theme.disabledColor,
            fontFamily: fontFamily,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildMobileContainer(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mobile',
          style: TextStyle(
              fontSize: 12,
              color: theme.primaryColorDark,
              fontFamily: fontFamily,
              fontWeight: FontWeight.w600),
        ),
        CommonTextEditController(
            namedController: _mobileController,
            hintText: placeHolderMobileNumber,
            readOnly: true,
            maxTextfieldLength: 10),
        const SizedBox(height: 5),
        Text(
          _mobileError,
          style: TextStyle(
            color: theme.disabledColor,
            fontFamily: fontFamily,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildCityContainer(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CommonTextSpan(
          mandatoryFieldName: 'City',
        ),
        CommonTextEditController(
          namedController: _cityController,
          hintText: hintDataForUserData,
          readOnly: false,
          maxTextfieldLength: 25,
          inputFormatters:
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
        ),
        const SizedBox(height: 5),
        Text(
          _cityError,
          style: TextStyle(
            color: theme.disabledColor,
            fontFamily: fontFamily,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildGenderContainer(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const CommonTextSpan(
          mandatoryFieldName: 'Gender',
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: theme.primaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: theme.focusColor.withOpacity(0.4),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      maleGenderButton,
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: fontFamily,
                          fontWeight: FontWeight.bold),
                    ),
                    Radio(
                      value: maleGenderValue,
                      groupValue: selectedGender,
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value as String;
                        });
                      },
                      activeColor: theme.primaryColorDark,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: theme.primaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: theme.focusColor.withOpacity(0.4),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      femaleGenderButton,
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: fontFamily,
                          fontWeight: FontWeight.bold),
                    ),
                    Radio(
                      value: femaleGenderValue,
                      groupValue: selectedGender,
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value as String;
                        });
                      },
                      activeColor: theme.primaryColorDark,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildButtonContainer(BuildContext context, userPersonalDetailsState) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Button(
          textColor: theme.floatingActionButtonTheme.foregroundColor,
          text: "Logout",
          isLoading: false,
          onPressed: () {
            setState(() {
              isLoggingout = true;
            });

            _commonDetails.handleToRemoveAndInvalidate(context, ref);
          },
          backgroundColor: theme.disabledColor.withOpacity(0.5),
        ),
        Button(
          textColor: theme.floatingActionButtonTheme.foregroundColor,
          text: "Register",
          isLoading: userPersonalDetailsState.isLoading,
          onPressed: () {
            String fullName = _nameController.text.trim();
            String email = _emailController.text.trim();
            String mobile = _mobileController.text.trim();
            String city = _cityController.text.trim();

            // Perform validation checks for all fields
            bool isNameValid = _validateName(fullName);
            bool isEmailValid = _validateEmail(email);
            bool isMobileValid = _validateMobile(mobile);
            bool isCityValid = _validateCity(city);

            // Check if all fields are valid before proceeding
            if (isNameValid && isEmailValid && isMobileValid && isCityValid) {
              // If validation passes, proceed to the next screen
              handleManageUserDetails();
            } else {
              // If validation fails, show an error message or handle it as needed
              print("Validation failed");
            }
          },
          backgroundColor: theme.indicatorColor,
        ),
      ],
    );
  }

  bool _validateName(String value) {
    if (value.isEmpty) {
      setState(() {
        _nameError = 'This field is required';
      });
      return false;
    } else if (value.length < 3) {
      setState(() {
        _nameError = 'Enter Full Name at least 3 characters';
      });
      return false;
    } else {
      setState(() {
        _nameError = '';
      });
      return true;
    }
  }

  bool _validateEmail(String value) {
    if (value.isEmpty) {
      setState(() {
        _emailError = "This field is required";
      });
      return false;
    } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
        .hasMatch(value)) {
      setState(() {
        _emailError = 'Enter a valid Email';
      });
      return false;
    } else {
      setState(() {
        _emailError = '';
      });
      return true;
    }
  }

  bool _validateMobile(String value) {
    if (value.isEmpty) {
      setState(() {
        _mobileError = 'This field is required';
      });
      return false;
    } else {
      setState(() {
        _mobileError = '';
      });
      return true;
    }
  }

  bool _validateCity(String value) {
    if (value.isEmpty) {
      setState(() {
        _cityError = 'This field is required';
      });
      return false;
    } else if (value.length < 3) {
      setState(() {
        _cityError = 'Enter City Name at least 3 characters  ';
      });
      return false;
    } else {
      setState(() {
        _cityError = '';
      });
      return true;
    }
  }
}
