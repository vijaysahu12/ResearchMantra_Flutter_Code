import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        backgroundColor: theme.primaryColor,
        body: Column(
          children: [_buildPrePostWidget(theme)],
        ));
  }

  //Widget for Pre and post market
  Widget _buildPrePostWidget(ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(color: theme.shadowColor),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Market Report",
                    style: TextStyle(
                      color: theme.primaryColorDark,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "Daily market report at your fingertips.",
                    style: TextStyle(
                      color: theme.primaryColorDark,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.keyboard_arrow_up,
                size: 22.sp,
                color: theme.focusColor,
              )
            ],
          )
        
        //Container for pre and post 
        
        
        ],
      ),
    );
  }
}
