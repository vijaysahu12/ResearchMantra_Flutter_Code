import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:research_mantra_official/constants/assets.dart';
import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/data/models/blogs/blog_comments_api_response_model.dart';
import 'package:research_mantra_official/providers/blogs/comment/comments_provider.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';
import 'package:research_mantra_official/ui/components/cacher_network_images/circular_cached_network_image.dart';
import 'package:research_mantra_official/ui/components/common_empty_comments/common_empty_comments.dart';
import 'package:research_mantra_official/ui/components/indicator.dart';
import 'package:research_mantra_official/ui/components/words/negative_words.dart';
import 'package:research_mantra_official/ui/screens/blogs/widget/single_comment_widget.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

enum CommentActions {
  AddComment,
  ReplyComment,
  EditComment,
  EditReplyComment,
}

class CommentsListWidget extends ConsumerStatefulWidget {
  final List<BlogCommentsModel> commentList;
  final Function() reachEnd;
  final bool isLoadMore;
  final bool isLoading;
  final Function() handleRefresh;
  final String blogId;
  final String? userObjectId;
  final bool isProgress;
  final String? endpoint;
  final bool userCommunityPostEnabled;
  const CommentsListWidget({
    super.key,
    required this.commentList,
    required this.reachEnd,
    required this.isLoadMore,
    required this.isLoading,
    required this.blogId,
    required this.handleRefresh,
    required this.userObjectId,
    required this.isProgress,
    this.endpoint,
    required this.userCommunityPostEnabled,
  });

  @override
  ConsumerState<CommentsListWidget> createState() => _CommentsListWidgetState();
}

class _CommentsListWidgetState extends ConsumerState<CommentsListWidget> {
  String selectedObjectId = '';
  String selectedCommentId = '';
  String selectedCommentIdForReply = '';

  String commentReplyUserName = '';

  final ScrollController _scrollController = ScrollController();

  final TextEditingController _commentTextEditController =
      TextEditingController();
  final TextEditingController _commentReplyTextEditController =
      TextEditingController();
  final TextEditingController _editCommentController = TextEditingController();
  final TextEditingController _editCommentReplyCommentController =
      TextEditingController();

  final UserSecureStorageService userDetails = UserSecureStorageService();
  CommentActions action = CommentActions.AddComment;
  String? commentedUserProfileImage;
  bool isCancelButtonHide = false;
  bool hasBadWords = false;
  bool _isBottomNavigationBarVisible = true;
  late FocusNode _textFieldFocusNode;
  String? commentobjectId;
  String? selectedGender;
  final UserSecureStorageService _secureStorageService =
      UserSecureStorageService();

  @override
  void initState() {
    super.initState();
    _textFieldFocusNode = FocusNode();
    _scrollController.addListener(_scrollListener);
    _fetchUserProfileImage();

    _loadSelectedGender();
  }

  _loadSelectedGender() async {
    final String? gender = await _secureStorageService.getSelectedGender();
    setState(() {
      selectedGender = gender;
    });
  }

//function CommentAction like[Add Comment,EditComment,ReplyComment,ReplyEditComment]
  void handleActionsChange(CommentActions newAction) {
    setState(() {
      action = newAction;
    });
  }

  // Function to set text for editing and move cursor to the end
  void _setTextForEditing(
    TextEditingController controller,
    String text,
  ) {
    controller.text = text;

    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );
    handleTofoucs();
  }

//function for handle userName
  void handleCommentUserName(String commentUserName) {
    setState(() {
      commentReplyUserName = commentUserName;
    });
  }

//function for get userProfileImage init
  Future<void> _fetchUserProfileImage() async {
    final UserSecureStorageService userDetails = UserSecureStorageService();
    final Map<String, dynamic> commentedUsername =
        await userDetails.getUserDetails();
    setState(() {
      commentedUserProfileImage = commentedUsername['profileImage'] ?? 'User';
    });
  }

  // Scroll listener function to detect reaching the end of the list
  void _scrollListener() {
    if (_scrollController.position.extentAfter == 0) {
      widget.reachEnd(); // Call onReachEnd function when reaching the end
    }
  }

//dispose to _scrollController
  @override
  void dispose() {
    _scrollController.dispose();
    _textFieldFocusNode.dispose();
    super.dispose();
  }

  void handleTofoucs() {
    _textFieldFocusNode.requestFocus();
  }

