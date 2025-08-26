import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:research_mantra_official/constants/assets.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/data/models/blogs/blog_api_response_model.dart';
import 'package:research_mantra_official/data/models/blogs/get_report_reason_model.dart';
import 'package:research_mantra_official/data/models/image_model.dart';
import 'package:research_mantra_official/providers/blogs/main/blogs_provider.dart';
import 'package:research_mantra_official/providers/blogs/main/report/report_provider.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';
import 'package:research_mantra_official/ui/components/button.dart';
import 'package:research_mantra_official/ui/components/cacher_network_images/circular_cached_network_image.dart';
import 'package:research_mantra_official/ui/components/image_gallery/common_image_slider.dart';
import 'package:research_mantra_official/ui/components/community/common_post_screen.dart';
import 'package:research_mantra_official/ui/components/expanded/expanded_widget.dart';
import 'package:research_mantra_official/ui/components/king_research_loader/loaders.dart';
import 'package:research_mantra_official/ui/components/popupscreens/user_blocked_popup/user_block_popup.dart';
import 'package:research_mantra_official/ui/screens/blogs/screens/comments/comments.dart';

import 'package:research_mantra_official/ui/themes/text_styles.dart';
import 'package:research_mantra_official/utils/genric_utils.dart';
import 'package:research_mantra_official/utils/utils.dart';
import 'package:like_button/like_button.dart';

class SingleBlogItemWidget extends ConsumerStatefulWidget {
  final Blogs? post;
  final String? userObjectId;
  final String aspectRatios;

  const SingleBlogItemWidget({
    super.key,
    required this.post,
    required this.userObjectId,
    required this.aspectRatios,
  });

  @override
  ConsumerState<SingleBlogItemWidget> createState() => _SingleBlogItemWidget();
}

class _SingleBlogItemWidget extends ConsumerState<SingleBlogItemWidget> {
  int selectedIndex = 0;
  Key carouselKey = UniqueKey();

  bool isComments = false;
  final ScrollController scrollController = ScrollController();
  final UserSecureStorageService userDetails = UserSecureStorageService();
  bool isExpanded = false;

  //function for manage like unlike
  void handleLikeUnLike(WidgetRef ref) async {
    final String? objectId = await userDetails.getUserObjectId();
    final bool like = widget.post!.userHasLiked ? false : true;
    final id = widget.post!.objectId;
    ref
        .read(getBlogPostNotifierProvider.notifier)
        .manageLikeUnLikeBlogById(objectId!, id, like, null);
  }

  bool userActivity = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await getReportDataApi();
      if (!mounted) return;
      getUserActivity();
    });
  }

  Future<void> getReportDataApi() async {
    final reportNotifier = ref.read(getReportNotifierProvider.notifier);
    final reportResponseModel =
        ref.read(getReportNotifierProvider).reportResponseModel;

    int length = reportResponseModel?.length ?? 0;

    if (reportResponseModel == null || length == 0) {
      if (!mounted) return;
      await reportNotifier.getReport();
    }
  }

//Check user is active or blocked
  getUserActivity() async {
    userActivity = await userDetails.fetchUserActivity();
  }

//function for delete
  void handleDelete(context) async {
    final String? userId = await userDetails.getUserObjectId();
    ref
        .read(getBlogPostNotifierProvider.notifier)
        .deleteBlogPost(widget.post!.objectId, userId!);
    Navigator.of(context).pop();
  }

