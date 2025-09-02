import 'package:flutter/material.dart';

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

  static const List<String> tabLabels = [
    'Stocks',
    'Futures',
    'Options',
    'Commodity'
  ];

  @override
  Widget build(BuildContext context) {
    final currentData = performanceData[selectedTabIndex]!;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFF2B2B2B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          _buildTabBar(),
          _buildPerformanceMetrics(currentData),
          _buildActivateButton(),
          _buildFooterNote(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Susmitha Performance',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'SEBI Reg.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.info_outline, color: Colors.grey[400], size: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
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
                  color:
                      selectedTabIndex == index ? Colors.orange : Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: selectedTabIndex == index
                      ? Border.all(color: Colors.white)
                      : Border.all(color: Colors.transparent),
                ),
                child: Text(
                  tabLabels[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
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

  Widget _buildPerformanceMetrics(Map<String, dynamic> data) {
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
          Text(
            'Trades Hit Accuracy: ${data['accuracy']}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
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
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildActivateButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: _onActivateTrialPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
          child: Text(
            'Activate Now',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooterNote() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            'Performance based on completed trades.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
          SizedBox(width: 8),
          Icon(Icons.info_outline, color: Colors.grey[400], size: 16),
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
  void _onActivateTrialPressed() {}
}
