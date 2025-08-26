import 'package:flutter/material.dart';

class EmptyInvoiceHistoryView extends StatelessWidget {
  const EmptyInvoiceHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 80,
            color: theme.focusColor,
          ),
          const SizedBox(height: 16),
          Text(
            'No History Available',
            style: TextStyle(
              fontSize: 15,
              color: theme.primaryColorDark,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your recent transactions will be displayed here.',
            style: TextStyle(
              fontSize: 12,
              color: theme.focusColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
