import 'package:flutter/material.dart';
import 'package:research_mantra_official/data/models/market_analysis/specifc_premarket_analysis.dart';
import 'package:research_mantra_official/ui/screens/analysis/widget/custom_cell2.dart';
import 'package:research_mantra_official/ui/screens/research/widgets/custom_divider.dart';

class CommoditiesList extends StatefulWidget {
  final Commodities? commodities;

  const CommoditiesList({super.key, required this.commodities});

  @override
  State<CommoditiesList> createState() => _CommoditiesListState();
}

class _CommoditiesListState extends State<CommoditiesList> {
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
    // Access commodities using a map
    final commoditiesData = {
      'gold': widget.commodities?.gold,
      'silver': widget.commodities?.silver,
      'crudeoil': widget.commodities?.crudeoil,
    };

    // Filter out null commodities
    final validCommodities =
        commoditiesData.entries.where((entry) => entry.value != null).toList();

    final names =
        validCommodities.map((entry) => entry.key.toUpperCase()).toList();
    final ltpValues = validCommodities
        .map((entry) => entry.value?.close != null
            ? entry.value!.close!.toStringAsFixed(2)
            : 'N/A')
        .toList();

    final changePercentages = validCommodities
        .map((entry) => entry.value?.changePercentage != null
            ? "${entry.value!.changePercentage!.toStringAsFixed(2)}%"
            : 'N/A')
        .toList();

    return Row(
      children: [
        _buildColumn(
            context: context,
            header: "Name",
            data: names,
            changepercentage: []),
        Expanded(
          child: Scrollbar(
            thickness: 2,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: _scrollController,
              child: Row(
                children: [
                  _buildColumn(
                      context: context,
                      header: "Close",
                      data: ltpValues,
                      changepercentage: changePercentages),
                  _buildColumn(
                      context: context,
                      header: "Change %",
                      data: changePercentages,
                      changepercentage: changePercentages),
                ],
              ),
            ),
          ),
        ),
      ],
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
          text: header,
          context: context,
          isHead: true,
          width: MediaQuery.of(context).size.width / 3.3,
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
