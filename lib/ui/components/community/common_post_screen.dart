import 'dart:async';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:research_mantra_official/constants/assets.dart';
import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/providers/blogs/main/blogs_provider.dart';
import 'package:research_mantra_official/providers/community/all_community/all_community_provider.dart';
import 'package:research_mantra_official/providers/images/dashboard/dashboard_provider.dart';
import 'package:research_mantra_official/providers/userpersonaldetails/user_personal_details_provider.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';
import 'package:research_mantra_official/ui/components/cacher_network_images/circular_cached_network_image.dart';
import 'package:research_mantra_official/ui/components/community/create_post_app_bar.dart';
import 'package:research_mantra_official/ui/components/community/image_picker_bottom_sheet.dart';
import 'package:research_mantra_official/ui/components/words/negative_words.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';
import 'package:research_mantra_official/utils/utils.dart';

class CommonPostScreen extends ConsumerStatefulWidget {
  final String existingContent;
  final String existingBlogId;
  final List<String>? existingImages;
  final String isPostType;
  final String? productId;
  final Function(dynamic aspectRatio) onPostSuccess;

  const CommonPostScreen({
    super.key,
    required this.existingContent,
    required this.existingBlogId,
    required this.existingImages,
    required this.isPostType,
    required this.onPostSuccess,
    this.productId,
    // required this.onPostSuccess,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CommonPostScreenState();
}

class _CommonPostScreenState extends ConsumerState<CommonPostScreen> {
  final TextEditingController _contentController = TextEditingController();
  final UserSecureStorageService _userDetails = UserSecureStorageService();

  List<XFile> files = [];

  bool isLoading = false;
  String? userProfileImage;
  String? userFullName;

  int currentIndex = 0;
  List<String>? existingPostImages = [];
  bool hasBadWords = false;
  String? selectedGender;
  // Local variable to track bad word presence
  List<String> aspectRatios = [];
  Map<String, dynamic>? body;
  @override
  void initState() {
    super.initState();
    _fetchUserProfileImage();
    _contentController.text = widget.existingContent;
    _contentController.addListener(_onContentChanged); //

    _loadSelectedGender();
  }

//Function to get user details
  Future<void> _loadSelectedGender() async {
    await ref.read(userProfileProvider.notifier).loadUserProfile();
  }

// Listener method
  void _onContentChanged() {
    setState(() {
      // Update the local variable whenever the text changes
      hasBadWords = containBadwords(_contentController.text.toString());
    });
  }

  // Helper method to handle image picking
  Future<void> handleImagePick({
    required Future<Map<String, dynamic>?> Function(BuildContext)
        pickerFunction,
    required bool isCamera,
  }) async {
    if (files.length > 2) {
      // Replace with your actual Toast utility
      ToastUtils.showToast(imageLimitText, "");
      return;
    }

    final body = await pickerFunction(context);
    if (body != null) {
      XFile xFile = body['file'];
      String aspectRatio = body['aspectRatioLabel'];

      setState(() {
        files.add(xFile);
        aspectRatios.add(aspectRatio);
      });
    }
  }

  //function for get userProfileImage init
  Future<void> _fetchUserProfileImage() async {
    final UserSecureStorageService userDetails = UserSecureStorageService();
    final Map<String, dynamic> commentedUsername =
        await userDetails.getUserDetails();

    setState(() {
      userProfileImage = commentedUsername['profileImage'];
      existingPostImages = widget.existingImages;
      userFullName = commentedUsername['fullName'];
    });
  }

  // Method to update content
  void updateContent(String newContent) {
    setState(() {
      _contentController.text = newContent;
    });
  }

  void addCommunity(List<File>? imagelist, String userName) async {
    await ref.read(allCommunityDataNotifierProvider.notifier).postcommunityData(
          imagelist,
          aspectRatios,
          null,
          null,
          widget.productId ?? '',
          userName,
          _contentController.text.trim(),
        );
  }

  void editCommunity() async {
    await ref.read(allCommunityDataNotifierProvider.notifier).editcommunityData(
        widget.productId ?? '',
        _contentController.text.trim(),
        widget.existingBlogId);
  }

//function for blog post
  void handlePostBlog(context) async {
    final Map<String, dynamic> commentedUsername =
        await _userDetails.getUserDetails();
    final String userFullName = commentedUsername['fullName'];
    final String? userProfileImage = commentedUsername['profileImage'];

    if ((_contentController.text.trim().isNotEmpty || files != null)) {
      // widget.onPostSuccess();
      final String? objectId = await _userDetails.getUserObjectId();
      // Convert XFile objects to File objects
      List<File>? fileList = files.map((xFile) => File(xFile.path)).toList();

      Navigator.pop(context);
      if (widget.productId != null) {
        addCommunity(fileList, userFullName);
      } else {
        await ref.read(getBlogPostNotifierProvider.notifier).manageBlogPosts(
            objectId ?? '',
            _contentController.text.trim(),
            "", //Todo:as of now we are not passing any #hashTag ,
            fileList,
            aspectRatios,
            userFullName,
            (userProfileImage != null) ? userProfileImage : '');
      }
    }

    widget.onPostSuccess(aspectRatios);
  }

//clear selected image
  Future<void> clearSelectedImage(int index) async {
    setState(() {
      files.removeAt(index);
    });
  }

//function for edit blog post
  void handleBlogEditPost(context, String blogId) async {
    final String? userObjectId = await _userDetails.getUserObjectId();
    if (userObjectId != null) {
      if (widget.productId != null) {
        editCommunity();
      } else {
        ref.read(getBlogPostNotifierProvider.notifier).editBlogPost(
              blogId,
              userObjectId,
              _contentController.text,
            );
      }
    }

    Navigator.pop(context);
  }

  bool _isSubmitting = false;

  void onSubmit() async {
    if (_isSubmitting) return;

    _isSubmitting = true;

    if (widget.existingBlogId.isEmpty) {
      handlePostBlog(context);
    } else {
      handleBlogEditPost(context, widget.existingBlogId);
    }

    await Future.delayed(const Duration(milliseconds: 200));
    _isSubmitting = false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: CreatePostAppBar(
        onClose: () => Navigator.pop(context),
        onPost: onSubmit,
        shouldEnablePost:
            (files.isNotEmpty || _contentController.text.trim().isNotEmpty) &&
                !hasBadWords,
        isCommunity: widget.isPostType.toLowerCase() == "community",
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Column(
                children: [
                  _buildContent(context),
                  _buildImageDisplay(files, existingPostImages, theme),
                ],
              ),
            ),
          ),
          widget.existingBlogId.isEmpty
              ? ImagePickerOptions(
                  theme: theme,
                  onCameraTap: () async {
                    await handleImagePick(
                      pickerFunction: Utils.pickImageFromCamera,
                      isCamera: true,
                    );
                  },
                  onGalleryTap: () async {
                    await handleImagePick(
                      pickerFunction: Utils.pickImageFromGallery,
                      isCamera: false,
                    );
                  },
                )
              : Container(),
        ],
      ),
    );
  }

  //Widget for Images display what ever user selected
  Widget _buildImageDisplay(
      List<XFile> files, List<String>? existingPostImages, theme) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3, // Number of images per row
      crossAxisSpacing: 3,
      mainAxisSpacing: 3,
      children: List.generate(
        files.length + (widget.existingImages?.length ?? 0),
        (index) {
          if (index < files.length) {
            return Stack(
              alignment: Alignment.topRight,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Image.file(
                      File(files[index].path),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => clearSelectedImage(index),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    child: Icon(Icons.cancel,
                        size: 25, color: theme.primaryColorDark),
                  ),
                ),
              ],
            );
          } else {
            final existingIndex = index - files.length;
            final existingImage = widget.existingImages?[existingIndex] ?? '';
            return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: existingImage.startsWith('http')
                    ? Image.network(
                        existingImage,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(existingImage),
                        fit: BoxFit.cover,
                      ));
          }
        },
      ),
    );
  }

