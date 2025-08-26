import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:research_mantra_official/constants/assets.dart';
import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/constants/storage.dart';
import 'package:research_mantra_official/data/models/blogs/get_report_reason_model.dart';
import 'package:research_mantra_official/data/models/community/community_data_model.dart';
import 'package:research_mantra_official/data/models/image_model.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/blogs/main/report/report_provider.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';
import 'package:research_mantra_official/ui/components/button.dart';
import 'package:research_mantra_official/ui/components/community/common_post_screen.dart';
import 'package:research_mantra_official/ui/components/expanded/expanded_widget.dart';
import 'package:research_mantra_official/ui/components/image_gallery/common_image_slider.dart';
import 'package:research_mantra_official/ui/components/popupscreens/user_blocked_popup/user_block_popup.dart';
import 'package:research_mantra_official/ui/screens/blogs/screens/comments/comments.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/ui/screens/blogs/widget/link_icon_widget.dart';
import 'package:research_mantra_official/ui/screens/profile/widgets/full_screen_image_dialog.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';
import 'package:research_mantra_official/utils/genric_utils.dart';
import 'package:research_mantra_official/utils/utils.dart';
import 'package:like_button/like_button.dart';
import 'package:research_mantra_official/providers/community/all_community/all_community_provider.dart';

class PostTile extends ConsumerStatefulWidget {
  final Post announcement;
  const PostTile({super.key, required this.announcement});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PostTileState();
}