//function for handleComment
  void handleComment(String blogId) async {
    final String? userObjectId = await userDetails.getUserObjectId();
    final Map<String, dynamic> commentedUsername =
        await userDetails.getUserDetails();
    final String nameOfTheUser = commentedUsername['fullName'];

    ref
        .read(getBlogCommentsListStateNotifierProvider.notifier)
        .manageBlogComments(
            userObjectId!,
            widget.blogId,
            _commentTextEditController.text.trim(),
            nameOfTheUser,
            (commentedUserProfileImage != null)
                ? commentedUserProfileImage!
                : '',
            widget.endpoint);

    _commentTextEditController.clear();
    // Delay animation to ensure scroll view is fully initialized
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  //function for handle reply comment
  void handleCommentReply(WidgetRef ref, commentId, blogId) async {
    final Map<String, dynamic> commentedUsername =
        await userDetails.getUserDetails();
    final String? userObjectId = await userDetails.getUserObjectId();
    final String nameOfTheUser = commentedUsername['fullName'];
    ref
        .read(getBlogCommentsListStateNotifierProvider.notifier)
        .manageCommentReply(
            _commentReplyTextEditController.text.trim(),
            userObjectId!,
            commentId,
            blogId,
            nameOfTheUser,
            (commentedUserProfileImage != null)
                ? commentedUserProfileImage!
                : '',
            widget.endpoint != null
                ? postCommentsReplyCommunityendpoint
                : null);

    _commentReplyTextEditController.clear();
    action = CommentActions.AddComment;
  }

  //function for edit comments
  void handleCommentEdit(
    context,
    WidgetRef ref,
    String commentId,
    String content,
    String type,
  ) async {
    final String? userObjectId = await userDetails.getUserObjectId();
    ref
        .read(getBlogCommentsListStateNotifierProvider.notifier)
        .editBlogCommentOrReply(
            commentId,
            userObjectId!,
            content.trim(),
            "@",
            type,
            widget.endpoint != null
                ? getEditCommentsReplyCommunityendpoint
                : null);

    _editCommentController.clear();
    action = CommentActions.AddComment;
  }

//function handle edit comment replies
  void handleEditCommentReply(
    context,
    WidgetRef ref,
    String objectId,
    String content,
    String type,
  ) async {
    final String? userObjectId = await userDetails.getUserObjectId();
    ref
        .read(getBlogCommentsListStateNotifierProvider.notifier)
        .editBlogCommentOrReply(
            objectId,
            userObjectId!,
            content.trim(),
            "@",
            type,
            widget.endpoint != null
                ? getEditCommentsReplyCommunityendpoint
                : null);
    _editCommentReplyCommentController.clear();
    action = CommentActions.AddComment;
  }

  //void handle reply comment id
  void handleReplyTap(String commentId) {
    setState(() {
      selectedCommentId = commentId;
      selectedCommentIdForReply = commentId;
      action = CommentActions.ReplyComment;
      _isBottomNavigationBarVisible = true;
    });
    handleTofoucs(); // Request focus after delay
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: AnimationLimiter(
          child: widget.commentList.isEmpty
              ? EmptyCommentsScreen(
                  theme: theme,
                  isProgress: widget.isProgress,
                )
              : _buildCommentScrollView()),
      // bottomNavigationBar: userActivity ? _buildForBottomNavigationBar() : null,
      bottomNavigationBar: widget.userCommunityPostEnabled
          ? Visibility(
              visible: _isBottomNavigationBarVisible,
              child: _buildForBottomNavigationBar(),
            )
          : null,
    );
  }

  setSelectedCommentIdForReply(val) {
    setState(() {
      selectedCommentIdForReply = val;
    });
  }

  Widget _buildCommentScrollView() {
    return RefreshIndicator(
      onRefresh: () async {
        await widget.handleRefresh();
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            if (widget.isProgress)
              const SizedBox(
                child: ProgressIndicatorExample(),
              ),
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: _scrollController,
                child: Column(
                  children: [
                    for (int index = 0;
                        index < widget.commentList.length;
                        index++)
                      AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          verticalOffset: 200.0,
                          child: FadeInAnimation(
                            child: SingleCommentWidget(
                              handleTofoucs: handleTofoucs,
                              comments: widget.commentList[index],
                              handleActionsChange: handleActionsChange,
                              handleCommentUserName: handleCommentUserName,
                              onEditCommentTap: () {
                                setState(() {
                                  commentobjectId =
                                      widget.commentList[index].objectId;
                                });

                                _setTextForEditing(
                                  _editCommentController,
                                  widget.commentList[index].content,
                                );
                              },
                              onEditCommentReplyTap: (commentId, content) {
                                selectedObjectId = commentId;
                                _setTextForEditing(
                                    _editCommentReplyCommentController,
                                    content);
                              },
                              userObjectId: widget.userObjectId,
                              onReplyTap: handleReplyTap,
                              endpoint: widget.endpoint,
                            ),
                          ),
                        ),
                      ),
                    if (widget.isLoadMore)
                      const Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text("Loading...")],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

//widget for bottomnavigation bar
  Widget _buildForBottomNavigationBar() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (action == CommentActions.ReplyComment) _buildShowCommentUserName(),
        Container(
          padding: const EdgeInsets.all(10),
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.001),
          color: theme.appBarTheme.backgroundColor,
          child: _buildCommentTextField(),
        ),
      ],
    );
  }

