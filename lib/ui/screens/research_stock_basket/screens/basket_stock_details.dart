import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';
import 'package:research_mantra_official/ui/screens/research_stock_basket/widgets/stocks_list.dart';

class BasketStockDetailsScreen extends StatefulWidget {
  final String title;

  const BasketStockDetailsScreen({super.key, required this.title});

  @override
  State<BasketStockDetailsScreen> createState() =>
      _BasketStockDetailsScreenState();
}

class _BasketStockDetailsScreenState extends State<BasketStockDetailsScreen> {
  final Map<String, dynamic> basketStockDetails = {
    "id": "BASKET123",
    "title": "Growth Portfolio",
    "imageUrl":
        "https://img.freepik.com/free-vector/shiny-golden-number-one-star-label-design_1017-27875.jpg?semt=ais_hybrid&w=740&q=80",
    "returns": {
      "percentage": "+41.85%",
      "absolute": "+12,300 INR",
    },
    "rebalance": {
      "type": "Quarterly",
      "minAmount": "8,79,872",
      "volatility": "High",
    },
    "overview":
        "Take a bold step towards higher returns with the wealth. This basket is designed to maximize growth with diversified strategies while managing volatility. Suitable for investors with moderate to high risk appetite.",
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rebalance = basketStockDetails['rebalance'] as Map<String, dynamic>;

    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: CommonAppBarWithBackButton(
        appBarText: widget.title,
        handleBackButton: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header Row ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: basketStockDetails['imageUrl'],
                        width: 50.sp,
                        height: 50.sp,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      basketStockDetails['title'],
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: theme.primaryColorDark,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      basketStockDetails['returns']['percentage'],
                      style: theme.textTheme.headlineMedium
                          ?.copyWith(color: theme.secondaryHeaderColor),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      basketStockDetails['returns']['absolute'],
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: theme.focusColor),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // --- Rebalance Card ---
            _CardContainer(
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatItem(
                        value: rebalance['type'],
                        label: "Rebalance",
                        theme: theme),
                    const VerticalDivider(thickness: 0.6),
                    _StatItem(
                        value: rebalance['minAmount'],
                        label: "Min. Amount",
                        theme: theme),
                    const VerticalDivider(thickness: 0.6),
                    _StatItem(
                        value: rebalance['volatility'],
                        label: "Volatility",
                        theme: theme),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            StockListCard(),
            const SizedBox(height: 16),
            // --- Overview ---
            _CardContainer(
              child: Text(
                basketStockDetails['overview'],
                style: theme.textTheme.bodySmall?.copyWith(fontSize: 12.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Reusable Card Container
class _CardContainer extends StatelessWidget {
  final Widget child;

  const _CardContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.primaryColor,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Reusable Stat Item
class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final ThemeData theme;

  const _StatItem(
      {required this.value, required this.label, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.primaryColorDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(color: theme.focusColor),
        ),
      ],
    );
  }
}
