import 'package:flutter/material.dart';
import 'package:research_mantra_official/constants/assets.dart';


class CustomTabs extends StatefulWidget {
  final String text;
  final void Function()? onTap;
  final bool isSelected; // Added: Allow initial selection state
// Added: Callback to notify when selected state changes

  const CustomTabs({
    super.key,
    required this.text,
    required this.isSelected, // Default to unselected
    // Callback to notify parent
    this.onTap,
  });

  @override
  State<CustomTabs> createState() => _CustomTabsState();
}

class _CustomTabsState extends State<CustomTabs> {
  @override
  void initState() {
    super.initState();
// Initialize state based on parent's input
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        decoration: BoxDecoration(
            color: theme.primaryColor,
            border: widget.isSelected
                ? Border(
                    bottom: BorderSide(
                    color: theme.disabledColor,
                    width: 2.0, // Underline thickness
                  ))
                : null),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 225, 7, 7),
                shape: BoxShape.circle,
                border: Border.all(color: theme.primaryColor),
                gradient: const LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color(0xffAD0000),
                    Color(0xffFF2929),
                  ],
                ),
              ),
              // height: 30,
              // width: 30,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.asset(
                  kingResearchIcon, // Or any other image
                  fit: BoxFit.cover,
                  scale: 6,
                ),
              ),
            ),
            const SizedBox(width: 5),
            Center(
              child: Text(
                widget.text,
                style: TextStyle(
                  color: 
                  // widget.isSelected?theme.disabledColor:
                  theme.primaryColorDark, // Default text color
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
