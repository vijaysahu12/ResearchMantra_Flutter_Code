import 'package:flutter/material.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/data/models/research/research_detail_data_model.dart';
import 'package:research_mantra_official/ui/screens/research/widgets/custom_cell.dart';
import 'package:research_mantra_official/ui/screens/research/widgets/custom_divider.dart';

class LastTenYearSalesComponents extends StatefulWidget {
  final ResearchDataModel researchDataModel;
  const LastTenYearSalesComponents({
    super.key,
    required this.researchDataModel,
  });

  @override
  State<LastTenYearSalesComponents> createState() =>
      _LastTenYearSalesComponentsState();
}

class _LastTenYearSalesComponentsState
    extends State<LastTenYearSalesComponents> {
  late ScrollController _scrollController;

  final List<String> fixedLabels = [
    sales,
    opProfit,
    netProfit,
    otm,
    ntm,
    promoter
  ];

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
    final salesData = widget.researchDataModel.lastTenYearSales ?? [];

    return Stack(
      children: [
        // Scrollable table content
        Scrollbar(
          controller: _scrollController,
          radius: const Radius.circular(5), // Optional: for rounded scrollbar
          thickness: 3.0, // Optional: Adjust scrollbar thickness
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _scrollController,
            child: Row(
              children: List.generate(
                salesData.length,
                (index) {
                  final yearData = salesData[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Year cell
                      customCell(
                        text: yearData.year?.substring(0, 4) ?? "-",
                        context: context,
                        color: Theme.of(context).shadowColor,
                      ),
                      // Conditional cells for other data
                      ..._buildScrollableCells(
                          context, yearData, salesData.length, index),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        // Fixed INR column
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          child: Container(
            width: 90,
            color: Theme.of(context).primaryColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header for the fixed column
                customCell(
                  text: "INR",
                  context: context,
                  color: Theme.of(context).shadowColor,
                ),
                for (var i = 0; i < fixedLabels.length; i++) ...[
                  customCell(
                    text: fixedLabels[i],
                    context: context,
                  ),
                  // Add dividers only between intermediate rows
                  if (i != fixedLabels.length - 1)
                    customDivider(context: context),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Helper method to build scrollable cells with conditional dividers
  List<Widget> _buildScrollableCells(
    BuildContext context,
    dynamic yearData,
    int totalRows,
    int currentIndex,
  ) {
    return [
      _buildCellWithDivider(context, yearData.sales, currentIndex, totalRows),
      _buildCellWithDivider(
          context, yearData.opProfit, currentIndex, totalRows),
      _buildCellWithDivider(
          context, yearData.netProfit, currentIndex, totalRows),
      _buildCellWithDivider(context, yearData.otm, currentIndex, totalRows),
      _buildCellWithDivider(context, yearData.npm, currentIndex, totalRows),
      customCell(
        text: yearData.promotersPercent != null
            ? yearData.promotersPercent.toString()
            : "-", // If null, show "-"
        context: context,
      ),
    ];
  }

  // Helper method to create a cell with conditional dividers
  Widget _buildCellWithDivider(
      BuildContext context, dynamic value, int index, int totalRows) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customCell(
          text: value != null ? value.toString() : "-", // If null, show "-"
          context: context,
        ),
        // Only add divider if it's not the last row
        if (index < totalRows) customDivider(context: context),
      ],
    );
  }
}
