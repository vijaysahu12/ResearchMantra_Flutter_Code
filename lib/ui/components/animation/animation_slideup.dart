import 'package:flutter/material.dart';

class AnimatedSlideUp extends StatelessWidget {
  final Widget child;
  final Duration duration;
  const AnimatedSlideUp({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      transitionBuilder: (Widget child, Animation<double> animation) {
        final slideAnimation =
            Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
                .animate(animation);
        return SlideTransition(
          position: slideAnimation,
          child: child,
        );
      },
      child: child,
    );
  }
}
