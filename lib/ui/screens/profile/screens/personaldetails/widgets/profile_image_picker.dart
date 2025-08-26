// ignore_for_file: library_private_types_in_public_api, unnecessary_new, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import 'package:image_picker/image_picker.dart';
import 'package:research_mantra_official/constants/assets.dart';
import 'package:research_mantra_official/constants/generic_message.dart';

import 'package:research_mantra_official/services/user_secure_storage_service.dart';
import 'package:research_mantra_official/ui/components/cacher_network_images/circular_cached_network_image.dart';
import 'package:research_mantra_official/ui/components/popupscreens/logout_popup/logout_popup.dart';
import 'package:research_mantra_official/ui/screens/profile/widgets/full_screen_image_dialog.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_cropper/image_cropper.dart';

class ProfileImagePicker extends ConsumerStatefulWidget {
  final String? profileImage;
  final Function(File?) onImageSelected;
  final String? selectedGender;
  final onProfileImageDelete;
  final bool isGenderChange;

  const ProfileImagePicker({
    super.key,
    required this.profileImage,
    required this.onImageSelected,
    required this.onProfileImageDelete,
    this.selectedGender,
    required this.isGenderChange,
  });

  @override
  _ProfileImagePickerState createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends ConsumerState<ProfileImagePicker> {
  final UserSecureStorageService _secureStorageService =
      UserSecureStorageService();
  File? _image;
  String? _profileImageUrl;
  bool _isLoading = false;
  String? selectedGender;

  @override
  void initState() {
    super.initState();
    _profileImageUrl = widget.profileImage;
    _loadSelectedGender();
  }

  // Function to load user gender from secure storage
  _loadSelectedGender() async {
    final String? gender = await _secureStorageService.getSelectedGender();
    setState(() {
      selectedGender = widget.selectedGender ?? gender;
    });
  }

  @override
  void didUpdateWidget(covariant ProfileImagePicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if the gender has changed, if so, update the SVG icon
    if (widget.selectedGender != oldWidget.selectedGender) {
      setState(() {
        selectedGender = widget.selectedGender;
      });
    }
  }

  void showFullScreenImage(BuildContext context, ImageProvider imageProvider) {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return FullScreenImageDialog(
            imageProvider: imageProvider,
            imageUrl: '',
          );
        },
        fullscreenDialog: true));
  }

  void openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 150,
          // decoration: BoxDecoration(color: theme.primaryColor),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                profilePhotoText,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontFamily: fontFamily),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildForIconButon(context, cameraText,
                      () => _pickImage(ImageSource.camera), Icons.camera_alt),
                  buildForIconButon(context, galleryText,
                      () => _pickImage(ImageSource.gallery), Icons.photo),
                  buildForIconButon(
                      context,
                      deleteButtonText,
                      (widget.profileImage != null && widget.profileImage != "")
                          ? _showDeleteConfirmationDialog
                          : () {},
                      Icons.delete),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildForIconButon(context, iconBottomText, onPressed, iconButton) {
    final theme = Theme.of(context);

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
            onPressed();
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: theme.focusColor, width: 0.5),
            ),
            child: Icon(iconButton, color: theme.indicatorColor),
          ),
        ),
        Text(
          iconBottomText,
          style: TextStyle(
              color: theme.primaryColorDark,
              fontFamily: fontFamily,
              fontWeight: FontWeight.w500),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          _buildProfileImage(),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    final theme = Theme.of(context);

    return (_isLoading)
        ? Container(
            decoration: BoxDecoration(
                border: Border.all(color: theme.shadowColor, width: 0.5),
                borderRadius: BorderRadius.circular(50)),
            width: 60,
            height: 60,
            child: const CircularProgressIndicator())
        : Stack(
            children: [
              // If an image is selected, display it
              if (_profileImageUrl == null && _image == null)
                CircleAvatar(
                  radius: 30.5,
                  child: SvgPicture.asset(
                    height: 60,
                    // Use the latest gender state to set the corresponding SVG file
                    selectedGender != null &&
                            selectedGender!.toLowerCase() == maleGenderValue
                        ? maleUserProfileSvgFilePath
                        : feamleUserProfileSvgFilePath,
                    fit: BoxFit.cover, // Ensure the SVG covers the avatar
                  ),
                )
              else if (_image != null)
                GestureDetector(
                  onTap: () {
                    showFullScreenImage(context, FileImage(_image!));
                  },
                  child: CircleAvatar(
                    backgroundImage: FileImage(_image!),
                    radius: 30,
                  ),
                )
              // If no selected image, but a profile image URL exists and gender change is false, display the profile image
              else if (_profileImageUrl != null || !widget.isGenderChange)
                GestureDetector(
                  onTap: () {
                    if (_profileImageUrl != null &&
                        _profileImageUrl!.isNotEmpty) {
                      showFullScreenImage(
                          context, NetworkImage(_profileImageUrl!));
                    }
                  },
                  child: CircularCachedNetworkImage(
                    imageURL: _profileImageUrl!,
                    size: 60,
                    borderColor: theme.shadowColor,
                    type: 'profile',
                  ),
                )
              // If gender change is true, or neither selected image nor profile image URL exists, display the SVG based on gender
              else if (widget.isGenderChange)
                CircleAvatar(
                  radius: 30.5,
                  child: SvgPicture.asset(
                    height: 60,
                    // Use the latest gender state to set the corresponding SVG file
                    selectedGender != null &&
                            selectedGender!.toLowerCase() == maleGenderValue
                        ? maleUserProfileSvgFilePath
                        : feamleUserProfileSvgFilePath,
                    fit: BoxFit.cover, // Ensure the SVG covers the avatar
                  ),
                ),
              // Camera icon for changing the image
              Positioned(
                top: 36,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    openBottomSheet(context);
                  },
                  child: buildCircle(
                    color: theme.primaryColor,
                    all: 2,
                    child: buildCircle(
                      color: theme.shadowColor,
                      all: 2,
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: theme.primaryColorDark,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
  }


//delete Dialog box function
  void _showDeleteConfirmationDialog() {
    Future.delayed(const Duration(milliseconds: 100), () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
              child: CustomPopupDialog(
            title: "Remove Profile Image",
            message: "Are you sure you want to delete this profile image?",
            confirmButtonText: "Delete",
            cancelButtonText: "Cancel",
            onConfirm: () {
              Navigator.of(context).pop(); // Dismiss the dialog

              widget.onProfileImageDelete();
            },
            onCancel: () {
              Navigator.pop(context);
            },
          ));
        },
      );
    });
  }

  // Check and request camera permissions.
  Future<bool> checkAndRequestCameraPermissions() async {
    PermissionStatus cameraPermissionStatus = await Permission.camera.status;

    if (cameraPermissionStatus == PermissionStatus.granted) {
      // Permission is already granted
      return true;
    } else if (cameraPermissionStatus == PermissionStatus.denied) {
      // Request camera permission
      PermissionStatus permissionStatus = await Permission.camera.request();
      return permissionStatus == PermissionStatus.granted;
    } else if (cameraPermissionStatus == PermissionStatus.permanentlyDenied) {
      // If permission is permanently denied, direct the user to app settings
      openAppSettings();
      return false;
    }

    return false; // Default: permission not granted
  }

  // Check and request camera permissions.
  Future<void> _pickImage(source) async {
    final theme = Theme.of(context);

    final picker = ImagePicker();
    try {
      setState(() {
        _isLoading = true; // Start loader
      });

      bool cameraPermissionGranted = await checkAndRequestCameraPermissions();

      if (cameraPermissionGranted) {
        final pickedImage =
            await picker.pickImage(source: source, imageQuality: 50);

        CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedImage!.path,
          // aspectRatioPresets: [
          //   CropAspectRatioPreset.square,
          // ],
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: 'Cropper',
                toolbarColor: theme.appBarTheme.backgroundColor,
                toolbarWidgetColor: theme.primaryColorDark,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            IOSUiSettings(
              title: 'Edit Image',
              aspectRatioLockEnabled: true, // Lock aspect ratio on iOS
            ),
            WebUiSettings(
              context: context,
            ),
          ],
        );

        setState(() {
          _image = File(croppedFile!.path);
          widget.onImageSelected(_image);
          _isLoading = false; // Stop loader
        });
            } else {
        if (await Permission.camera.status == PermissionStatus.denied) {
          _showPermissionDeniedDialog();
        }
      }
    } on PlatformException catch (e) {
      if (e.code == 'photo_access_denied') {
        _showPermissionDeniedDialog();
      } else {
        print("Error ${e.toString()}");
      }
    } finally {
      setState(() {
        _isLoading = false; // Stop loader even in case of error
      });
    }
  }

  // Show dialog for denied camera permissions.
  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
            child: CustomPopupDialog(
          title: 'Camera Permission Required',
          message:
              'We need access to your camera so you can take photos to upload content and update your profile.',
          confirmButtonText: 'Open Settings',
          cancelButtonText: "Cancel",
          onConfirm: () {
            openAppSettings();
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        ));
      },
    );
  }
}

Widget buildCircle({
  required Widget child,
  required double all,
  required Color color,
}) =>
    ClipOval(
      child: Container(
        padding: EdgeInsets.all(all),
        color: color,
        child: child,
      ),
    );