//Function to block user
  void handleToBlockUser(createdBy, context) async {
    final String mobileUserPublicKey = await userDetails.getPublicKey();

    await ref
        .read(getBlogPostNotifierProvider.notifier)
        .blockUser(mobileUserPublicKey, createdBy, "block");
    Navigator.pop(context);
  }

  void showBlockUserPopup(createdBy) async {
    Navigator.pop(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomUserBlock(
          name: widget.post!.userFullName!,
          profileImage: widget.post!.userProfileImage,
          gender: widget.post!.gender,
          confirmButtonText: 'Block',
          cancelButtonText: 'Cancel',
          onConfirm: () => handleToBlockUser(createdBy, context),
          onCancel: () {},
        );
      },
    );
  }

  // Report Pop up
  void reportPopup(BuildContext context, Offset blogPosition,
      List<GetReportReasonModel?> getReportData) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Material(
                    elevation: 1,
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.1,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: theme.primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Report Issues ",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: theme.primaryColorDark,
                                  fontFamily: fontFamily,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: getReportData.length ?? 0,
                              itemBuilder: (context, index) {
                                return Row(
                                  children: [
                                    SizedBox(
                                      height: 30,
                                      child: Radio(
                                          splashRadius: 0.2,
                                          value: index,
                                          groupValue: selectedIndex,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedIndex = value as int;
                                            });
                                          }),
                                    ),
                                    Flexible(
                                      child: Text(
                                        getReportData[index]?.reason ?? "",
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: theme.primaryColorDark,
                                          fontFamily: fontFamily,
                                          // Limit the number of lines

                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Button(
                              text: "Submit",
                              onPressed: () async {
                                Navigator.pop(context);

                                await ref
                                    .read(getBlogPostNotifierProvider.notifier)
                                    .postReportReasonBlog(
                                        blogId: widget.post?.objectId ?? "",
                                        reportedby: widget.userObjectId ?? "",
                                        reasonId:
                                            getReportData[selectedIndex]?.id ??
                                                "");
                              },
                              textColor: theme.primaryColor,
                              backgroundColor: theme.indicatorColor,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showInfoDialog(BuildContext context,
      List<GetReportReasonModel?> getReportData, bool isBeingReported) async {
    final theme = Theme.of(context);
    final String? userId = await userDetails.getUserObjectId();

    DateTime currentTime = DateTime.now();
    String createdOn = widget.post!.createdOn;
    DateTime createdTime = parseDateTime(createdOn);
    int differenceInMin = currentTime.difference(createdTime).inMinutes;

    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Offset blogPosition = renderBox.localToGlobal(Offset.zero);

    double dialogPosition =
        MediaQuery.of(context).size.height - blogPosition.dy > 180
            ? blogPosition.dy + 5
            : blogPosition.dy - 100;

    showDialog(
      context: context,
      builder: (context) => GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: SizedBox(
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Positioned(
                top: dialogPosition,
                right: blogPosition.dx + 5,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.appBarTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    spacing: 8,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (userId == widget.post!.createdBy)
                        _buildDialogOption(
                          icon: widget.post!.enableComments
                              ? Icons.comments_disabled_outlined
                              : Icons.comment_outlined,
                          label: widget.post!.enableComments
                              ? "Turn off commenting"
                              : "Turn on commenting",
                          onTap: () {
                            ref
                                .read(getBlogPostNotifierProvider.notifier)
                                .manageCommentsDisableAndEnableByBlogId(
                                  widget.post!.objectId,
                                  widget.post!.createdBy,
                                  widget.post!.enableComments,
                                );
                            Navigator.of(context).pop();
                          },
                          theme: theme,
                        ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      if (userId != widget.post?.createdBy &&
                          getReportData.isNotEmpty)
                        _buildDialogOption(
                          icon: Icons.report_outlined,
                          label: widget.post?.isUserReported == true
                              ? "Reported"
                              : "Report",
                          onTap: widget.post?.isUserReported == true
                              ? null
                              : () {
                                  Navigator.of(context).pop();
                                  reportPopup(
                                      context, blogPosition, getReportData);
                                },
                          theme: theme,
                          isDisabled: widget.post?.isUserReported == true,
                        ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      if (userId != widget.post!.createdBy)
                        _buildDialogOption(
                          icon: Icons.lock_person_outlined,
                          label: "Block User",
                          onTap: () =>
                              showBlockUserPopup(widget.post!.createdBy),
                          theme: theme,
                        ),
                      if (userId == widget.post!.createdBy &&
                          differenceInMin <= 30)
                        _buildDialogOption(
                          icon: Icons.edit_outlined,
                          label: "Edit",
                          onTap: () {
                            Navigator.pop(context);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CommonPostScreen(
                                  existingContent: widget.post?.content ?? '',
                                  existingBlogId: widget.post?.objectId ?? '',
                                  onPostSuccess: (aspectRatio) {
                                    scrollController.animateTo(0,
                                        duration:
                                            const Duration(milliseconds: 200),
                                        curve: Curves.easeOut);
                                  },
                                  existingImages: widget.post?.image
                                      ?.map((imageDetail) => imageDetail.name)
                                      .toList(),
                                  isPostType: 'blog',
                                ),
                              ),
                            );
                          },
                          theme: theme,
                        ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      if (userId == widget.post!.createdBy)
                        _buildDialogOption(
                          icon: Icons.delete_outline,
                          label: "Delete",
                          onTap: () => handleDelete(context),
                          theme: theme,
                        ),
                      // const SizedBox(
                      //   height: 5,
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDialogOption({
    required IconData icon,
    required String label,
    required ThemeData theme,
    VoidCallback? onTap,
    bool isDisabled = false,
  }) {
    return Material(
      color: theme.appBarTheme.backgroundColor,
      child: InkWell(
        onTap: isDisabled ? null : onTap,
        child: Row(
          children: [
            Icon(icon,
                color:
                    isDisabled ? theme.disabledColor : theme.primaryColorDark),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color:
                    isDisabled ? theme.disabledColor : theme.primaryColorDark,
                fontFamily: fontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }

//NavigateToCommentScreen
  Route _navigateToCommentScreen() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => CommentsScreen(
              blogId: widget.post!.objectId,
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const start = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween =
              Tween(begin: start, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final List<ImageDetails>? image = widget.post!.image;
    final int likesCount = widget.post!.likesCount;
    final String likes = formatLikesCount(likesCount);
    final List<GetReportReasonModel> getReportData =
        ref.watch(getReportNotifierProvider).reportResponseModel ?? [];

    bool isReported =
        ref.watch(getBlogPostNotifierProvider).isBeingReported ?? false;
    final fontSize = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.only(top: 8, right: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.shadowColor, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// User Profile &  Options
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.post!.userProfileImage!.isNotEmpty)
                      CircularCachedNetworkImage(
                          imageURL: widget.post!.userProfileImage ?? '',
                          size: 40,
                          borderColor: Colors.transparent,
                          type: 'blog',
                          gender: widget.post!.gender),
                    if (widget.post!.userProfileImage!.isEmpty)
                      CircleAvatar(
                        radius: 18,
                        child: SvgPicture.asset(
                          height: 40,
                          widget.post!.gender.toString().toLowerCase() ==
                                  maleGenderValue
                              ? maleUserProfileSvgFilePath
                              : feamleUserProfileSvgFilePath,
                          fit: BoxFit.fill,
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: widget.post!.userFullName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: fontSize * 0.03,
                                      fontFamily: fontFamily,
                                      color: theme.primaryColorDark,
                                    ),
                                  ),
                                  const TextSpan(text: '  '),
                                  TextSpan(
                                    text: widget.post!.postedAgo,
                                    style: TextStyle(
                                      fontSize: fontSize * 0.025,
                                      color: theme.focusColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // if (widget.userObjectId == widget.post!.createdBy)
                          Visibility(
                            visible: widget.post!.isPinned == true,
                            child: Icon(Icons.push_pin_rounded,
                                color: theme.disabledColor, size: 20),
                          ),

                          const SizedBox(width: 10),
                          InkWell(
                            onTap: isReported
                                ? () {}
                                :
                                // getReportData.isNotEmpty
                                //     ?
                                () => _showInfoDialog(
                                    context, getReportData, isReported)
                            // : () {}
                            ,
                            child: Icon(
                              Icons.more_horiz,
                              color: theme.primaryColorDark,
                              size: 25,
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ExpandableText(
                        text: widget.post?.content,
                        trimLength: 400,
                        textStyle: TextStyle(
                          fontSize: fontSize * 0.03,
                          fontFamily: fontFamily,
                          color: theme.primaryColorDark,
                        ),
                        linkStyle: TextStyle(
                          fontSize: fontSize * 0.03,
                          fontWeight: FontWeight.w600,
                          fontFamily: fontFamily,
                          color: theme.indicatorColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (image != null && image.isNotEmpty)
                      ImageGalleryWidget(
                        aspectRatio: widget.aspectRatios,
                        images: image
                            .map((img) => ImageItem(
                                  name: img.name,
                                  aspectRatio: img.aspectRatio,
                                ))
                            .toList(),
                      ),
                    _buildLikesCommentsShare(theme, likes, widget.post)
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //Widget for Likes ,Comments and Share
  Widget _buildLikesCommentsShare(theme, likes, post) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left side: Like and Comment
          Row(
            children: [
              // Like Button + Count
              LikeButton(
                size: 20,
                isLiked: widget.post!.userHasLiked,
                likeBuilder: (bool isLiked) {
                  return FaIcon(
                    isLiked
                        ? FontAwesomeIcons.solidHeart
                        : FontAwesomeIcons.heart,
                    color: isLiked
                        ? theme.disabledColor.withAlpha(180)
                        : theme.focusColor,
                    size: 20,
                  );
                },
                onTap: (bool isLiked) async {
                  handleLikeUnLike(ref);
                  return !isLiked;
                },
              ),
              const SizedBox(width: 4),
              // --- Fixed width for Likes count ---
              SizedBox(
                width: 30, // Adjust this width as needed
                child: Text(
                  likes.toString(),
                  key: ValueKey(likes),
                  style: TextStyle(
                    color: theme.focusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(width: 20),

              // Comment Icon + Count
              if (widget.post?.enableComments == true)
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(_navigateToCommentScreen());
                  },
                  child: Row(
                    children: [
                      FaIcon(FontAwesomeIcons.comment,
                          color: theme.focusColor, size: 20),
                      const SizedBox(width: 5),
                      // --- Fixed width for Comments count ---
                      SizedBox(
                        width: 30, // Adjust this width as needed
                        child: Text(
                          widget.post?.commentsCount.toString() ?? "0",
                          style: TextStyle(
                            color: theme.focusColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          // Right side: Share Icon
          SizedBox(
            child: GestureDetector(
              onTap: () {
                handleThrottledShare(
                  post.content,
                  post.image.map((e) => e.name).toList(),
                );
              },
              child: Icon(
                Icons.share_outlined,
                color: theme.focusColor,
                size: 25,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isSharing = false;

  Future<void> handleThrottledShare(content, images) async {
    if (_isSharing) return;
    _isSharing = true;
    // Show loader
    showLoadingDialog(context);

    await shareMultipleImagesWithText(content, images);
    hideLoadingDialog(context);
    await Future.delayed(Duration(seconds: 1));

    // Optional delay to prevent spamming

    _isSharing = false;
  }

// To hide the dialog:
  void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }
}
