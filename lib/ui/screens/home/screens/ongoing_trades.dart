import 'package:flutter/material.dart';
import 'package:research_mantra_official/ui/common_components/common_outline_button.dart';

class OngoingTradesSection extends StatelessWidget {
  final void Function(String tab) onSubscribe;

  const OngoingTradesSection({
    super.key,
    required this.onSubscribe,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Example data: you can fetch this from API later
    final List<Map<String, String>> tradeSections = [
      {"title": "Futures", "avg": "Avg 12.5%"},
      {"title": "Options", "avg": "Avg 9.2%"},
      {"title": "MCX", "avg": "Avg 14.8%"},
    ];

    return Row(
      children: tradeSections.map((section) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.primaryColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  section["title"]!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColorDark,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  section["avg"]!,
                  style: TextStyle(
                    fontSize: 13,
                    color: theme.focusColor,
                  ),
                ),
                const SizedBox(height: 12),
                CommonOutlineButton(
                    borderRadius: 5,
                    text: "Active",
                    onPressed: () => onSubscribe(section["title"]!))
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
