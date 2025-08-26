import 'package:flutter/material.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/data/models/research/research_detail_data_model.dart';
import 'package:research_mantra_official/ui/screens/research/widgets/custom_cell.dart';
import 'package:research_mantra_official/ui/screens/research/widgets/custom_divider.dart';
 
class CompanyTypeclass extends StatefulWidget {
  final ResearchDataModel researchDataModel;
  const CompanyTypeclass({super.key, required this.researchDataModel});
 
  @override
  State<CompanyTypeclass> createState() => _CompanyTypeclassState();
}
 
class _CompanyTypeclassState extends State<CompanyTypeclass> {
  List<String> heading = [
    // companyType,
    listOfUpTrend,
    spopUptrend,
    futursiticSector,
    hniInstitutionalPromotersBuy,
    specialSituation,
    futureVisibility
  ];
 
  List<bool?> companyList = [];
 
  @override
  void initState() {
    super.initState();
    companyList = [
      // false,
      widget.researchDataModel.companyType?.ltopUptrend ?? false,
      widget.researchDataModel.companyType?.stopOpUpTrend ?? false,
      widget.researchDataModel.companyType?.futuristicSector ?? false,
      widget.researchDataModel.companyType?.hniInstitutionalPromotersBuy ?? false,
      widget.researchDataModel.companyType?.specialSituations ?? false,
      widget.researchDataModel.companyType?.futureVisibility ?? false,
    ];
  }
 
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Theme.of(context).shadowColor,
          padding: const EdgeInsets.all(12),
        
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Company Type",
                style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "Evergreen",
                style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
                flex: 5,
                child: _buildColumn(
                  context: context,
                  data: heading,
                )),
            Expanded(
                child: _buildColumn(
              context: context,
              data: companyList,
            )),
          ],
        ),
      ],
    );
  }
}
 
Widget _buildColumn({
  required BuildContext context,
  required List data,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      for (var i = 0; i < data.length; i++) ...[
        if (data[i].runtimeType == bool) ...[
          customCell(
            text: data[i] == true ? yes : no,
            context: context,
          ),
        ] else ...[
          customCell(
              text: data[i],
              context: context,
              width: MediaQuery.of(context).size.width / 1),
        ],
        if (i != data.length - 1)
          customDivider(
              context: context, width: MediaQuery.of(context).size.width),
      ],
      customDivider(context: context, width: MediaQuery.of(context).size.width),
    ],
  );
}