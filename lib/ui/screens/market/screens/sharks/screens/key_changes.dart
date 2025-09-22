import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:research_mantra_official/ui/common_components/common_outline_button.dart';
import 'package:research_mantra_official/ui/screens/market/screens/sharks/widget/sharks_stocks_details.dart';

class KeyChangesScreen extends StatefulWidget {
  final List<Map<String, dynamic>> investorDetails;
  const KeyChangesScreen({
    super.key,
    required this.investorDetails,
  });

  @override
  State<KeyChangesScreen> createState() => _KeyChangesScreenState();
}

class _KeyChangesScreenState extends State<KeyChangesScreen> {
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
    return ListView.builder(
        itemCount: widget.investorDetails.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SharksStocksDetails(
                      name: widget.investorDetails[index]['Name']),
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
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 35.w,
                        height: 35.h,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(
                              imageUrl: widget.investorDetails[index]
                                      ['profileImageUrl']
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
                            widget.investorDetails[index]['Name'],
                            style: theme.textTheme.titleSmall?.copyWith(
                                color: theme.primaryColorDark, fontSize: 12.sp),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Text(
                            "Date :${widget.investorDetails[index]['date']}",
                            style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.primaryColorDark, fontSize: 10.sp),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.investorDetails[index]['stockSymbol'],
                            style: theme.textTheme.titleSmall?.copyWith(
                                color: theme.primaryColorDark, fontSize: 10.sp),
                          ),
                          Text(
                            widget.investorDetails[index]['companyName'],
                            style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.primaryColorDark, fontSize: 10.sp),
                          )
                        ],
                      ),
                      CommonOutlineButton(
                          textStyle: TextStyle(
                              fontSize: 10.sp, color: theme.primaryColor),
                          borderColor: Colors.transparent,
                          borderRadius: 4.0,
                          backgroundColor: theme.secondaryHeaderColor,
                          text: widget.investorDetails[index]['tradeType'])
                    ],
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Qty. held",
                            style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.focusColor, fontSize: 10.sp),
                          ),
                          Text(
                            "₹${widget.investorDetails[index]['qtyHeld']} Cr",
                            style: theme.textTheme.titleSmall?.copyWith(
                                color: theme.primaryColorDark, fontSize: 10.sp),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "C. Holding(%)",
                            style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.focusColor, fontSize: 10.sp),
                          ),
                          Text(
                            widget.investorDetails[index]['qtyChange'],
                            style: theme.textTheme.titleSmall?.copyWith(
                                color: theme.primaryColorDark, fontSize: 10.sp),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "Qty. Change(%)",
                            style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.focusColor, fontSize: 10.sp),
                          ),
                          Text(
                            "${widget.investorDetails[index]['currentChange']}",
                            style: theme.textTheme.titleSmall?.copyWith(
                                color: theme.primaryColorDark, fontSize: 10.sp),
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
