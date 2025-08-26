import 'package:flutter/material.dart';
import 'package:research_mantra_official/data/models/research/research_detail_data_model.dart';
import 'package:research_mantra_official/ui/screens/research/widgets/custom_cell.dart';

class LastOneYearSalesComponents extends StatefulWidget {
  final String comapnayName;
  final ResearchDataModel researchDataModel;

  const LastOneYearSalesComponents({
    super.key,
    required this.researchDataModel,
    required this.comapnayName,
  });

  @override
  State<LastOneYearSalesComponents> createState() =>
      _LastOneYearSalesComponentsState();
}

class _LastOneYearSalesComponentsState
    extends State<LastOneYearSalesComponents> {
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
    final monthlyPrices =
        widget.researchDataModel.lastOneYearMonthlyPrices ?? [];

    if (monthlyPrices.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        // Fixed Price Column
        SizedBox(
          //color: Theme.of(context).cardColor,
          width: 85, // Fixed width for the non-scrollable column
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Cell for Price
              customCell(
                text: "Price",
                context: context,
                color: Theme.of(context).shadowColor,
                padding: const EdgeInsets.only(
                  bottom: 10,
                  top: 10,
                  left: 5,
                ),
              ),
              // Company Name Cell
              customCell(
                text: widget.comapnayName,
                context: context,
                padding: const EdgeInsets.only(bottom: 10, top: 10, left: 5),
              ),
            ],
          ),
        ),
        // Scrollable content wrapped in a Scrollbar
        Expanded(
          child: Scrollbar(
            controller: _scrollController,
            radius: const Radius.circular(5),
            thickness: 3.0,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: _scrollController,
              child: Row(
                children: List.generate(
                  monthlyPrices.length,
                  (index) {
                    final data = monthlyPrices[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customCell(
                          text: data.month ?? "-",
                          context: context,
                          color: Theme.of(context).shadowColor,
                          padding: const EdgeInsets.only(
                              bottom: 10, top: 10, left: 12),
                        ),
                        customCell(
                          text: data.price?.toString() ?? "-",
                          context: context,
                          padding: const EdgeInsets.only(
                              bottom: 10, top: 10, left: 10),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