// Widget for writing content
  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final userProfile = ref.watch(userProfileProvider);
    final userDetails = ref.watch(getUserPersonalDetailsStateNotifierProvider);

    final selectedGender =
        userDetails.userPersonalDetails?.gender ?? userProfile.selectedGender;

    _contentController.addListener(() {
      setState(() {});
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Profile Image
              userProfileImage != null
                  ? CircularCachedNetworkImage(
                      imageURL:
                          '$getprofileImage?profileImage=${userProfileImage!}',
                      size: 45,
                      borderColor: theme.shadowColor,
                      type: 'profile',
                    )
                  : CircleAvatar(
                      radius: 20,
                      child: SvgPicture.asset(
                        height: 50,
                        selectedGender?.toLowerCase() == maleGenderValue
                            ? maleUserProfileSvgFilePath
                            : feamleUserProfileSvgFilePath,
                        fit: BoxFit.fill,
                      ),
                    ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  userFullName ?? "Hello User",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: theme.primaryColorDark,
                  ),
                ),
              ),
            ],
          ),
          // Description Field
          TextField(
            controller: _contentController,
            autofocus: true,
            maxLength: 2000,
            maxLines: null,
            textCapitalization: TextCapitalization.sentences,
            style: TextStyle(
                color: theme.primaryColorDark,
                fontFamily: fontFamily,
                fontSize: 14,
                fontWeight: FontWeight.w500),
            decoration: const InputDecoration(
              counterText: '',
              border: InputBorder.none,
              hintText: postHintText,
              hintStyle: TextStyle(fontSize: 14, fontFamily: fontFamily),
            ),
          ),
        ],
      ),
    );
  }
}
