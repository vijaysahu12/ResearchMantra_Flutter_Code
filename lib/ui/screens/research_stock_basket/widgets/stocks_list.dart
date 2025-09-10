import 'package:flutter/material.dart';

class StockListCard extends StatelessWidget {
  final List<Map<String, dynamic>> stockData = [
    {"name": "PGEI", "qty": 25, "date": "12-10-2024"},
    {"name": "INFY", "qty": 40, "date": "11-09-2024"},
    {"name": "RELIANCE", "qty": 12, "date": "05-08-2024"},
    {"name": "TCS", "qty": 18, "date": "22-07-2024"},
  ];

  final String totalAmount = "₹ 5,25,000";

  StockListCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.primaryColor,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.4),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Heading
          Text(
            "Basket Composition",
            style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold, color: theme.primaryColorDark),
          ),
          const SizedBox(height: 12),

          /// Column Headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Stock",
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.primaryColorDark,
                ),
              ),
              Text(
                "Qty",
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.primaryColorDark,
                ),
              ),
            ],
          ),
          const Divider(),

          /// Stock Items
          ...stockData.map((stock) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Row with stock + qty
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        stock["name"],
                        style: theme.textTheme.bodyLarge
                            ?.copyWith(color: theme.primaryColorDark),
                      ),
                      Text(
                        stock["qty"].toString(),
                        style: theme.textTheme.bodyLarge
                            ?.copyWith(color: theme.focusColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(stock["date"],
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.focusColor)),
                  const Divider(),
                ],
              ),
            );
          }).toList(),

          /// Total Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Amount:",
                  style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColorDark)),
              Text(totalAmount,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: theme.focusColor)),
            ],
          ),
        ],
      ),
    );
  }
}
