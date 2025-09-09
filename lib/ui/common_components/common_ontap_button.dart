import 'package:flutter/material.dart';

class CustomTabBarOnTapButton extends StatelessWidget {
  final List<String> tabLabels;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  final double borderRadius;
  final double fontSize;
  final Color backgroundColor;
  final Color buttonBackgroundColor;
  final Color buttonTextColor;
  final bool isBorderEnabled;
  final bool isScrollHorizontal; // 👈 new flag

  const CustomTabBarOnTapButton({
    super.key,
    required this.tabLabels,
    required this.selectedIndex,
    required this.onTabSelected,
    this.borderRadius = 4.0,
    required this.fontSize,
    this.backgroundColor = Colors.transparent,
    this.buttonBackgroundColor = Colors.transparent,
    this.buttonTextColor = Colors.black,
    this.isBorderEnabled = false,
    this.isScrollHorizontal = true, // 👈 default scroll
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final tabWidgets = List.generate(
      tabLabels.length,
      (index) => GestureDetector(
        onTap: () => onTabSelected(index),
        child: Container(
          margin: EdgeInsets.only(
            right: index < tabLabels.length - 1 ? 8 : 2,
          ),
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
          decoration: BoxDecoration(
            color: selectedIndex == index
                ? buttonBackgroundColor
                : Colors.transparent,
            borderRadius: BorderRadius.circular(borderRadius),
            border: isBorderEnabled
                ? Border.all(
                    color: selectedIndex == index
                        ? Colors.transparent
                        : Colors.black,
                  )
                : null,
          ),
          child: Text(
            tabLabels[index],
            style: TextStyle(
              color:
                  selectedIndex == index ? buttonTextColor : theme.focusColor,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );

    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: isScrollHorizontal
          ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: tabWidgets),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: tabWidgets,
            ),
    );
  }
}
