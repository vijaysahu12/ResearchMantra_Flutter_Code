import 'package:flutter/material.dart';
import 'package:research_mantra_official/data/models/sip_calculator/sip_response_model.dart';
import 'package:research_mantra_official/ui/components/sip_calculator/sip_summary.dart';
import 'package:research_mantra_official/utils/utils.dart';

class SipMarketReturns extends StatelessWidget {
  final List<ProjectedSipReturns> projectedSipReturnsTable;
  final double expectedAmount;
  final double amountInvested;
  final double wealthGain;
  final bool incrementalRate;

  const SipMarketReturns({
    super.key,
    required this.projectedSipReturnsTable,
    required this.expectedAmount,
    required this.amountInvested,
    required this.wealthGain,
    required this.incrementalRate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SipSummaryContainer(
            expectedAmount: expectedAmount,
            amountInvested: amountInvested,
            wealthGain: wealthGain,
          ),
          SizedBox(height: 10),

          Expanded(
            child:
                 SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    // Set a minimum width to ensure all columns are visible
                    width: MediaQuery.of(context).size.width * 1.6,
                    child: Column(
                      children: [
                        // Table header
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              _headerCell("Year", theme, 1),
                              _divider(),
                              if (incrementalRate) ...[
                                _headerCell("Incremental Rate", theme, 2),
                                _divider(),
                              ],
                              _headerCell("SIP Amount", theme, 3),
                              _divider(),
                              _headerCell("Invested Amount", theme, 3),
                              _divider(),
                              _headerCell("Total Invested Amount", theme, 3),
                              _divider(),
                              _headerCell("Returns", theme, 3),
                            ],
                          ),
                        ),
                        
                        SizedBox(height: 10),
                        
                        // Table data
                        Expanded(
                          child: ListView.separated(
                            itemCount: projectedSipReturnsTable.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 4),
                            itemBuilder: (context, index) {
                              final item = projectedSipReturnsTable[index];
                              return Container(
                                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: theme.primaryColor,
                                  border: Border.all(color: theme.shadowColor, width: 1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    _dataCell("${item.duration}", theme, 1),
                                    _divider(),
                                    if (incrementalRate) ...[
                                      _dataCell(
                                        '${Utils.formatValue(item.incrementalRateInFuture)}%',
                                        theme,
                                        2,
                                      ),
                                      _divider(),
                                    ],
                                    _dataCell('₹${item.sipAmount}', theme, 3),
                                    _divider(),
                                    _dataCell('₹${item.investedAmount}', theme, 3),
                                    _divider(),
                                    _dataCell('₹${item.totalInvestedAmount}', theme, 3),
                                    _divider(),
                                    _dataCell('₹${item.futureValue}', theme, 3),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          ),
        ],
      ),
    );
  }

  // Header cell
  Widget _headerCell(String text, ThemeData theme, int flex) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: theme.primaryColorDark,
        ),
        maxLines: 2,
        textAlign: TextAlign.center,
      ),
    );
  }

  // Data cell
  Widget _dataCell(String text, ThemeData theme, int flex) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: theme.primaryColorDark,
        ),
        maxLines: 2,
        textAlign: TextAlign.center,
      ),
    );
  }

  // Vertical divider
  Widget _divider() {
    return Container(
      width: 1,
      height: 24,
      color: Colors.grey.withOpacity(0.5),
      margin: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}