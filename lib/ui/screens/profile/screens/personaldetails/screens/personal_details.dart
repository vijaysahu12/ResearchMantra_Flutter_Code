import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/constants/storage.dart';
import 'package:research_mantra_official/data/models/user_login_response_model.dart';
import 'package:research_mantra_official/data/models/user_personal_details_api_response_model.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/check_connection_provider.dart';
import 'package:research_mantra_official/providers/gender/gender_provider.dart';
import 'package:research_mantra_official/services/secure_storage.dart';
import 'package:research_mantra_official/ui/components/common_error/oops_screen.dart';
import 'package:research_mantra_official/ui/components/innovation_button/developed_button.dart';
import 'package:research_mantra_official/ui/components/king_research_loader/kingresearch_loader.dart';
import 'package:research_mantra_official/ui/screens/profile/screens/personaldetails/screens/delete_account/delete_account.dart';
import 'package:research_mantra_official/ui/screens/profile/screens/personaldetails/widgets/deactivate_delete_buttons.dart';
import 'package:research_mantra_official/ui/screens/profile/screens/personaldetails/widgets/profile_contact_details.dart';
import 'package:research_mantra_official/ui/screens/profile/screens/personaldetails/widgets/profile_dob.dart';
import 'package:research_mantra_official/ui/screens/profile/screens/personaldetails/widgets/profile_email.dart';
import 'package:research_mantra_official/ui/screens/profile/screens/personaldetails/widgets/profile_gender.dart';
import 'package:research_mantra_official/ui/screens/profile/screens/personaldetails/widgets/profile_image_picker.dart';
import 'package:research_mantra_official/ui/screens/profile/screens/personaldetails/widgets/profile_name.dart';
import 'package:research_mantra_official/ui/screens/profile/screens/personaldetails/widgets/profile_update_button.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';
import '../../../../../../providers/userpersonaldetails/user_personal_details_provider.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';

// Widget for displaying and updating personal profile details
class PersonalProfileDetailsWidget extends ConsumerStatefulWidget {
  final UserPersonalDetailsModel? getPersonalDetails;
  final void Function() onProfileImageDelete;
  final bool profileImageDeleted;
  final bool isGenderChange;
  final bool hasConnection;
  final void Function() handleToRefresh;
  const PersonalProfileDetailsWidget({
    super.key,
    required this.getPersonalDetails,
    required this.onProfileImageDelete,
    required this.profileImageDeleted,
    required this.isGenderChange,
    required this.hasConnection,
    required this.handleToRefresh,
  });

  @override
  ConsumerState<PersonalProfileDetailsWidget> createState() =>
      _PersonalProfileDetailsWidgetState();
}

