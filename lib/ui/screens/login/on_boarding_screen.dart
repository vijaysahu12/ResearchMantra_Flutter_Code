import 'dart:async';
import 'package:flutter/material.dart';
import 'package:research_mantra_official/ui/common_components/shimmer_button.dart';
import 'package:research_mantra_official/ui/screens/login/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _activeIndex = 0;
  Timer? _timer;

  final List<String> _images = [
    "assets/images/research_mantra/slides/slide_one.jpg",
    "assets/images/research_mantra/slides/slide_two.png",
    "assets/images/research_mantra/slides/slide3.png",
    "assets/images/research_mantra/slides/slide_one.jpg",
    "assets/images/research_mantra/slides/slide_one.jpg",
  ];

  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer?.cancel();
    _progress = 0.0;

    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        _progress += 0.02; // adjust speed (0.02 * 50ms ≈ 2.5s full)
      });

      if (_progress >= 1.0) {
        _progress = 0.0;
        int nextPage = (_activeIndex + 1) % _images.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Widget _buildTopProgressBars() {
    return Row(
      children: List.generate(_images.length, (index) {
        double fill = 0;

        if (index < _activeIndex) {
          fill = 1; // already completed
        } else if (index == _activeIndex) {
          fill = _progress; // current progress
        } else {
          fill = 0; // not started yet
        }

        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade700,
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: fill.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            /// 🔼 Top Loader (Progress Bars)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: _buildTopProgressBars(),
            ),

            /// 🖼️ Center PageView (takes remaining space)
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _images.length,
                onPageChanged: (index) {
                  setState(() {
                    _activeIndex = index;
                    _progress = 0.0;
                  });
                },
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(_images[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),

            /// 🔽 Bottom Button
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ShimmerButton(
                borderRadius: 4,
                text: "Start Now",
                backgroundColor: theme.secondaryHeaderColor,
                textColor: theme.primaryColor,
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginWidget(),
                    ),
                    (route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