class _PostTileState extends ConsumerState<PostTile> {
  bool isExpanded = false;
  bool isAdmin = false;
  final UserSecureStorageService _userDetails = UserSecureStorageService();
  String? objectId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      objectId = await _userDetails.getUserObjectId();
    });
  }

  // Function to show full-screen image
  void showFullScreenImage(
      BuildContext context, imageUrl, ImageProvider imageProvider) {
    Navigator.of(context).push(MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return FullScreenImageDialog(
              imageProvider: imageProvider, imageUrl: '');
        },
        fullscreenDialog: true));
  }

  void handleLikeUnLike(WidgetRef ref) async {
    final String? objectId = await userDetails.getUserObjectId();
    final bool like = widget.announcement.userHasLiked ? false : true;
    final id = widget.announcement.id;

    ref
        .read(allCommunityDataNotifierProvider.notifier)
        .manageLikeUnLikeCommunityPostById(objectId!, id!, like);
  }

  void handleDelete(BuildContext context) {
    ref.read(allCommunityDataNotifierProvider.notifier).deleteCommunityPost(
          widget.announcement.productId.toString() ?? "",
          widget.announcement.id ?? '',
        );
    Navigator.pop(context);
  }

  void handleToBlockUser(BuildContext context) async {
    final String mobileUserPublicKey = await userDetails.getPublicKey();
    

    ref.read(allCommunityDataNotifierProvider.notifier).blockCommunityUser(
        mobileUserPublicKey,
        (widget.announcement.userObjectId ?? "").toString(),
        "block");
    Navigator.pop(context);
  }

  void showBlockUserPopup(createdBy, context) async {
    Navigator.pop(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomUserBlock(
          name: widget.announcement.title ?? "",
          profileImage: widget.announcement.imageUrl,
          gender: widget.announcement.gender ?? "",
          confirmButtonText: 'Block',
          cancelButtonText: 'Cancel',
          onConfirm: () => handleToBlockUser(context),
          onCancel: () {},
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fontSize = MediaQuery.of(context).size.width;
    final List<GetReportReasonModel> getReportData =
        ref.watch(getReportNotifierProvider).reportResponseModel ?? [];
    final int likesCount = widget.announcement.likecount ?? 0;
    final String likes = formatLikesCount(likesCount);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            widget.announcement.isadminposted
                ? CircleAvatar(
                    backgroundImage: AssetImage(contentProductImage),
                    radius: 24,
                  )
                : CircleAvatar(
                    radius: 18,
                    child: SvgPicture.asset(
                      height: 40,
                      widget.announcement.gender.toString().toLowerCase() ==
                              maleGenderValue
                          ? maleUserProfileSvgFilePath
                          : feamleUserProfileSvgFilePath,
                      fit: BoxFit.fill,
                    ),
                  ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.announcement.title ?? "",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: fontSize * 0.03,
                            fontFamily: fontFamily,
                            color: theme.primaryColorDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    "${widget.announcement.isadminposted ? "Admin " : ""}${Utils.formatDateTime(dateTimeString: widget.announcement.createdOn ?? DateTime.now().toString(), format: ddmmyy)}",
                    style: TextStyle(
                      fontSize: fontSize * 0.025,
                      color: theme.focusColor,
                    ),
                  ),
                ],
              ),
            ),
            if (widget.announcement.isadminposted != true) ...[
              InkWell(
                  onTap: widget.announcement.isUserReported == true
                      ? null
                      : () {
                          _showInfoDialog(context, getReportData,
                              widget.announcement.isUserReported ?? false, ref);
                        },
                  child: Icon(Icons.more_horiz,
                      color: theme.focusColor, size: 30)),
            ],
          ],
        ),
        SizedBox(height: 10),
        ExpandableText(
          text: widget.announcement.content,
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
        SizedBox(height: 10),
        if (widget.announcement.imageUrls != null &&
            widget.announcement.imageUrls?.length != 0) ...[
          ImageGalleryWidget(
            aspectRatio: '1.0',
            images: widget.announcement.imageUrls!
                .map((img) => ImageItem(
                      name: img.name,
                      aspectRatio: img.aspectRatio,
                    ))
                .toList(),
          ),
        ],
        if (widget.announcement.url != null &&
            widget.announcement.url!.trim().isNotEmpty) ...[
          LinkWidget(
              url: widget.announcement.url ?? "",
              text: widget.announcement.url ?? "",
              icon: Icons.link),
        ],
        SizedBox(
          height: 5,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LikeButton(
              size: 25,
              isLiked: widget.announcement.userHasLiked,
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
                // Handle the like/unlike action
                handleLikeUnLike(ref);
                return !isLiked;
              },
            ),
            Container(
              width: 30,
              margin: const EdgeInsets.only(top: 2),
              child: Text(
                likes.toString(),
                key: ValueKey(likes),
                style: TextStyle(color: Theme.of(context).focusColor),
              ),
            ),
            const SizedBox(width: 30),
            (widget.announcement.enableComments ?? true)
                ? InkWell(
                    onTap: () {
                      Navigator.of(context).push(_navigateToCommentScreen());
                    },
                    child: SizedBox(
                      width: 50,
                      child: Row(
                        children: [
                          FaIcon(FontAwesomeIcons.comment,
                              color: theme.focusColor, size: 20),
                          const SizedBox(width: 5),
                          Text(
                            widget.announcement.commentsCount.toString() ?? "0",
                            style: TextStyle(color: theme.focusColor),
                          ),
                        ],
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ],
    );
  }

  Route _navigateToCommentScreen() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => CommentsScreen(
              endpoint: postAddCommunityendpoint,
              blogId: (widget.announcement.id ?? 0).toString(),
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

  void _showInfoDialog(
      BuildContext context,
      List<GetReportReasonModel?> getReportData,
      bool isBeingReported,
      WidgetRef ref) async {
    final theme = Theme.of(context);
    final String? userId = await userDetails.getUserObjectId();

    DateTime currentTime = DateTime.now();
    String createdOn =
        widget.announcement.createdOn ?? DateTime.now().toString();
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (userId == widget.announcement.userObjectId) ...[
                        _buildDialogOption(
                          icon: (widget.announcement.enableComments ?? false)
                              ? Icons.comments_disabled_outlined
                              : Icons.comment_outlined,
                          label: (widget.announcement.enableComments ?? false)
                              ? "Turn off commenting"
                              : "Turn on commenting",
                          onTap: () {
                            ref
                                .read(allCommunityDataNotifierProvider.notifier)
                                .enableorDisableComment(
                                  widget.announcement.id ?? '',
                                  widget.announcement.userObjectId ?? '',
                                  (widget.announcement.enableComments ?? false)
                                      ? false
                                      : true,
                                );
                            Navigator.of(context).pop();
                          },
                          theme: theme,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                      if (userId != widget.announcement.userObjectId &&
                          getReportData.isNotEmpty) ...[
                        _buildDialogOption(
                          icon: Icons.report_outlined,
                          label: widget.announcement.isUserReported == true
                              ? "Reported"
                              : "Report",
                          onTap: widget.announcement.isUserReported == true
                              ? null
                              : () {
                                  Navigator.of(context).pop();
                                  reportPopup(context, blogPosition,
                                      getReportData, ref);
                                },
                          theme: theme,
                          isDisabled:
                              widget.announcement.isUserReported == true,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                      if (userId != widget.announcement.userObjectId)
                        _buildDialogOption(
                          icon: Icons.lock_person_outlined,
                          label: "Block User",
                          onTap: () => showBlockUserPopup(
                              widget.announcement.userObjectId ?? '', context),
                          theme: theme,
                        ),
                      if (userId == widget.announcement.userObjectId &&
                          differenceInMin <= 30) ...[
                        _buildDialogOption(
                          icon: Icons.edit_outlined,
                          label: "Edit",
                          onTap: () {
                            Navigator.pop(context);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CommonPostScreen(
                                  existingContent:
                                      widget.announcement.content ?? '',
                                  existingBlogId: widget.announcement.id ?? '',
                                  onPostSuccess: (aspectRatio) {
                                    // scrollController.animateTo(0,
                                    //     duration:
                                    //         const Duration(milliseconds: 200),
                                    //     curve: Curves.easeOut);
                                  },
                                  existingImages: widget.announcement.imageUrls
                                      ?.map((imageDetail) => imageDetail.name)
                                      .toList(),
                                  isPostType: 'comm',
                                  productId: widget.announcement.productId
                                          ?.toString() ??
                                      '',
                                ),
                              ),
                            );
                          },
                          theme: theme,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                      if (userId == widget.announcement.userObjectId) ...[
                        _buildDialogOption(
                          icon: Icons.delete_outline,
                          label: "Delete",
                          onTap: () => handleDelete(context),
                          theme: theme,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                      ]
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

  // Report Pop up
  void reportPopup(BuildContext context, Offset blogPosition,
      List<GetReportReasonModel?> getReportData, WidgetRef ref) {
    final theme = Theme.of(context);
    int selectedIndex = 0;
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
                                    .read(allCommunityDataNotifierProvider
                                        .notifier)
                                    .reportCommunityPost(
                                        widget.announcement.id ?? "",
                                        objectId ?? "",
                                        getReportData[selectedIndex]?.id ?? "");
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
}
