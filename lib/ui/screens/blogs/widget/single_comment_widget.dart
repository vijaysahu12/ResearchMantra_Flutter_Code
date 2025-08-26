// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:research_mantra_official/constants/assets.dart';
import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/data/models/blogs/blog_comments_api_response_model.dart';
import 'package:research_mantra_official/providers/blogs/comment/comments_provider.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';
import 'package:research_mantra_official/ui/components/cacher_network_images/circular_cached_network_image.dart';
import 'package:research_mantra_official/ui/screens/blogs/screens/comments/comment_list.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

class SingleCommentWidget extends ConsumerStatefulWidget {
  final BlogCommentsModel comments;
  final Function(CommentActions newAction) handleActionsChange;
  final VoidCallback onEditCommentTap;
  final Function(String objectId, String content) onEditCommentReplyTap;
  final Function(String commentUserName) handleCommentUserName;
  final void Function() handleTofoucs;
  final String? userObjectId;
  final Function(String commentId) onReplyTap;
  final String? endpoint;

  const SingleCommentWidget({
    super.key,
    required this.comments,
    required this.onEditCommentTap,
    required this.onEditCommentReplyTap,
    required this.handleActionsChange,
    required this.handleCommentUserName,
    required this.userObjectId,
    required this.onReplyTap,
    required this.handleTofoucs,
    this.endpoint,
  });

  @override
  ConsumerState<SingleCommentWidget> createState() =>
      _SingleCommentWidgetState();
}

