import 'package:flutter/material.dart';

class CreatePostAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onClose;
  final VoidCallback? onPost;
  final bool shouldEnablePost;
  final bool isCommunity;
  final String title;

  const CreatePostAppBar({
    super.key,
    required this.onClose,
    required this.shouldEnablePost,
    required this.isCommunity,
    required this.onPost,
    this.title = 'Create Post',
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 4);

  @override
  Widget build(BuildContext context) {
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
        onPressed: onClose,
        icon: Icon(
          Icons.close,
          size: 25,
          color: theme.primaryColorDark,
        ),
      ),
      title: Row(
        children: [
          const Spacer(),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: theme.primaryColorDark,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: isCommunity ? onClose : (shouldEnablePost ? onPost : null),
            style: TextButton.styleFrom(
              backgroundColor: shouldEnablePost
                  ? theme.indicatorColor
                  : theme.shadowColor,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            child: Text(
              "Post",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: shouldEnablePost
                    ? theme.floatingActionButtonTheme.foregroundColor
                    : theme.focusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
