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
import 'package:research_mantra_official/providers/images/dashboard/dashboard_provider.dart';
import 'package:research_mantra_official/providers/userpersonaldetails/user_personal_details_provider.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';
import 'package:research_mantra_official/ui/components/cacher_network_images/circular_cached_network_image.dart';
import 'package:research_mantra_official/ui/components/words/negative_words.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';
import 'package:research_mantra_official/utils/utils.dart';

class PostScreen extends ConsumerStatefulWidget {
  final String existingContent;
  final String existingBlogId;
  final List<String>? existingImages;

  final Function() onPostSuccess;
  const PostScreen({
    super.key,
    required this.existingContent,
    required this.existingBlogId,
    required this.existingImages,
    required this.onPostSuccess,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BlogPostScreenState();
}

class _BlogPostScreenState extends ConsumerState<PostScreen> {
  final TextEditingController _contentController = TextEditingController();
  final UserSecureStorageService _userDetails = UserSecureStorageService();

  List<XFile> files = [];

  bool isLoading = false;
  String? userProfileImage;
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

  //function for get userProfileImage init
  Future<void> _fetchUserProfileImage() async {
    final UserSecureStorageService userDetails = UserSecureStorageService();
    final Map<String, dynamic> commentedUsername =
        await userDetails.getUserDetails();
    setState(() {
      userProfileImage = commentedUsername['profileImage'];
      existingPostImages = widget.existingImages;
    });
  }

  // Method to update content
  void updateContent(String newContent) {
    setState(() {
      _contentController.text = newContent;
    });
  }

//Todo: We have to change (getting all the image sizes)
  Future<void> handleBlogPost() async {
    final String mobileUserPublicKey = await _userDetails.getPublicKey();
    await ref
        .read(getBlogPostNotifierProvider.notifier)
        .getBlogPosts(mobileUserPublicKey, 1, false);
  }

//function for blog post
  void handlePostBlog(context) async {
    final Map<String, dynamic> commentedUsername =
        await _userDetails.getUserDetails();
    final String userFullName = commentedUsername['fullName'];
    final String? userProfileImage = commentedUsername['profileImage'];

    if ((_contentController.text.trim().isNotEmpty || files != null)) {
      // Navigator.pop(context);
      widget.onPostSuccess();
      final String? objectId = await _userDetails.getUserObjectId();
      // Convert XFile objects to File objects
      List<File>? fileList = files.map((xFile) => File(xFile.path)).toList();

      await ref.read(getBlogPostNotifierProvider.notifier).manageBlogPosts(
          objectId!,
          _contentController.text.trim(),
          "", //Todo:as of now we are not passing any #hashTag ,
          fileList,
          aspectRatios,
          userFullName,
          (userProfileImage != null) ? userProfileImage : '');
    }
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

    ref.read(getBlogPostNotifierProvider.notifier).editBlogPost(
          blogId,
          userObjectId!,
          _contentController.text,
        );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Column(
                  children: [
                    _buildContent(context),
                    ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap:
                          true, // Allows the ListView to size dynamically
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount:
                          files.length + (widget.existingImages?.length ?? 0),
                      itemBuilder: (context, index) {
                        if (index < files.length) {
                          // Display newly selected images
                          return Padding(
                            padding: const EdgeInsets.only(left: 50, right: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () => clearSelectedImage(index),
                                  child: Icon(
                                    Icons.cancel,
                                    color: theme.primaryColorDark,
                                  ),
                                ),
                                AspectRatio(
                                  aspectRatio: 1,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      File(files[index].path),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          // Display existing images
                          final existingIndex = index - files.length;
                          final existingImage =
                              widget.existingImages![existingIndex];
                          return AspectRatio(
                            aspectRatio: 1,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                "$getBlogImageApi?imageName=$existingImage",
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          widget.existingBlogId.isEmpty
              ? _buildBottomNavigationBar(context)
              : Container(),
        ],
      ),
    );
  }

// Widget for writing content
  Widget _buildContent(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider);

    final userDetails = ref.watch(getUserPersonalDetailsStateNotifierProvider);
    // Ensure userPersonalDetails is not null
    final selectedGender =
        userDetails.userPersonalDetails?.gender ?? userProfile.selectedGender;
    final theme = Theme.of(context);
    _contentController.addListener(() {
      setState(() {});
    });
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          width: 8,
        ),
        Container(
          margin: const EdgeInsets.only(top: 3),
          child: userProfileImage != null
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
                    selectedGender.toString().toLowerCase() == maleGenderValue
                        ? maleUserProfileSvgFilePath
                        : feamleUserProfileSvgFilePath,
                    fit: BoxFit.fill,
                  ),
                ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(
              left: 10,
            ),
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              controller: _contentController,
              maxLength: 2000,
              autofocus: true,
              style: TextStyle(
                color: theme.primaryColorDark,
                fontFamily: fontFamily,
                fontSize: 14,
              ),
              maxLines: null,
              decoration: const InputDecoration(
                counterText: '',
                border: InputBorder.none,
                hintText: postHintText,
                hintStyle: TextStyle(fontSize: 14, fontFamily: fontFamily),
              ),
            ),
          ),
        ),
      ],
    );
  }

  //widget for AppBar
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            height: 1.0,
            color: theme.primaryColor,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 25,
            color: theme.primaryColorDark,
          ),
        ),
        title: Row(
          children: [
            const Spacer(),
            if (files.isNotEmpty || _contentController.text.trim().isNotEmpty)
              if (!hasBadWords)
                TextButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: theme.indicatorColor),
                    onPressed: () {
                      widget.existingBlogId.isEmpty
                          ? handlePostBlog(context)
                          : handleBlogEditPost(context, widget.existingBlogId);
                    },
                    child: Text(
                      "Post",
                      style: TextStyle(
                          fontSize: 12,
                          color:
                              theme.floatingActionButtonTheme.foregroundColor,
                          fontWeight: FontWeight.bold),
                    )),
          ],
        ));
  }

  // Widget for BottomNavigation
  Widget _buildBottomNavigationBar(BuildContext context) {
    final theme = Theme.of(context);

    // Helper method to handle image picking
    Future<void> handleImagePick({
      required Future<Map<String, dynamic>?> Function(BuildContext)
          pickerFunction,
      required bool isCamera,
    }) async {
      if (!isCamera && files.length > 2) {
        ToastUtils.showToast(imageLimitText, "");
        return;
      }

      final body = await pickerFunction(context);
      if (body != null) {
        XFile xFile = body['file'];
        String aspectRatio = body['aspectRatio'];

        setState(() {
          files.add(xFile);
          aspectRatios.add(aspectRatio);
        });
      }
    }

    // Button widget for reusability
    Widget buildIconButton({
      required IconData icon,
      required VoidCallback onTap,
      required String isType,
    }) {
      return Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.primaryColor,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: theme.shadowColor,
                width: 1,
              ),
            ),
            child: GestureDetector(
              onTap: onTap,
              child: Icon(
                icon,
                size: 25,
                color: theme.primaryColorDark,
              ),
            ),
          ),
          Text(
            isType,
            style: TextStyle(
              color: theme.primaryColorDark,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: theme.appBarTheme.backgroundColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Select from camera
          Column(
            children: [
              buildIconButton(
                icon: Icons.camera_alt_outlined,
                onTap: () => handleImagePick(
                  pickerFunction: Utils.pickImageFromCamera,
                  isCamera: true,
                ),
                isType: 'Camera',
              ),
            ],
          ),
          // Select from gallery
          Column(
            children: [
              buildIconButton(
                icon: Icons.photo_library_outlined,
                onTap: () => handleImagePick(
                  pickerFunction: Utils.pickImageFromGallery,
                  isCamera: false,
                ),
                isType: 'Gallery',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