class _SingleCommentWidgetState extends ConsumerState<SingleCommentWidget>
    with SingleTickerProviderStateMixin {
  final UserSecureStorageService userDetails = UserSecureStorageService();
  final ValueNotifier<bool> _isProfileImageVisible = ValueNotifier<bool>(true);
  late SlidableController _slidableController;

  @override
  void initState() {
    super.initState();
    _slidableController = SlidableController(this);
    _slidableController.animation.addListener(() {
      if (_slidableController.animation.value > 0.0 &&
          _slidableController.animation.value < 1.0) {
        _isProfileImageVisible.value = false;
      } else {
        _isProfileImageVisible.value = true;
      }
    });
  }

  @override
  void dispose() {
    _slidableController.dispose();
    super.dispose();
  }

  bool isView = false;

  void handleViewRepliesHide(String commentId, value) {
    setState(() {
      isView = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    DateTime currentTime = DateTime.now();
    //checking difference in min
    int differenceInMin = currentTime
        .difference(DateTime.parse(widget.comments.createdOn))
        .inMinutes;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
     
          ValueListenableBuilder<bool>(
            valueListenable: _isProfileImageVisible,
            builder: (context, isVisible, child) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: isVisible,
                    child: Column(
                      children: [
                        widget.comments.userProfileImage.isNotEmpty
                            ? CircularCachedNetworkImage(
                                imageURL: widget.comments.userProfileImage,
                                size: 35,
                                borderColor: Colors.transparent,
                                gender: widget.comments.gender.toLowerCase(),
                                type: "blog")
                            : CircleAvatar(
                                radius: 18,
                                child: SvgPicture.asset(
                                  height: 40,
                                  widget.comments.gender.toLowerCase() ==
                                          maleGenderValue
                                      ? maleUserProfileSvgFilePath
                                      : feamleUserProfileSvgFilePath,
                                  fit: BoxFit.fill,
                                ),
                              ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Slidable(
                      key: ValueKey(widget.comments.objectId),
                      enabled: widget.userObjectId == widget.comments.createdBy,
                      controller: _slidableController,
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          if (differenceInMin <= 30)
                            SlidableAction(
                              onPressed: (context) {
                                widget.handleActionsChange(
                                    CommentActions.EditComment);
                                widget.onEditCommentTap();
                                widget.handleTofoucs();
                              },
                              backgroundColor: const Color(0xFF7BC043),
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              label: 'Edit',
                            ),
                          SlidableAction(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            onPressed: (context) {
                              ref
                                  .read(getBlogCommentsListStateNotifierProvider
                                      .notifier)
                                  .deleteComments(
                                      widget.comments.objectId,
                                      widget.comments.blogId,
                                      widget.comments.createdBy,
                                      "COMMENT",
                                      widget.comments.replyCount!,
                               
                                      widget.endpoint != null
                                          ? deleteCommentsReplyCommunityendpoint
                                          : null,       widget.comments.objectId,
                                      
                                      );
                            },
                            backgroundColor: theme.disabledColor,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                        ],
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: theme.shadowColor,
                        ),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    widget.comments.userFullName ?? 'userName',
                                style: TextStyle(
                                  color: theme.primaryColorDark,
                                  fontFamily: fontFamily,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const TextSpan(text: '    '),
                              TextSpan(
                                text: widget.comments.postedAgo,
                                style: TextStyle(
                                  color: theme.focusColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                              const TextSpan(text: '\n'),
                              TextSpan(
                                text: widget.comments.content,
                                style: TextStyle(
                                    color: theme.primaryColorDark,
                                    fontFamily: fontFamily,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          Container(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.09),
              child: _buildReply()),
          if (widget.comments.replyCount != 0 && !isView)
            _buildViewMoreText(ref),
          if (widget.comments.replyCount != 0 && isView) _buildReplies(),
        ],
      ),
    );
  }

//widget for buildReplies
  Widget _buildReplies() {
    final repliesCount = widget.comments.replyCount;

    if ((repliesCount != null && repliesCount > 0)) {
      return _buildForGetReplies(context, ref, widget.comments.objectId);
    }
    return Container();
  }

  //widget for reply
  Widget _buildReply() {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        widget.onReplyTap(widget.comments.objectId);
        widget.handleActionsChange(
          CommentActions.ReplyComment,
        );
        widget.handleCommentUserName(widget.comments.userFullName!);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        child: Text(
          "Reply",
          style: TextStyle(
            fontSize: 12,
            color: theme.primaryColorDark,
            fontFamily: fontFamily,
          ),
        ),
      ),
    );
  }

  //widget for view more text
  Widget _buildViewMoreText(ref) {
    final theme = Theme.of(context);
    String count =
        "${widget.comments.replyCount ?? widget.comments.commentsReplies!.length}";
    return Row(
      children: [
        const SizedBox(
          width: 50,
        ),
        InkWell(
            onTap: () {
              handleViewRepliesHide(widget.comments.objectId, true);
              ref
                  .read(getBlogCommentsListStateNotifierProvider.notifier)
                  .getCommentReply(widget.comments.objectId, 1, 5 ,
                      widget.endpoint != null
                          ? getCommentsReplyCommunityendpoint
                          : null);
            },
            child: (count == "1")
                ? Text(
                    "View $count more reply",
                    style: TextStyle(
                        color: theme.primaryColorDark,
                        fontFamily: fontFamily,
                        fontSize: 13),
                  )
                : Text(
                    "View $count more replies",
                    style: TextStyle(
                        color: theme.primaryColorDark,
                        fontFamily: fontFamily,
                        fontSize: 13),
                  )),
      ],
    );
  }

//widget for get replies
  Widget _buildForGetReplies(
      BuildContext context, WidgetRef ref, String commentId) {
    final theme = Theme.of(context);

    if (widget.comments.isRepliesLoading) {
      return const Center(
        child:
            SizedBox(height: 20, width: 20, child: CircularProgressIndicator()),
      );
    }

    if (widget.comments.commentsReplies == null) {
      return Container();
    }

    DateTime currentTime = DateTime.now();

    return SingleChildScrollView(
      // Wrap with SingleChildScrollView
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          Column(
            children: widget.comments.commentsReplies!.map((repliesDetails) {
              if (repliesDetails.commentId != commentId) {
                return const SizedBox.shrink();
              }
              //checking difference in min
              int differenceInMin = currentTime
                  .difference(DateTime.parse(repliesDetails.createdOn))
                  .inMinutes;
              return Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 40, top: 5, bottom: 5),
                    child: Slidable(
                      key: ValueKey(widget.userObjectId),
                      enabled: (widget.userObjectId == repliesDetails.createdBy)
                          ? true
                          : false,
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          if (differenceInMin < 30)
                            SlidableAction(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              onPressed: (context) {
                                widget.handleActionsChange(
                                    CommentActions.EditReplyComment);
                                widget.onEditCommentReplyTap(
                                    repliesDetails.objectId,
                                    repliesDetails.content);

                                widget.handleTofoucs();
                              },
                              backgroundColor: const Color(0xFF7BC043),
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              label: 'Edit',
                            ),
                          if (widget.userObjectId == repliesDetails.createdBy)
                            SlidableAction(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              onPressed: (context) {
                                ref
                                    .read(
                                        getBlogCommentsListStateNotifierProvider
                                            .notifier)
                                    .deleteComments(
                                      repliesDetails.objectId,
                                      repliesDetails.blogId,
                                      repliesDetails.createdBy,
                                      "REPLY",
                                      widget.comments.replyCount!,
      widget.endpoint != null
                                          ? deleteCommentsReplyCommunityendpoint
                                          : null,  
                                      widget.comments.objectId,
                                    );
                              },
                              backgroundColor: theme.disabledColor,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              repliesDetails.userProfileImage.isNotEmpty
                                  ? CircularCachedNetworkImage(
                                      imageURL: repliesDetails.userProfileImage,
                                      size: 35,
                                      borderColor: Colors.transparent,
                                      type: 'blog',
                                      gender: repliesDetails.gender,
                                    )
                                  : CircleAvatar(
                                      radius: 18,
                                      child: SvgPicture.asset(
                                        height: 40,
                                        repliesDetails.gender
                                                    .toString()
                                                    .toLowerCase() ==
                                                maleGenderValue
                                            ? maleUserProfileSvgFilePath
                                            : feamleUserProfileSvgFilePath,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                            ],
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: theme.shadowColor,
                                  ),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: repliesDetails.userFullName,
                                          style: TextStyle(
                                            color: theme.primaryColorDark,
                                            fontFamily: fontFamily,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const TextSpan(
                                          text: '   ',
                                        ),
                                        TextSpan(
                                          text: repliesDetails.postedAgo,
                                          style: TextStyle(
                                            color: theme.focusColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const TextSpan(
                                          text: '\n',
                                        ),
                                        TextSpan(
                                          text: repliesDetails.content,
                                          style: TextStyle(
                                            color: theme.primaryColorDark,
                                            fontFamily: fontFamily,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.08,
              ),
              _buildHideReply()
            ],
          ),
        ],
      ),
    );
  }

//Widget for HideReply button
  Widget _buildHideReply() {
    final theme = Theme.of(context);
    String count =
        "${widget.comments.replyCount ?? widget.comments.commentsReplies!.length}";
    return Row(
      children: [
        const SizedBox(
          width: 50,
        ),
        InkWell(
            onTap: () {
              handleViewRepliesHide(widget.comments.objectId, false);
            },
            child: (count == "1")
                ? Text(
                    hideReplyText,
                    style: TextStyle(
                        color: theme.primaryColorDark,
                        fontFamily: fontFamily,
                        fontSize: 13),
                  )
                : Text(
                    hideRepliesText,
                    style: TextStyle(
                        color: theme.primaryColorDark,
                        fontFamily: fontFamily,
                        fontSize: 13),
                  )),
      ],
    );
  }
}
