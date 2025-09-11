import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class KeyChangesScreen extends StatefulWidget {
  const KeyChangesScreen({super.key});

  @override
  State<KeyChangesScreen> createState() => _KeyChangesScreenState();
}

class _KeyChangesScreenState extends State<KeyChangesScreen> {
  final List<Map<String, dynamic>> investorDetails = [
    {
      "Id": 1,
      "Name": "Rakesh Jhunjhunwala & Assoc",
      "Holdings": "24",
      "investedAmount": "38,338",
      "profileImageUrl": "https://etimg.etb2bimg.com/photo/90351120.cms",
      "date": "12-02-2025",
      "stockSymbol": "ORIRAIL",
      "companyName": "Oriental ral Infrastrcuture Ltd",
      "qtyHeld": "35",
      "qtyChange": "35",
      "currentChange": "5.0",
      "tradeType": "Sold" //AddNew,Bought
    },
    {
      "Id": 5,
      "Name": "Radhakishan Damani",
      "Holdings": "15",
      "investedAmount": "27,540",
      "profileImageUrl": "https://etimg.etb2bimg.com/photo/90351120.cms",
      "date": "12-02-2025",
      "stockSymbol": "ORIRAIL",
      "companyName": "Oriental ral Infrastrcuture Ltd",
      "qtyHeld": "35",
      "qtyChange": "35",
      "currentChange": "5.0",
      "tradeType": "Sold" //AddNew,Bought
    },
    {
      "Id": 66,
      "Name": "Mukul Agrawal",
      "Holdings": "12",
      "investedAmount": "18,920",
      "profileImageUrl": "https://etimg.etb2bimg.com/photo/90351120.cms",
      "date": "12-02-2025",
      "stockSymbol": "ORIRAIL",
      "companyName": "Oriental ral Infrastrcuture Ltd",
      "qtyHeld": "35",
      "qtyChange": "35",
      "currentChange": "5.0",
      "tradeType": "Sold" //AddNew,Bought
    },
    {
      "Id": 43,
      "Name": "Azim Premji",
      "Holdings": "20",
      "investedAmount": "45,100",
      "profileImageUrl": "https://etimg.etb2bimg.com/photo/90351120.cms",
      "date": "12-02-2025",
      "stockSymbol": "ORIRAIL",
      "companyName": "Oriental ral Infrastrcuture Ltd",
      "qtyHeld": "35",
      "qtyChange": "35",
      "currentChange": "5.0",
      "tradeType": "Sold" //AddNew,Bought
    },
    {
      "Id": 53,
      "Name": "Ashish Dhawan",
      "Holdings": "10",
      "investedAmount": "12,780",
      "profileImageUrl": "https://etimg.etb2bimg.com/photo/90351120.cms",
      "date": "12-02-2025",
      "stockSymbol": "ORIRAIL",
      "companyName": "Oriental ral Infrastrcuture Ltd",
      "qtyHeld": "35",
      "qtyChange": "35",
      "currentChange": "5.0",
      "tradeType": "Sold" //AddNew,Bought
    },
    {
      "Id": 95,
      "Name": "Ashish Kacholia",
      "Holdings": "18",
      "investedAmount": "22,360",
      "profileImageUrl": "https://etimg.etb2bimg.com/photo/90351120.cms",
      "date": "12-02-2025",
      "stockSymbol": "ORIRAIL",
      "companyName": "Oriental ral Infrastrcuture Ltd",
      "qtyHeld": "35",
      "qtyChange": "35",
      "currentChange": "5.0",
      "tradeType": "Sold" //AddNew,Bought
    },
    {
      "Id": 50,
      "Name": "Anil Kumar",
      "Holdings": "8",
      "investedAmount": "9,840",
      "profileImageUrl": "https://etimg.etb2bimg.com/photo/90351120.cms",
      "date": "12-02-2025",
      "stockSymbol": "ORIRAIL",
      "companyName": "Oriental ral Infrastrcuture Ltd",
      "qtyHeld": "35",
      "qtyChange": "35",
      "currentChange": "5.0",
      "tradeType": "Sold" //AddNew,Bought
    },
    {
      "Id": 875,
      "Name": "Vijay Kedia",
      "Holdings": "14",
      "investedAmount": "19,250",
      "profileImageUrl": "https://etimg.etb2bimg.com/photo/90351120.cms",
      "date": "12-02-2025",
      "stockSymbol": "ORIRAIL",
      "companyName": "Oriental ral Infrastrcuture Ltd",
      "qtyHeld": "35",
      "qtyChange": "35",
      "currentChange": "5.0",
      "tradeType": "Sold" //AddNew,Bought
    },
    {
      "Id": 775,
      "Name": "Ajay Upendra",
      "Holdings": "6",
      "investedAmount": "7,430",
      "profileImageUrl": "https://etimg.etb2bimg.com/photo/90351120.cms",
      "date": "12-02-2025",
      "stockSymbol": "ORIRAIL",
      "companyName": "Oriental ral Infrastrcuture Ltd",
      "qtyHeld": "35",
      "qtyChange": "35",
      "currentChange": "5.0",
      "tradeType": "Sold" //AddNew,Bought
    },
  ];

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
        itemCount: investorDetails.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              //Todo:
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
                              imageUrl: investorDetails[index]
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
                            investorDetails[index]['Name'],
                            style: theme.textTheme.titleSmall?.copyWith(
                                color: theme.primaryColorDark, fontSize: 10.sp),
                          ),
                          Row(
                            children: [
                              Text(
                                "Holdings-${investorDetails[index]['Holdings']}",
                                style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.primaryColorDark,
                                    fontSize: 10.sp),
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
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
