import 'package:flutter/material.dart';
import 'package:research_mantra_official/ui/components/cacher_network_images/circular_cached_network_image.dart';

class PromoImageViewer extends StatefulWidget {
  final List<String> images;
  final ValueChanged<int>? onPageChanged; // <== ADD THIS

  const PromoImageViewer({
    super.key,
    required this.images,
    this.onPageChanged,
  });

  @override
  State<PromoImageViewer> createState() => _PromoImageViewerState();
}

class _PromoImageViewerState extends State<PromoImageViewer> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  void _goToPage(int index) {
    if (index >= 0 && index < widget.images.length) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (widget.images.isEmpty) return const SizedBox();

    return Stack(
      alignment: Alignment.center,
      children: [
        PageView.builder(
          controller: _pageController,
          itemCount: widget.images.length,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
            widget.onPageChanged?.call(index); // <== ADD THIS LINE
          },
          itemBuilder: (context, index) {
            return ShimmerImage(mediaUrl: widget.images[index]);
          },
        ),

        // Left Arrow
        if (_currentIndex > 0)
          Positioned(
            left: 8,
            child: _buildArrowButton(
                icon: Icons.arrow_back_ios,
                onTap: () => _goToPage(_currentIndex - 1),
                alignment: Alignment.centerLeft,
                theme: theme),
          ),

        // Right Arrow
        if (_currentIndex < widget.images.length - 1)
          Positioned(
            right: 8,
            child: _buildArrowButton(
                icon: Icons.arrow_forward_ios,
                onTap: () => _goToPage(_currentIndex + 1),
                alignment: Alignment.centerRight,
                theme: theme),
          ),
      ],
    );
  }

  Widget _buildArrowButton(
      {required IconData icon,
      required VoidCallback onTap,
      required Alignment alignment,
      theme}) {
    return Align(
      alignment: alignment,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.secondaryHeaderColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 16,
            color: theme.floatingActionButtonTheme.foregroundColor,
          ),
        ),
      ),
    );
  }
}
