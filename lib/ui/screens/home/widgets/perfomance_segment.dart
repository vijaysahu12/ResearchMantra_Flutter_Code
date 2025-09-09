import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:research_mantra_official/ui/common_components/shimmer_button.dart';

class PerformanceCard extends StatefulWidget {
  const PerformanceCard({super.key});

  @override
  State<PerformanceCard> createState() => _PerformanceCardState();
}

class _PerformanceCardState extends State<PerformanceCard> {
  int selectedTabIndex = 0;

  // Optimized data structure for different tab performance metrics
  static const Map<int, Map<String, dynamic>> performanceData = {
    0: {
      // Stocks
      'avgReturn': '14.71%',
      'avgDuration': '36 days',
      'accuracy': '94.07%',
    },
    1: {
      // Futures
      'avgReturn': '22.45%',
      'avgDuration': '18 days',
      'accuracy': '87.32%',
    },
    2: {
      // Options
      'avgReturn': '31.89%',
      'avgDuration': '7 days',
      'accuracy': '76.54%',
    },
    3: {
      // Commodity
      'avgReturn': '18.23%',
      'avgDuration': '42 days',
      'accuracy': '89.12%',
    },
  };

  static const List<String> tabLabels = ['Stocks', 'Futures', 'Options', 'MCX'];

  @override
  Widget build(BuildContext context) {
    final currentData = performanceData[selectedTabIndex]!;
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFF2B2B2B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(theme),
          _buildTabBar(theme),
          _buildPerformanceMetrics(currentData, theme),
          _buildActivateButton(theme),
          _buildFooterNote(theme),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Susmitha Performance',
            style: TextStyle(
              color: theme.primaryColor,
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle,
                      color: theme.primaryColor, size: 14.sp),
                  SizedBox(width: 4),
                  Text(
                    'SEBI Reg.',
                    style: TextStyle(
                      color: theme.primaryColor,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Icon(Icons.info_outline, color: theme.primaryColor, size: 16.sp),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: List.generate(
          tabLabels.length,
          (index) => Expanded(
            child: GestureDetector(
              onTap: () => _onTabSelected(index),
              child: Container(
                margin: EdgeInsets.only(
                    right: index < tabLabels.length - 1 ? 8 : 0),
                padding: EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: selectedTabIndex == index
                      ? theme.secondaryHeaderColor
                      : theme.primaryColor,
                  borderRadius: BorderRadius.circular(4),
                  border: selectedTabIndex == index
                      ? Border.all(
                          color: theme.primaryColor,
                        )
                      : Border.all(color: Colors.transparent),
                ),
                child: Text(
                  tabLabels[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: theme.primaryColorDark,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPerformanceMetrics(Map<String, dynamic> data, ThemeData theme) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildMetricColumn(
                  'Avg. return / trade',
                  data['avgReturn'],
                  Colors.green,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.grey[600],
              ),
              Expanded(
                child: _buildMetricColumn(
                  'Avg. duration',
                  data['avgDuration'],
                  Colors.orange,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 1,
            color: Colors.grey[600],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Trades Hit Accuracy:',
                style: TextStyle(
                  color: theme.primaryColor,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                ' ${data['accuracy']}',
                style: TextStyle(
                  color: theme.primaryColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricColumn(String label, String value, Color valueColor) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 13.sp,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildActivateButton(ThemeData theme) {
    return Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 5),
        child: ShimmerButton(
          isShimmer: false,
          width: 220,
          height: 30,
          fontSize: 10,
          text: "Activate Now",
          backgroundColor: theme.primaryColor,
          textColor: theme.primaryColorDark,
          onPressed: _onActivateTrialPressed,
        )

        //  SizedBox(
        //   width: double.infinity,
        //   height: 35.h,
        //   child: ElevatedButton(
        //     onPressed: _onActivateTrialPressed,
        //     style: ElevatedButton.styleFrom(
        //       backgroundColor: theme.primaryColor,
        //       foregroundColor: theme.primaryColorDark,
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(8),
        //       ),
        //       elevation: 0,
        //     ),
        //     child: Text(
        //       'Activate Now',
        //       style: TextStyle(
        //         fontSize: 14.sp,
        //         fontWeight: FontWeight.w600,
        //         color: theme.primaryColorDark,
        //       ),
        //     ),
        //   ),
        // ),

        );
  }

  Widget _buildFooterNote(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Performance based on completed trades.',
            style: TextStyle(
              color: theme.primaryColor,
              fontSize: 11.sp,
            ),
          ),
          SizedBox(width: 8),
          Icon(Icons.info_outline, color: theme.primaryColor, size: 16.sp),
        ],
      ),
    );
  }

  // Optimized tab selection method
  void _onTabSelected(int index) {
    if (selectedTabIndex != index) {
      setState(() {
        selectedTabIndex = index;
      });
    }
  }

  // Method called when Activate Trial button is pressed
  void _onActivateTrialPressed() {
    //Todo: Navigation Screen pending
  }
}
