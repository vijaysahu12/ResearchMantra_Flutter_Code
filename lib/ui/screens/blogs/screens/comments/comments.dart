
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/providers/blogs/comment/comments_provider.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';
import 'package:research_mantra_official/ui/components/king_research_loader/kingresearch_loader.dart';
import 'package:research_mantra_official/ui/screens/blogs/screens/comments/comment_list.dart';

//Comments Screen
class CommentsScreen extends ConsumerStatefulWidget {
  final String blogId;
  final String? endpoint;
  const CommentsScreen({
    super.key,
    required this.blogId,
    this.endpoint,
  });

  @override
  ConsumerState<CommentsScreen> createState() => _CommetsState();
}

class _CommetsState extends ConsumerState<CommentsScreen> {
  final UserSecureStorageService userDetails = UserSecureStorageService();
  String? userObjectId;
  bool userCommunityPostEnabled = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref
          .read(getBlogCommentsListStateNotifierProvider.notifier)
          .getAllComments(widget.blogId, 1,
              widget.endpoint != null ? getCommentsCommunityendpoint : null);
      userObjectId = (await userDetails.getUserObjectId())!;
      userCommunityPostEnabled = await userDetails.checkUserComments();
      setState(() {});
    });
  }

  //function for handle refresh
  void handleRefresh() async {
    ref.read(getBlogCommentsListStateNotifierProvider.notifier).getAllComments(
        widget.blogId,
        1,
        widget.endpoint != null ? getCommentsCommunityendpoint : null);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final commentList = ref.watch(getBlogCommentsListStateNotifierProvider);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: CommonAppBarWithBackButton(
        appBarText: "Comments",
        handleBackButton: () => Navigator.pop(context),
      ),
      body: commentList.isLoading && commentList.blogCommentsModel.isEmpty
          ? const CommonLoaderGif()
          : CommentsListWidget(
              userCommunityPostEnabled: userCommunityPostEnabled,
              endpoint: widget.endpoint,
              commentList: commentList.blogCommentsModel,
              reachEnd: () async {
                if (!commentList.isLoadingMore) {
                  ref
                      .read(getBlogCommentsListStateNotifierProvider.notifier)
                      .getLoadMoreComments(widget.blogId, widget.endpoint);
                }
              },
              isLoadMore: commentList.isLoadingMore,
              isProgress: commentList.isProgress,
              handleRefresh: handleRefresh,
              blogId: widget.blogId,
              userObjectId: userObjectId,
              isLoading: commentList.isLoading,
            ),
    );
  }
}