class _PersonalProfileDetailsWidgetState
    extends ConsumerState<PersonalProfileDetailsWidget> {
  final UserSecureStorageService _commonDetails = UserSecureStorageService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userEmailController = TextEditingController();
  final TextEditingController _userMobileController = TextEditingController();
  final TextEditingController _userCityController = TextEditingController();
  final TextEditingController _userDateOfBirthController =
      TextEditingController();
  final SecureStorage _secureStorage = getIt<SecureStorage>();

  String? selectedGender;
  String? imagePath;
  DateTime selectedDate = DateTime.now();
  File? _image;

  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _checkAndFetch();
    });
  }

  Future<void> _checkAndFetch() async {
    final connectivityResult = ref.watch(connectivityStreamProvider);

    //Checking result based on that displaying connection screen
    final connectionResult = connectivityResult.value;

    bool isConnection = connectionResult != ConnectivityResult.none;

    if (isConnection && widget.getPersonalDetails != null) {
      // Load details from API response
      final userPersonalDetails = widget.getPersonalDetails;
      setState(() {
        _userNameController.text = userPersonalDetails?.fullName ?? 'User';
        _userEmailController.text =
            userPersonalDetails?.emailId ?? 'user123@gmail.com';
        _userCityController.text = userPersonalDetails?.city ?? 'Unkown';
        _userMobileController.text =
            userPersonalDetails?.mobile ?? '0000000000';
        _userDateOfBirthController.text =
            DateFormat('dd-MMM-yyyy').format(userPersonalDetails!.dob);
        selectedGender = userPersonalDetails.gender;
        ref.read(getGenderProvider.notifier).updateGender(selectedGender ?? "");
        _secureStorage.write(userGender, selectedGender);
      });
    } else {
      loadUserDetailsFromSecureStorage();
    }
  }

  // Load user details from secure storage
  void loadUserDetailsFromSecureStorage() async {
    Map<String, dynamic> userData = await _commonDetails.getUserDetails();
    final Map<String, dynamic> userDetails =
        await _commonDetails.getUserDetails();
    UserData userImageData = UserData.fromJson(userDetails);
    final gender = await _commonDetails.getSelectedGender();
    setState(() {
      _userNameController.text = userData['fullName'];
      _userEmailController.text = userData['emailId'];
      _userMobileController.text = userData['mobileNumber'];
      selectedGender = userData['gender'] ?? gender;

      _userCityController.text = userData['city'] ?? '';
      _userDateOfBirthController.text = userData['dob'] ?? '';
      profileImageUrl = userImageData.profileImage ?? '';
    });
    ref.read(getGenderProvider.notifier).updateGender(selectedGender ?? "");
  }

  // Define a function for input validation
  bool validateInputs(String fullName, String email, String mobileNumber,
      String city, String dateOfBirth, String gender) {
    if (fullName.isEmpty ||
        email.isEmpty ||
        mobileNumber.isEmpty ||
        city.isEmpty ||
        dateOfBirth.isEmpty ||
        gender.isEmpty) {
      // Handle invalid input

      ToastUtils.showToast("Please fill all the fields.", errorText);
      return false;
    }

    // Validate name length
    if (fullName.length < 3) {
      // Handle invalid name length

      ToastUtils.showToast("Name should be at least 3 characters .", errorText);
      return false;
    }

    // Validate city length
    if (city.length < 3) {
      // Handle invalid city length

      ToastUtils.showToast(
          "City name should be at least 3 characters.", errorText);
      return false;
    }

    // Validate email format
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      // Handle invalid email format

      ToastUtils.showToast("Please enter a valid email address.", errorText);
      return false;
    }

    // Validate mobile number format
    if (!RegExp(r'^[0-9]{10}$').hasMatch(mobileNumber)) {
      // Handle invalid mobile number format

      ToastUtils.showToast(
          "Please enter a valid 10-digit mobile number.", errorText);
      return false;
    }

    return true; // All validations passed
  }

