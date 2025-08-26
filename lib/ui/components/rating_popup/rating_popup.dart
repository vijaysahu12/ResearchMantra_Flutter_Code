import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductFeedbackDialog extends StatefulWidget {
  final double initialRating;
  final String title;
  final void Function(double rating)? onSubmit;

  const ProductFeedbackDialog(
      {super.key,
      required this.initialRating,
      this.onSubmit,
      required this.title});

  @override
  State<ProductFeedbackDialog> createState() => _ProductFeedbackDialogState();
}

class _ProductFeedbackDialogState extends State<ProductFeedbackDialog> {
  double _currentRating = 0.0;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        color: theme.primaryColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Handle bar
              Container(
                width: screenWidth * 0.1,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Title
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColorDark,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              // Subtitle
              Text(
                'How would you rate your experience?',
                style: TextStyle(
                  fontSize: screenWidth * 0.03,
                  color: theme.focusColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Rating Bar
              RatingBar.builder(
                initialRating: _currentRating,
                minRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemSize: 44,
                glow: false,
                unratedColor: theme.colorScheme.outline.withOpacity(0.3),
                itemPadding: const EdgeInsets.symmetric(horizontal: 6),
                itemBuilder: (context, index) => Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index < _currentRating
                        ? Colors.amber.withOpacity(0.1)
                        : Colors.transparent,
                  ),
                  child: Icon(
                    Icons.star_rounded,
                    color: index < _currentRating
                        ? Colors.amber
                        : theme.focusColor,
                    size: 36,
                  ),
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    _currentRating = rating;
                  });
                },
              ),
              const SizedBox(height: 10),
              Text(
                _currentRating > 0
                    ? _getRatingLabel(_currentRating.toInt())
                    : " ",
                style: TextStyle(
                  fontSize: screenWidth * 0.03,
                  color: theme.primaryColorDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                        label: 'Maybe Later',
                        onTap: () => Navigator.of(context).pop(),
                        theme: theme,
                        isLater: true,
                        screenWidth: screenWidth),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionButton(
                        label: 'Submit Rating',
                        onTap: _currentRating > 0
                            ? () {
                                Navigator.of(context).pop();
                                widget.onSubmit?.call(_currentRating);
                              }
                            : null,
                        theme: theme,
                        isLater: false,
                        screenWidth: screenWidth),
                  ),
                ],
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
      {required String label,
      required VoidCallback? onTap,
      theme,
      isLater,
      screenWidth}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: isLater ? theme.shadowColor : theme.indicatorColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: screenWidth * 0.03,
            fontWeight: FontWeight.w600,
            color: isLater
                ? theme.primaryColorDark.withOpacity(0.7)
                : theme.floatingActionButtonTheme.foregroundColor,
          ),
        ),
      ),
    );
  }

  String _getRatingLabel(int rating) {
    switch (rating) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Very Good';
      case 5:
        return 'Excellent';
      default:
        return '';
    }
  }
}
