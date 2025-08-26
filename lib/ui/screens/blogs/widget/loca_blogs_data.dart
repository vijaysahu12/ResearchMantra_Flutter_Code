import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:research_mantra_official/constants/assets.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/data/models/hive_model/blog_hive_model.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';
import 'package:research_mantra_official/ui/components/common_error/no_connection.dart';
import 'package:research_mantra_official/ui/components/king_research_loader/kingresearch_loader.dart';

import 'package:research_mantra_official/ui/themes/text_styles.dart';
import 'package:like_button/like_button.dart';

class LocalBlogItemWidget extends ConsumerStatefulWidget {
  final List<BlogsHiveModel> locaPost;

  const LocalBlogItemWidget({
    super.key,
    required this.locaPost,
  });

  @override
  ConsumerState<LocalBlogItemWidget> createState() =>
      _LocalBlogItemWidgetWidget();
}

class _LocalBlogItemWidgetWidget extends ConsumerState<LocalBlogItemWidget> {
  Key carouselKey = UniqueKey();
  bool isComments = false;
  final ScrollController scrollController = ScrollController();
  final UserSecureStorageService userDetails = UserSecureStorageService();
  bool isExpanded = false;
  bool isLoadDataFromLocalDb = false;

  bool userActivity = true;
  @override
  void initState() {
    super.initState();
    handleToCheckLocalData();
  }

  void handleToCheckLocalData() async {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      setState(() {
        isLoadDataFromLocalDb = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final reversedPosts = widget.locaPost.reversed.toList();

    if (!isLoadDataFromLocalDb) {
      return const Center(
        child: CommonLoaderGif(),
      );
    }

    if (reversedPosts.isEmpty) {
      return NoInternet(
        handleRefresh: () {},
      );
    }
    return ListView.builder(
        itemCount: reversedPosts.length,
        itemBuilder: (context, index) {
          final List<String>? image = reversedPosts[index].image;
          final int likesCount = reversedPosts[index].likesCount;
          return Container(
            padding: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: theme.shadowColor, width: 1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 18,
                            child: SvgPicture.asset(
                              height: 40,
                              reversedPosts[index]
                                          .gender
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
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              reversedPosts[index].userFullName,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            fontFamily: fontFamily,
                                            color: theme.primaryColorDark,
                                          ),
                                        ),
                                        const TextSpan(text: '    '),
                                        TextSpan(
                                          text: reversedPosts[index].postedAgo,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: theme.focusColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          isExpanded
                              ? RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: reversedPosts[index].content,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: theme.primaryColorDark,
                                        ),
                                      ),
                                      TextSpan(
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            setState(() {
                                              isExpanded = false;
                                            });
                                          },
                                        text: "    ...Read less",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: theme
                                              .indicatorColor, //Todo:color change
                                          fontWeight: FontWeight.w600,
                                          fontFamily: fontFamily,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: reversedPosts[index]
                                                    .content
                                                    .length >
                                                100
                                            ? reversedPosts[index]
                                                .content
                                                .substring(0, 100)
                                            : reversedPosts[index].content,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: theme.primaryColorDark,
                                          fontFamily: fontFamily,
                                        ),
                                      ),
                                      if (reversedPosts[index].content.length >
                                          100)
                                        TextSpan(
                                          text: " ...",
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: theme.indicatorColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      reversedPosts[index].content.length > 100
                                          ? TextSpan(
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  setState(() {
                                                    isExpanded = true;
                                                  });
                                                },
                                              text: " Read More",
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: theme.indicatorColor,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: fontFamily,
                                              ),
                                            )
                                          : const TextSpan(),
                                    ],
                                  ),
                                ),
                          const SizedBox(height: 5),
                          if (image!.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 3),
                                child: Image.asset(
                                  productDefaultmage,
                                  // fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          const SizedBox(height: 2),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LikeButton(
                                  size: 25,
                                  isLiked: reversedPosts[index].userHasLiked,
                                  likeBuilder: (bool isLiked) {
                                    return Icon(
                                      reversedPosts[index].userHasLiked
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: isLiked
                                          ? theme.disabledColor
                                          : theme.primaryColorDark,
                                      size: 20,
                                    );
                                  },
                                  onTap: (bool isLiked) async {
                                    return !isLiked;
                                  },
                                ),
                                const SizedBox(width: 3),
                                Container(
                                  margin: const EdgeInsets.only(top: 1.8),
                                  child: Text(
                                    likesCount.toString(),
                                    style: TextStyle(
                                        color: theme.primaryColorDark),
                                  ),
                                ),
                                const SizedBox(width: 30),
                                if (reversedPosts[index].enableComments == true)
                                  InkWell(
                                    onTap: () {},
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 3),
                                      width: 50,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.mode_comment_outlined,
                                            color: theme.primaryColorDark,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            reversedPosts[index]
                                                .commentsCount
                                                .toString(),
                                            style: TextStyle(
                                                color: theme.primaryColorDark),
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
                  ],
                ),
              ],
            ),
          );
        });
  }
}
