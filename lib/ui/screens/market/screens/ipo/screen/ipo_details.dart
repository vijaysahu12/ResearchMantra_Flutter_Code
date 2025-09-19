import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:research_mantra_official/ui/screens/market/screens/ipo/widgets/ipo_widget.dart';

class IpoDetailsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> ipoDataList;
  const IpoDetailsScreen({super.key, required this.ipoDataList});

  @override
  State<IpoDetailsScreen> createState() => _IpoDetailsScreenState();
}

class _IpoDetailsScreenState extends State<IpoDetailsScreen> {
  final Map<String, dynamic> ipoJson = {
    "company": {
      "shortName": "SA",
      "name": "Sampat Aluminium",
      "dates": "17 Sep 25 - 19 Sep 25",
      "status": "LIVE"
    },
    "investment": {
      "minInvestment": "₹2,73,600",
      "issueSize": "₹30.53 cr",
      "growth": "+17.5%"
    },
    "subscription": {
      "overall": "56.51x",
      "qib": "21.7x",
      "nii": "70.19x",
      "retail": "67.73x",
      "time": "19 September 2025, 02:30 PM"
    },
    "ipoDates": [
      {"date": "17 Sep", "label": "Opening", "completed": true},
      {"date": "18 Sep", "label": "Closing", "completed": true},
      {"date": "22 Sep", "label": "Allotment", "completed": false},
      {"date": "24 Sep", "label": "Listing", "completed": false}
    ],
    "quota": {
      "application": "Retail (Min)",
      "lots": "2",
      "shares": "2400",
      "amount": "₹2,88,000"
    },
    "about": {
      "founded": "1999",
      "md": "Mr Sanket San...",
      "description":
          "Sampat Aluminium is engaged in the manufacturing of aluminium long products..."
    },
    "issueDetails": {
      "lotSize": "1200 Shares",
      "priceBand": "₹114 - ₹120",
      "faceValue": "₹10 per share"
    },
    "financials": {
      "revenue": [
        {"year": "2023", "value": "129.22"},
        {"year": "2024", "value": "147.01"},
        {"year": "2025", "value": "132.72"}
      ]
    },
    "reservation": [
      {"label": "Anchor Investor", "percent": 21.80, "color": "red"},
      {"label": "QIB", "percent": 36.41, "color": "blue"},
      {"label": "HNI", "percent": 10.96, "color": "green"},
      {"label": "Retail", "percent": 25.67, "color": "purple"},
    ],
    "expertVerdict": {
      "status": "May Apply",
      "pros": [
        "Established expertise in aluminium goods and wires",
        "Strategic plant location in Kadi, Gujarat"
      ],
      "cons": [
        "Limited product portfolio reduces diversification opportunities",
        "Dependence on aluminum prices affects profitability"
      ]
    }
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: _buildIPoContainer(theme),
    );
  }

//Widget for Ipo Container
  Widget _buildIPoContainer(ThemeData theme) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: widget.ipoDataList.length,
      itemBuilder: (context, index) {
        final ipo = widget.ipoDataList[index];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        IpoFullDetailsWidget(ipoData: ipoJson),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.shadowColor,
                    width: 1,
                  ),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Company name and type badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            ipo['companyName'],
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: theme.primaryColorDark,
                              fontSize: 12.sp,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: theme.indicatorColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              ipo['companyType'],
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: theme.primaryColor,
                                fontSize: 10.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      // Dates
                      Text(
                        '${ipo['openClosedDates']}',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.focusColor,
                          fontSize: 8.sp,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      // Min investment | Issue size | GMP
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Min Investment',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.focusColor,
                                  fontSize: 8.sp,
                                ),
                              ),
                              Text(
                                ipo['minInvestment'],
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: theme.primaryColorDark,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Issue Size',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.focusColor,
                                  fontSize: 8.sp,
                                ),
                              ),
                              Text(
                                ipo['issueSize'],
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: theme.primaryColorDark,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'GMP',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.focusColor,
                                  fontSize: 8.sp,
                                ),
                              ),
                              Text(
                                ipo['gmp'],
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: ipo['gmp'].toString().startsWith('+')
                                      ? theme.secondaryHeaderColor
                                      : theme.disabledColor,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
