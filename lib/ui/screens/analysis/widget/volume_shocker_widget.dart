import 'package:flutter/material.dart';
import 'package:research_mantra_official/constants/assets.dart';
import 'package:research_mantra_official/data/models/market_analysis/specifc_postmarket_analysis.dart';
import 'package:research_mantra_official/ui/screens/analysis/widget/custom_cell2.dart';

import 'package:research_mantra_official/ui/screens/research/widgets/custom_divider.dart';

class VolumeListWidget extends StatefulWidget {
  final List<VolumeShocker> volumeStocks;

  const VolumeListWidget({
    super.key,
    required this.volumeStocks,
  });

  @override
  State<VolumeListWidget> createState() => _VolumeListWidgetState();
}

class _VolumeListWidgetState extends State<VolumeListWidget> {
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
    return Column(
      children: [
        Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.only(
            top: 12.0,
            // bottom: 8,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
                // border: Border.all(color: theme.focusColor.withOpacity(0.4)),
                color: theme.primaryColor,
                boxShadow: [
                  BoxShadow(
                    color: theme.focusColor.withOpacity(0.4),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(0, 1),
                  ),
                ],
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8), topRight: Radius.circular(8))

                // BorderRadius.circular(8)

                ),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 225, 7, 7),
                    shape: BoxShape.circle,
                    border: Border.all(color: theme.primaryColor),
                    gradient: const LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Color(0xffAD0000),
                        Color(0xffFF2929),
                      ],
                    ),
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.asset(
                        kingResearchIcon,
                        // stockLogo,
                        scale: 5,
                        fit: BoxFit.cover,
                      )),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  'Volume Shocker',
                  style: TextStyle(
                    color: theme.primaryColorDark,
                    //  Color.fromARGB(255, 238, 30, 30),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),

        //  const GradientButton(text: 'Volume Shocker' ,fromtable: true,),

        Container(
          decoration: BoxDecoration(
            // border: Border.all(
            //   color: theme.focusColor.withOpacity(0.4),
            // ),
            color: theme.primaryColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            // BorderRadius.circular(8)

            boxShadow: [
              BoxShadow(
                color: theme.focusColor.withOpacity(0.4),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius:
                BorderRadius.circular(8.0), // Match the table's border radius
            child: Scrollbar(
              thickness: 2,
              child: Row(
                children: [
                  _buildColumn(
                    context: context,
                    header: "Name",
                    data: widget.volumeStocks
                        .map((e) => e.name ?? "N/A")
                        .toList(),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: _scrollController,
                      child: Row(
                        children: [
                          _buildColumn(
                            context: context,
                            header: "Volume ",
                            data: widget.volumeStocks.map((e) {
                              final changePercentage = e.volume;
                              return changePercentage != null
                                  ? "${changePercentage.toStringAsFixed(2)}%"
                                  : "N/A";
                            }).toList(),
                          ),
                          _buildColumn(
                            context: context,
                            header: "Close",
                            data: widget.volumeStocks
                                .map(
                                    (e) => e.close?.toStringAsFixed(2) ?? "N/A")
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  )
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
          customCell2(
            text: data[i],
            context: context,
            width: MediaQuery.of(context).size.width / 3.5,
          ),
          if (i != data.length - 1)
            customDivider(
                context: context,
                width: MediaQuery.of(context).size.width / 3.3),
        ],
      ],
    );
  }
}
