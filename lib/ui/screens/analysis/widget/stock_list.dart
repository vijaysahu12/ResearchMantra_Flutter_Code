import 'package:flutter/material.dart';
import 'package:research_mantra_official/data/models/market_analysis/specifc_postmarket_analysis.dart';
import 'package:research_mantra_official/ui/screens/analysis/widget/custom_cell2.dart';
import 'package:research_mantra_official/ui/screens/research/widgets/custom_divider.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

class StockList extends StatefulWidget {
  final List<Stock> stocks;
  final bool leadingPerformer;
  const StockList({
    super.key,
    required this.stocks,
    required this.leadingPerformer,
  });

  @override
  State<StockList> createState() => _StockListState();
}

class _StockListState extends State<StockList> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return widget.stocks.isEmpty
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  widget.leadingPerformer
                      ? "No Leading Performer Today "
                      : "No Lagging Performance Today ",
                  style: TextStyle(
                    color: theme.primaryColorDark,
                    fontFamily: fontFamily,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  )),
            ],
          )
        : ClipRRect(
            borderRadius:
                BorderRadius.circular(8.0), // Match the table's border radius
            child: Scrollbar(
              thickness: 2,
              child: Row(
                children: [
                  _buildColumn(
                    context: context,
                    header: "Name",
                    data: widget.stocks.map((e) => e.name ?? "N/A").toList(),
                    changepercentage: [],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: _scrollController,
                      child: Row(
                        children: [
                          _buildColumn(
                            context: context,
                            header: "Change %",
                            data: widget.stocks.map((e) {
                              final changePercentage = e.changePercentage;
                              return changePercentage != null
                                  ? "${changePercentage.toStringAsFixed(2)}%"
                                  : "N/A";
                            }).toList(),
                            changepercentage: widget.stocks.map((e) {
                              final changePercentage = e.changePercentage;
                              return changePercentage != null
                                  ? "${changePercentage.toStringAsFixed(2)}%"
                                  : "N/A";
                            }).toList(),
                          ),
                          _buildColumn(
                            context: context,
                            header: "Close",
                            data: widget.stocks
                                .map(
                                    (e) => e.close?.toStringAsFixed(2) ?? "N/A")
                                .toList(),
                            changepercentage: widget.stocks.map((e) {
                              final changePercentage = e.changePercentage;
                              return changePercentage != null
                                  ? "${changePercentage.toStringAsFixed(2)}%"
                                  : "N/A";
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }

  // Helper method to build scrollable columns
  Widget _buildColumn({
    required BuildContext context,
    required String header,
    required List<String> data,
    required List<String> changepercentage,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header for each column

        customCell2(
          width: MediaQuery.of(context).size.width / 3.4,
          text: header,
          context: context,
          isHead: true,
        ),
        customDivider(
            context: context, width: MediaQuery.of(context).size.width / 3.3),
        // Data rows for each column
        for (var i = 0; i < data.length; i++) ...[
          if (changepercentage.isNotEmpty) ...[
            customCell2(
              text: data[i],
              changeText: changepercentage[i],
              context: context,
              width: MediaQuery.of(context).size.width / 3.5,
            )
          ] else if (changepercentage.isEmpty) ...[
            customCell2(
              text: data[i],
              context: context,
              width: MediaQuery.of(context).size.width / 3.5,
            )
          ],
          if (i != data.length - 1)
            customDivider(
                context: context,
                width: MediaQuery.of(context).size.width / 3.3),
        ],
      ],
    );
  }
}
