import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:research_mantra_official/ui/screens/market/screens/sharks/widget/sharks_stocks_details.dart';

class SharksListScreen extends StatefulWidget {
  final List<Map<String, dynamic>> investorSharksDetails;
  const SharksListScreen({super.key, required this.investorSharksDetails});

  @override
  State<SharksListScreen> createState() => _SharksListScreenState();
}

class _SharksListScreenState extends State<SharksListScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: _buildInvestorsProfile(theme),
    );
  }

  //Widget for Investor profile
  Widget _buildInvestorsProfile(ThemeData theme) {
    final investorDetails = widget.investorSharksDetails;
    return ListView.builder(
        itemCount: investorDetails.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SharksStocksDetails(),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: theme.primaryColor,
                  border: Border.all(color: theme.shadowColor)),
              child: Row(
                children: [
                  SizedBox(
                    width: 40.w,
                    height: 40.h,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CachedNetworkImage(
                          imageUrl: investorDetails[index]['profileImageUrl']
                              .toString()),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        investorDetails[index]['Name'],
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.primaryColorDark,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "Holdings-${investorDetails[index]['Holdings']}",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.primaryColorDark,
                            ),
                          ),
                          SizedBox(
                            height: 12.h, // keep small to align with text
                            child: VerticalDivider(
                              color: theme.primaryColorDark,
                              thickness: 0.5,
                              width: 10.w, // space around divider
                            ),
                          ),
                          Text(
                            "₹${investorDetails[index]['investedAmount']}Cr",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.primaryColorDark,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: theme.primaryColorDark,
                    size: 20.sp,
                  )
                ],
              ),
            ),
          );
        });
  }
}
