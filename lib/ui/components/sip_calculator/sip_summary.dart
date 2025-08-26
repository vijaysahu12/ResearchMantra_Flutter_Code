import 'package:flutter/material.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';
import 'package:research_mantra_official/utils/utils.dart';
import 'package:pie_chart/pie_chart.dart';

class SipSummary extends StatelessWidget {
  final double expectedAmount;
  final double amountInvested;
  final double wealthGain;
  const SipSummary({
    super.key,
    required this.expectedAmount,
    required this.amountInvested,
    required this.wealthGain,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.start,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PieChartWidget(
          expectedAmount: expectedAmount,
          amountInvested: amountInvested,
          wealthGain: wealthGain,
        )
      ],
    );
  }
}

double calculatePercentage(double part, double total) {
  if (total == 0) return 0.0; // Avoid division by zero
  return ((part / total) * 100).toDouble();
}

class PieChartWidget extends StatelessWidget {
  final double expectedAmount;
  final double amountInvested;
  final double wealthGain;
  const PieChartWidget(
      {super.key,
      required this.expectedAmount,
      required this.amountInvested,
      required this.wealthGain});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    //double wealthLost = wealthGain > 0 ? 0 : amountInvested - (expectedAmount + wealthGain);
    final dataMap = {
      "Wealth Gain": calculatePercentage(wealthGain, expectedAmount),
      "Amount Invested": calculatePercentage(amountInvested, expectedAmount),
      // "wealth Lost": calculatePercentage(wealthLost, expectedAmount),
    };

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.primaryColor.withValues(alpha: 0.7),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(500),
          bottomRight: Radius.circular(500),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFinancialRow(
              'Expected Amount',
              '₹${Utils.formatValue(expectedAmount)}',
              'Rs.$expectedAmount',
              Colors.blue,
              theme),
          const Divider(),
          _buildFinancialRow(
              'Amount Invested',
              '₹${Utils.formatValue(amountInvested)}',
              'Rs.$amountInvested',
              Colors.blue,
              theme),
          const Divider(),
          _buildFinancialRow(
              'Wealth Gain or Lost',
              '₹${Utils.formatValue(wealthGain)}',
              'Rs.$wealthGain',
              Utils.textColor(wealthGain, context),
              theme),
          const Divider(),
          const SizedBox(height: 10),
          SizedBox(
            height: 350,
            child: PieChart(
              dataMap: dataMap,
              animationDuration: const Duration(milliseconds: 800),
              chartRadius: 200,
              colorList: [
                //wealthGain < 0 ? Color(0xFFE74C3C) : Color(0xFF56C47F),
                Color(0xFF56C47F),
                // Green for walth gain
                Color(0xFF4A6FFF), // Blue for amount invested
                // Color.fromARGB(255, 231, 98, 83) // Red for wealth lost
              ],
              chartType: ChartType.disc,
              legendOptions: const LegendOptions(
                  showLegends: true,
                  legendPosition: LegendPosition.top,
                  showLegendsInRow: true,
                  legendTextStyle: TextStyle(
                      fontSize: 12,
                      fontFamily: fontFamily,
                      fontWeight: FontWeight.w600)),
              chartLegendSpacing: 10,
              chartValuesOptions: const ChartValuesOptions(
                showChartValueBackground: true,
                showChartValues: true,
                showChartValuesInPercentage: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget to create financial rows
  Widget _buildFinancialRow(String label, String amount, String lakhs,
      Color amountColor, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: theme.primaryColorDark,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: amountColor,
                ),
              ),
              Text(
                lakhs,
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontSize: 10,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// SipSummaryContainer: Display the financial data in a card-like format
class SipSummaryContainer extends StatelessWidget {
  final double expectedAmount;
  final double amountInvested;
  final double wealthGain;

  const SipSummaryContainer({
    super.key,
    required this.expectedAmount,
    required this.amountInvested,
    required this.wealthGain,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: theme.primaryColor,
        border: Border.all(color: theme.shadowColor, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Financial Details
          _buildFinancialRow(
              'Total Amount',
              '₹${Utils.formatValue(expectedAmount)}',
              'Rs.1',
              Colors.blue,
              theme),
          const Divider(),
          _buildFinancialRow(
              'Amount Invested',
              '₹${Utils.formatValue(amountInvested)}',
              'Rs.$amountInvested',
              Colors.blue,
              theme),
          const Divider(),
          _buildFinancialRow('Wealth Gain', '₹${Utils.formatValue(wealthGain)}',
              'Rs.$wealthGain', Utils.textColor(wealthGain, context), theme),
        ],
      ),
    );
  }

  // Helper widget to create financial rows
  Widget _buildFinancialRow(String label, String amount, String lakhs,
      Color amountColor, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: theme.primaryColorDark,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: amountColor,
          ),
        ),
      ],
    );
  }
}