// Updated function using the validation function
  Future<void> handleManageUserDetails() async {
    try {
      // Get data from text fields
      String fullName = _userNameController.text.trim();
      String emailId = _userEmailController.text.trim();
      String mobileNumber = _userMobileController.text.trim();
      String city = _userCityController.text.trim();
      String dateOfBirth = _userDateOfBirthController.text.trim();
      String gender = selectedGender ?? "";

      // Validate inputs
      if (!validateInputs(
          fullName, emailId, mobileNumber, city, dateOfBirth, gender)) {
        return;
      }

      // Get user data from secure storage
      final Map<String, dynamic> userData =
          await _commonDetails.getUserDetails();

      // Use previously fetched image if _image is null
      if (_image == null &&
          widget.getPersonalDetails != null &&
          widget.getPersonalDetails!.profileImage != null) {
        imagePath = widget.getPersonalDetails!.profileImage;
      }

      // Get mobileUserPublicKey using UserSecureStorageService
      final String mobileUserPublicKey = userData['publicKey'];

      // Call manageUserPersonalDetailsProvider method to update user details
      await ref
          .read(getUserPersonalDetailsStateNotifierProvider.notifier)
          .manageUserPersonalDetailsProvider(
              false,
              mobileUserPublicKey,
              fullName,
              emailId,
              mobileNumber,
              city,
              gender,
              dateOfBirth,
              _image);
    } catch (error) {
      print("Error updating user details: $error");
    }
  }

  // Handle update operation and show updated values
  Future<void> handleUpdateAndShowValues() async {
    // Perform the update operation
    await handleManageUserDetails();
    // Once the update is done, show the updated values
    setState(() {});
  }

  // Handle gender selection change
  void onGenderChanged(String? newSelectedGender) {
    setState(() {
      selectedGender = newSelectedGender;
      ref.read(getGenderProvider.notifier).updateGender(selectedGender ?? "");
    });
  }

  String getProfileImageURL(String profileImage) {
    return profileImage;
  }

  void handleNavigateDeleteAccountPopUp(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DeleteAccountScreen(
                  userName: _userNameController.text,
                  selectedGender: selectedGender,
                  profileImage: widget.getPersonalDetails != null &&
                          widget.getPersonalDetails?.profileImage != null
                      ? getProfileImageURL(
                          widget.getPersonalDetails!.profileImage!)
                      : profileImageUrl,
                )));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.getPersonalDetails == null) {
      return const ErrorScreenWidget();
    }
    if (selectedGender == null) {
      return const CommonLoaderGif();
    }

    return RefreshIndicator(
      onRefresh: () async {
        // Handle refresh indicator
        widget.handleToRefresh();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: AnimationConfiguration.synchronized(
              duration: const Duration(milliseconds: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile image picker widget

                  // widget.profileImageDeleted
                  //     ? Center(
                  //         child: Container(
                  //           padding: const EdgeInsets.only(bottom: 30),
                  //           child: const CircleAvatar(
                  //             radius: 30,
                  //             child: CircularProgressIndicator(),
                  //           ),
                  //         ),
                  //       )
                  //     : ProfileImagePicker(
                  //         isGenderChange: widget.isGenderChange,
                  //         profileImage: widget.getPersonalDetails != null &&
                  //                 widget.getPersonalDetails?.profileImage !=
                  //                     null
                  //             ? getProfileImageURL(
                  //                 widget.getPersonalDetails!.profileImage ?? '')
                  //             : profileImageUrl,
                  //         onImageSelected: (File? image) {
                  //           _image = image;
                  //         },
                  //         selectedGender: selectedGender,
                  //         onProfileImageDelete: widget.onProfileImageDelete,
                  //       ),

                  // SizedBox(height: 5.h),
                  // Text field for user name
                  NameTextField(userNameController: _userNameController),
                  SizedBox(height: 10.h),
                  // Widget for selecting date of birth
                  DateOfBirthWidget(
                      userDateOfBirthController: _userDateOfBirthController),
                  SizedBox(height: 15.h),
                  // Widget for selecting gender
                  GenderSelection(
                    selectedGender: selectedGender,
                    onGenderChanged: onGenderChanged,
                  ),
                  SizedBox(height: 15.h),
                  // Text for contact details
                  _buildContactDetailsText(),
                  SizedBox(height: 8.h),
                  // Widget for mobile number and city
                  MobileNumberAndCity(
                    userMobileController: _userMobileController,
                    userCityController: _userCityController,
                  ),
                  SizedBox(height: 8.h),
                  // Text field for email ID
                  EmailIdTextField(userEmailController: _userEmailController),
                  SizedBox(height: 25.h),
                  // Button for updating personal details
                  UpdatePersonalDetailsButton(
                    handleManageUserDetails: handleUpdateAndShowValues,
                  ),
                  // SizedBox(height: 20.h),
                  // DeleteAndDeactivateButtons(
                  //   handleDeleteAccountPopUp: handleNavigateDeleteAccountPopUp,
                  // ),
                  // SizedBox(height: 20.h),

                  // Center(
                  //   child: DevelopedByText(),
                  // ),
                  // SizedBox(height: 5.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget for displaying contact details text
  Widget _buildContactDetailsText() {
    return SizedBox(
      child: Text(
        'Contact Details',
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          fontFamily: fontFamily,
        ),
      ),
    );
  }
}
