import 'package:flutter/material.dart';
import 'package:research_mantra_official/data/models/market_analysis/specifc_premarket_analysis.dart';
import 'package:research_mantra_official/ui/screens/analysis/widget/custom_cell2.dart';
import 'package:research_mantra_official/ui/screens/research/widgets/custom_divider.dart';

class IndicesList extends StatefulWidget {
  final List<Index> indices;
  final bool globalIndices;

  const IndicesList(
      {super.key, required this.indices, required this.globalIndices});

  @override
  State<IndicesList> createState() => _IndicesListState();
}

class _IndicesListState extends State<IndicesList> {
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
   
    return ClipRRect(
      borderRadius:
          BorderRadius.circular(8.0), // Match the table's border radius
      child: Scrollbar(
        thickness: 2,
        child: Row(
          children: [
            _buildColumn(
              context: context,
              header: "Name",
              data: widget.indices.map((e) => e.name ?? "N/A").toList(),
              changepercentage: [],
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _scrollController,
                child: Row(
                  children: [
                    if (widget.globalIndices) ...[
                      _buildColumn(
                        context: context,
                        header: "Continent",
                        data: widget.indices
                            .map((e) => e.continent ?? "N/A")
                            .toList(),
                        changepercentage: [],
                      )
                    ],
                    _buildColumn(
                      context: context,
                      header: "Change %",
                      data: widget.indices.map((e) {
                        final changePercentage = e.changePercentage;
                        return changePercentage != null
                            ? "${changePercentage.toStringAsFixed(2)}%"
                            : "N/A";
                      }).toList(),
                      changepercentage: widget.indices.map((e) {
                        final changePercentage = e.changePercentage;
                        return changePercentage != null
                            ? "${changePercentage.toStringAsFixed(2)}%"
                            : "N/A";
                      }).toList(),
                    ),
                    _buildColumn(
                      context: context,
                      header: "Close",
                      data: widget.indices
                          .map((e) => e.close?.toStringAsFixed(2) ?? "N/A")
                          .toList(),
                      changepercentage: widget.indices.map((e) {
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
