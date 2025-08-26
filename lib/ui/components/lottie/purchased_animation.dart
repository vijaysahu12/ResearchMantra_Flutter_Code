import 'package:flutter/material.dart';
import 'package:research_mantra_official/constants/assets.dart';
import 'package:lottie/lottie.dart';

class PurchasedAnimation extends StatefulWidget {
  const PurchasedAnimation({super.key});

  @override
  State<PurchasedAnimation> createState() => _PurchasedAnimationState();
}

class _PurchasedAnimationState extends State<PurchasedAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
    );

    _animationController.addStatusListener((status) {
      if (_animationController.status == AnimationStatus.completed) {
        _animationController.stop();
        _animationController.reset();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      controller: _animationController,
      animate: false,
      celebarate,
      onLoaded: (composition) {
        _animationController
          ..duration = composition.duration
          ..forward();
      },
    );
  }
}
