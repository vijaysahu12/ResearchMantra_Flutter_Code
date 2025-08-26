import 'package:flutter/material.dart';
import 'package:research_mantra_official/data/models/subscription/subscription_sinlge_product_model.dart';

class SubscriptionDurationList extends StatelessWidget {
  final BuildContext context;
  final ThemeData theme;
  final List<SubscriptionDuration> subscriptionDurations;
  final int productSubscriptionIndex;
  final int selectedPlanIndex;
  final int selectedDurationIndex;
  final void Function(SubscriptionDuration duration, int index) onTap;

  const SubscriptionDurationList({
    super.key,
    required this.context,
    required this.theme,
    required this.subscriptionDurations,
    required this.productSubscriptionIndex,
    required this.selectedPlanIndex,
    required this.selectedDurationIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(subscriptionDurations.length, (durationIndex) {
          final duration = subscriptionDurations[durationIndex];
          final isSelected = selectedPlanIndex == productSubscriptionIndex &&
              selectedDurationIndex == durationIndex;

          return GestureDetector(
            onTap: () => onTap(duration, durationIndex),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.2,
              padding: const EdgeInsets.all(10),
              child: SubscriptionDurationCard(
                isRecommended: duration.isRecommended ?? false,
                monthlyPayment: duration.perMonth ?? '0.0',
                netPayment: duration.netPayment.toString(),
                actualPayment: duration.actualPrice.toString(),
                title: duration.subscriptionDurationName ?? '',
                theme: theme,
                isSelected: isSelected,
              ),
            ),
          );
        }),
      ),
    );
  }
}

class SubscriptionDurationCard extends StatelessWidget {
  final String title;
  final Color? color;
  final ThemeData theme;
  final String monthlyPayment;
  final String netPayment;
  final String actualPayment;
  final bool isRecommended;
  final bool isSelected;

  const SubscriptionDurationCard({
    super.key,
    required this.title,
    this.color,
    required this.theme,
    required this.monthlyPayment,
    required this.netPayment,
    required this.actualPayment,
    required this.isRecommended,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      alignment: const Alignment(-1, -0.55),
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: 100,
          padding: const EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? theme.disabledColor
                  : (color ?? Colors.grey).withOpacity(0.5),
              width: isSelected ? 1 : 0.5,
            ),
            color: theme.primaryColor,
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? theme.disabledColor.withOpacity(0.5)
                    : theme.shadowColor,
                spreadRadius: isSelected ? 1 : 0,
                blurRadius: isSelected ? 2 : 0,
                offset: Offset(0, isSelected ? 2 : 1),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: theme.disabledColor.withOpacity(isSelected ? 1 : 0.7),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(8)),
                ),
                child: Center(
                  child: Text(
                    title.length > 40 ? '${title.substring(0, 40)}...' : title,
                    maxLines: 3,
                    style: TextStyle(
                      fontSize: screenHeight * 0.015,
                      fontWeight: FontWeight.w700,
                      color: theme.floatingActionButtonTheme.foregroundColor,
                    ),
                  ),
                ),
              ),
              if (isRecommended) const SizedBox(height: 4),
              Text(
                '₹$actualPayment',
                style: TextStyle(
                  fontSize: screenHeight * 0.017,
                  color: theme.focusColor,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              Text(
                '₹$netPayment',
                maxLines: 3,
                style: TextStyle(
                  fontSize: screenHeight * 0.015,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColorDark,
                ),
              ),
              const SizedBox(height: 5),
              Container(
                width: screenWidth * 0.2,
                padding: const EdgeInsets.symmetric(vertical: 2),
                decoration: BoxDecoration(
                  color: theme.disabledColor.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.currency_rupee,
                      size: screenHeight * 0.016,
                      color: theme.floatingActionButtonTheme.foregroundColor,
                    ),
                    Text(
                      monthlyPayment,
                      style: TextStyle(
                        fontSize: screenHeight * 0.016,
                        color: theme.floatingActionButtonTheme.foregroundColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (isRecommended)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: theme.primaryColorDark,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(4),
                bottomRight: Radius.circular(4),
              ),
            ),
            child: Text(
              'Recommended',
              style: TextStyle(
                color: theme.primaryColor,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}
