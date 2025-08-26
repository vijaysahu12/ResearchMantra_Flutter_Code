import 'package:flutter/material.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

class StockHeading extends StatelessWidget {
  const StockHeading({super.key});

  @override
  Widget build(BuildContext context) {
          final theme = Theme.of(context);
    return   Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 40),
              decoration: BoxDecoration(color: theme.shadowColor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Stock Name',
                    style: textH5.copyWith(fontSize: 12),
                  ),
                  Text(
                    'Price',
                    style: textH5.copyWith(fontSize: 12),
                  )
                ],
              ),
            );
          
  }
}