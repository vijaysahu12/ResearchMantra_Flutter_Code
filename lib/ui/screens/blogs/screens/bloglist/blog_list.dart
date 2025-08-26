import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:research_mantra_official/data/models/blogs/blog_api_response_model.dart';
import 'package:research_mantra_official/data/models/hive_model/blog_hive_model.dart';
import 'package:research_mantra_official/providers/blogs/main/blogs_provider.dart';
import 'package:research_mantra_official/services/hive_service.dart';
import 'package:research_mantra_official/ui/components/community/common_floating_button.dart';
import 'package:research_mantra_official/ui/components/community/common_post_screen.dart';
import 'package:research_mantra_official/ui/components/indicator.dart';
import 'package:research_mantra_official/ui/screens/blogs/widget/single_blog_widget.dart';

class BlogScreenListWidget extends StatefulWidget {
  final List<Blogs?> post;
  final Function() onReachEnd;
  final bool isLoadingMore;
  final bool progressState;
  final UserActivityState getUserActivity;
  const BlogScreenListWidget({
    super.key,
    required this.post,
    required this.onReachEnd,
    required this.isLoadingMore,
    required this.progressState,
    required this.getUserActivity,
  });

  @override
  State<BlogScreenListWidget> createState() => _BlogScreenListWidgetState();
}

class _BlogScreenListWidgetState extends State<BlogScreenListWidget> {
  late ScrollController _scrollController;

  String aspectRatio = "1.0";
  final HiveServiceStorage _hiveServiceStorage = HiveServiceStorage();

  @override
  void initState() {
    super.initState();
    _hiveServiceStorage.deleteAllBlogsHiveData;

    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose of ScrollController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: AnimationLimiter(
        child: Column(
          children: [
            if (widget.progressState)
              const SizedBox(
                child: ProgressIndicatorExample(),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.post.length + (widget.isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  //Single Blog Post data
                  int numberOfPostsToAdd = 9;
                  int postCount = widget.post.length;

                  for (int index = 0;
                      index < numberOfPostsToAdd && index < postCount;
                      index++) {
                    if (widget.post[index] != null) {
                      final blogPostModel = BlogsHiveModel(
                        objectId: widget.post[index]!.objectId,
                        enableComments: widget.post[index]!.enableComments,
                        postedAgo: widget.post[index]!.postedAgo,
                        content: widget.post[index]!.content,
                        hashtag: widget.post[index]!.hashtag,
                        createdBy: widget.post[index]!.createdBy,
                        gender: widget.post[index]!.gender,
                        createdOn: widget.post[index]!.createdOn,
                        likesCount: widget.post[index]!.likesCount,
                        commentsCount: widget.post[index]!.commentsCount,
                        image: widget.post[index]?.image
                            ?.map((imageDetail) => imageDetail.name)
                            .toList(),
                        userFullName: widget.post[index]!.userFullName,
                        userHasLiked: widget.post[index]!.userHasLiked,
                      );
                      _hiveServiceStorage.addBlogPostInHive(blogPostModel);
                    }
                  }

                  if (index == widget.post.length) {
                    return _buildLoadMoreIndicator();
                  } else {
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: SingleBlogItemWidget(
                            aspectRatios: aspectRatio,
                            userObjectId: widget.getUserActivity.userObjectId,
                            post: widget.post[index],
                          ),
                        ),
                      ),
                    );
                  }
                },
                controller: _scrollController,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: widget.getUserActivity.userActivity == true
          ? CommonFloatingButton(
              onPressed: _navigateToBlogPostScreen,
            )
          : null,
    );
  }

//function navigate to blog post screen
  void _navigateToBlogPostScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommonPostScreen(
          existingContent: '',
          existingBlogId: '',
          existingImages: [],
          onPostSuccess: (aspectRatios) {
            setState(() {
              if (aspectRatios.isNotEmpty) {
                aspectRatio = aspectRatios.first;
              } else {
                aspectRatio = "1.0"; // or a default value
              }
            });

            if (_scrollController.hasClients) {
              // Check if _scrollController has any attached scrollable widget
              _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
              );
            }
          },
          isPostType: 'blog',
        ),
      ),
    );
  }

  // Widget to build the load more indicator
  Widget _buildLoadMoreIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      alignment: Alignment.center,
      child: widget.isLoadingMore
          ? const SizedBox(
              height: 20, width: 20, child: CircularProgressIndicator())
          : null, // Or text depending on the current state
    );
  }

  void _scrollListener() {
    if (_scrollController.position.extentAfter == 0) {
      widget.onReachEnd();
    }
  }
}