//widget for display comment username
  Widget _buildShowCommentUserName() {
    final theme = Theme.of(context);
    return Container(
      color: theme.shadowColor,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Text(
            'Replying to $commentReplyUserName',
            style: TextStyle(
                color: theme.primaryColorDark,
                fontFamily: fontFamily,
                fontSize: 12,
                fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              setState(() {
                isCancelButtonHide = true;
                action = CommentActions.AddComment;
              });
            },
            child: Icon(
              Icons.cancel_outlined,
              color: theme.primaryColorDark,
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget _buildCommentTextField() {
    switch (action) {
      case CommentActions.ReplyComment:
        return _buildTextField(
          hintText: "Add comment reply",
          controller: _commentReplyTextEditController,
          onSend: () =>
              handleCommentReply(ref, selectedCommentId, widget.blogId),
        );
      case CommentActions.EditComment:
        return _buildTextField(
          hintText: "Edit a comment",
          controller: _editCommentController,
          onSend: () => handleCommentEdit(
            context,
            ref,
            commentobjectId ?? "",
            _editCommentController.text.trim(),
            "COMMENT",
          ),
        );
      case CommentActions.EditReplyComment:
        return _buildTextField(
          hintText: "Edit Reply a comment",
          controller: _editCommentReplyCommentController,
          onSend: () => handleEditCommentReply(
            context,
            ref,
            selectedObjectId,
            _editCommentReplyCommentController.text.trim(),
            "REPLY",
          ),
        );
      default:
        return _buildTextField(
          hintText: "Add a comment",
          controller: _commentTextEditController,
          onSend: () => handleComment(widget.blogId),
        );
    }
  }

  Widget _buildTextField({
    required String hintText,
    required TextEditingController controller,
    required VoidCallback onSend,
  }) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildProfileImage(),
        const SizedBox(width: 10),
        Flexible(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.focusColor,
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              child: TextField(
                minLines: 1,
                maxLines: 4,
                focusNode: _textFieldFocusNode,
                keyboardType: TextInputType.text,
                maxLength: 260,
                autofocus: true,
                controller: controller,
                onChanged: (text) {
                  setState(() {
                    hasBadWords = containBadwords(controller.text.trim());
                  });
                },
                onTap: () {
                  // Set cursor position to the end of the text
                  controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: controller.text.length),
                  );
                },
                decoration: InputDecoration(
                  counterText: '',
                  hintText: hintText,
                  hintStyle: TextStyle(
                    fontSize: 12,
                    color: theme.primaryColorDark,
                    fontFamily: fontFamily,
                  ),
                  border: InputBorder.none,
                  // suffixIcon:
                ),
              ),
            ),
          ),
        ),
        Container(
            child: (controller.text.trim().length > 1 && !hasBadWords)
                ? IconButton(
                    onPressed: onSend,
                    icon: Icon(
                      Icons.send,
                      color: theme.primaryColorDark,
                    ),
                  )
                : null),
      ],
    );
  }

  Widget _buildProfileImage() {
    final theme = Theme.of(context);
    return commentedUserProfileImage != null
        ? Container(
            padding: const EdgeInsets.only(bottom: 6),
            child: CircularCachedNetworkImage(
              imageURL: commentedUserProfileImage!,
              size: 35,
              borderColor: theme.focusColor,
              type: 'profile',
            ),
          )
        : Container(
            padding: const EdgeInsets.only(bottom: 6),
            child: CircleAvatar(
              radius: 20,
              child: SvgPicture.asset(
                height: 42,
                selectedGender.toString().toLowerCase() == maleGenderValue
                    ? maleUserProfileSvgFilePath
                    : feamleUserProfileSvgFilePath,
                fit: BoxFit.fill,
              ),
            ),
          );
  }
}
