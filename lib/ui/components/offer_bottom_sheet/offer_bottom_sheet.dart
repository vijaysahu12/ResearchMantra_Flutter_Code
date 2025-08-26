import 'package:flutter/material.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

class CustomOfferBottomSheet extends StatelessWidget {
  final String imagePath;
  final String actionType;
  final String buttonText;
  final VoidCallback onPressed;

  const CustomOfferBottomSheet({
    super.key,
    required this.imagePath,
    required this.buttonText,
    required this.onPressed,
    required this.actionType,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            AspectRatio(
              aspectRatio: 1 / 1,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                child: Image.network(
                  imagePath,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            if (actionType.toLowerCase() == "click")
              Positioned(
                left: MediaQuery.of(context).size.width * 0.4,
                top: MediaQuery.of(context).size.width * 0.875,
                child: GestureDetector(
                  onTap: onPressed,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          buttonText.toUpperCase(),
                          style: TextStyle(
                            color:
                                theme.floatingActionButtonTheme.foregroundColor,
                            fontFamily: fontFamily,
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
