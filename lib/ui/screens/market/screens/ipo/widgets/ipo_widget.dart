import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IpoFullDetailsWidget extends StatelessWidget {
  final Map<String, dynamic> ipoData;

  const IpoFullDetailsWidget({super.key, required this.ipoData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.cancel,
                      color: theme.primaryColorDark,
                      size: 20.w,
                    ),
                  )
                ],
              ),
              // Header Section
              _buildHeader(),
              SizedBox(height: 20.h),

              // Investment Details
              _buildInvestmentDetails(),
              SizedBox(height: 20.h),

              // Overall Subscription
              _buildOverallSubscription(),
              SizedBox(height: 20.h),

              // IPO Dates
              _buildIPODates(),
              SizedBox(height: 20.h),

              // IPO Quota Section
              _buildIPOQuota(),
              SizedBox(height: 20.h),

              // Subscription Details
              _buildSubscriptionDetails(),
              SizedBox(height: 20.h),

              // About Company
              _buildAboutCompany(),
              SizedBox(height: 20.h),

              // Issue Details & Objective
              _buildIssueDetails(),
              SizedBox(height: 20.h),

              // Financials
              _buildFinancials(),
              SizedBox(height: 20.h),

              // IPO Reservation
              _buildIPOReservation(theme),
              SizedBox(height: 20.h),
              // Expert Verdict
              _buildExpertVerdict(),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final company = ipoData['company'];
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Color(0xFF2196F3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              company['shortName'],
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                company['name'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              SizedBox(height: 4),
              Text(
                company['dates'],
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Color(0xFF4CAF50),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            company['status'],
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInvestmentDetails() {
    final investment = ipoData['investment'];
    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            'Min. Investment',
            investment['minInvestment'],
            Color(0xFF1A1A1A),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _buildInfoCard(
            'Issue Size',
            investment['issueSize'],
            Color(0xFF1A1A1A),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _buildInfoCard(
            'GMP',
            investment['growth'],
            Color(0xFF4CAF50),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(String label, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF666666),
            ),
          ),
        if (label.isNotEmpty) SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _buildOverallSubscription() {
    final subscription = ipoData['subscription'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overall subscription:${subscription['overall']}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }

  Widget _buildExpertVerdict() {
    final expertVerdict = ipoData['expertVerdict'];
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF2D2D2D),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Expert View',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xFFFF9800),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  expertVerdict['status'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'Pros',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(
              'Established expertise in aluminium goods and wires', true),
          SizedBox(height: 4),
          _buildBulletPoint('Strategic plant location in Kadi, Gujarat', true),
          SizedBox(height: 12),
          Text(
            'Cons',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(
              'Limited product portfolio reduces diversification opportunities',
              false),
          SizedBox(height: 4),
          _buildBulletPoint(
              'Dependence on aluminum prices affects profitability', false),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text, bool isPositive) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 6, right: 8),
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: isPositive ? Color(0xFF4CAF50) : Color(0xFFFF5722),
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIPODates() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Color(0xFFFF5722),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.calendar_today,
                color: Colors.white,
                size: 12,
              ),
            ),
            SizedBox(width: 8),
            Text(
              'IPO dates',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        _buildTimeline(),
        SizedBox(height: 12),
        Center(
          child: Text(
            '*Returns will be credited on 23 Sep 25',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF666666),
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeline() {
    return Row(
      children: [
        _buildTimelineItem('17 Sep', 'Opening', true, false),
        _buildTimelineConnector(true),
        _buildTimelineItem('18 Sep', 'Closing', true, false),
        _buildTimelineConnector(false),
        _buildTimelineItem('22 Sep', 'Allotment', false, false),
        _buildTimelineConnector(false),
        _buildTimelineItem('24 Sep', 'Listing', false, true),
      ],
    );
  }

  Widget _buildTimelineItem(
      String date, String label, bool isCompleted, bool isLast) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: isCompleted ? Color(0xFF4CAF50) : Color(0xFFE0E0E0),
              shape: BoxShape.circle,
              border: Border.all(
                color: isCompleted ? Color(0xFF4CAF50) : Color(0xFFBDBDBD),
                width: 2,
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            date,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineConnector(bool isActive) {
    return Container(
      height: 2,
      width: 30,
      margin: EdgeInsets.only(bottom: 32),
      color: isActive ? Color(0xFF4CAF50) : Color(0xFFE0E0E0),
    );
  }

  Widget _buildIPOQuota() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.account_balance_wallet,
                color: Color(0xFFFF9800), size: 20),
            SizedBox(width: 8),
            Text(
              'IPO quota',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFFE0E0E0)),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Color(0xFF2196F3),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('Application',
                          style: _whiteHeaderStyle(),
                          textAlign: TextAlign.center),
                    ),
                    Expanded(
                      child: Text('Lots',
                          style: _whiteHeaderStyle(),
                          textAlign: TextAlign.center),
                    ),
                    Expanded(
                      child: Text('Shares',
                          style: _whiteHeaderStyle(),
                          textAlign: TextAlign.center),
                    ),
                    Expanded(
                      child: Text('Amount',
                          style: _whiteHeaderStyle(),
                          textAlign: TextAlign.center),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('Retail (Min)',
                          style: _tableContentStyle(),
                          textAlign: TextAlign.center),
                    ),
                    Expanded(
                      child: Text('2',
                          style: _tableContentStyle(),
                          textAlign: TextAlign.center),
                    ),
                    Expanded(
                      child: Text('2400',
                          style: _tableContentStyle(),
                          textAlign: TextAlign.center),
                    ),
                    Expanded(
                      child: Text('₹2,88,000',
                          style: _tableContentStyle(),
                          textAlign: TextAlign.center),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubscriptionDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2196F3), Color(0xFF03DAC6)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(width: 8),
            Text(
              'Subscription',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
            Spacer(),
            Text(
              '(as on 19 September 2025, 02:30 PM)',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF666666),
              ),
            ),
            SizedBox(width: 4),
            Icon(Icons.info_outline, size: 16, color: Color(0xFF666666)),
          ],
        ),
        SizedBox(height: 16),
        _buildSubscriptionCard('Overall', '56.51x', Color(0xFF2196F3)),
        SizedBox(height: 12),
        _buildSubscriptionCard(
            'Qualified institutional buyers', '21.7x', Color(0xFF666666)),
        SizedBox(height: 12),
        _buildSubscriptionCard(
            'Non-institutional buyers', '70.19x', Color(0xFF666666)),
        SizedBox(height: 12),
        _buildSubscriptionCard('Retail investors', '67.73x', Color(0xFF666666)),
      ],
    );
  }

  Widget _buildSubscriptionCard(
      String title, String value, Color backgroundColor) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor == Color(0xFF2196F3)
            ? Color(0xFF2196F3)
            : Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          if (backgroundColor != Color(0xFF2196F3))
            Icon(Icons.people, color: Color(0xFF666666), size: 20),
          if (backgroundColor != Color(0xFF2196F3)) SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: backgroundColor == Color(0xFF2196F3)
                    ? Colors.white
                    : Color(0xFF1A1A1A),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: backgroundColor == Color(0xFF2196F3)
                  ? Colors.white
                  : Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutCompany() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Color(0xFF2196F3),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.business, color: Colors.white, size: 14),
            ),
            SizedBox(width: 8),
            Text(
              'About Company',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFFE0E0E0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Founded: ',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF666666)),
                  ),
                  Text(
                    '1999',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A)),
                  ),
                  Spacer(),
                  Text(
                    'MD: ',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF666666)),
                  ),
                  Text(
                    'Mr Sanket San...',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A)),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                '• Sampat Aluminium is engaged in the manufacturing of aluminium long products, including aluminium wires and rods. The company primarily uses aluminium ingots, rods, wires, and recycled aluminium scrap for its operations, with production carried out through the Properzi process.',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF1A1A1A),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIssueDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xFFFF5722), Color(0xFFFF9800)]),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.assignment, color: Colors.white, size: 14),
            ),
            SizedBox(width: 8),
            Text(
              'Issue details & objective',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Color(0xFF2D2D2D),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'FRESH',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFFE0E0E0)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text('Lot Size',
                        style:
                            TextStyle(fontSize: 12, color: Color(0xFF666666))),
                    SizedBox(height: 8),
                    Text('1200 Shares',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A))),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text('Price band',
                        style:
                            TextStyle(fontSize: 12, color: Color(0xFF666666))),
                    SizedBox(height: 8),
                    Text('₹114 - ₹120',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A))),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text('Face value',
                        style:
                            TextStyle(fontSize: 12, color: Color(0xFF666666))),
                    SizedBox(height: 8),
                    Text('₹10 per share',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFinancials() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xFFFF9800), Color(0xFFFFEB3B)]),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(Icons.bar_chart, color: Colors.white, size: 14),
            ),
            SizedBox(width: 8),
            Text(
              'Financials',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            _buildFinancialTab('Revenue', true),
            SizedBox(width: 12),
            _buildFinancialTab('Profit', false),
            SizedBox(width: 12),
            _buildFinancialTab('Total Asset', false),
          ],
        ),
        SizedBox(height: 16),
        Container(
          width: double.infinity,
          height: 200,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFFE0E0E0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Revenue',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF666666))),
                  Text('Value in Cr',
                      style: TextStyle(fontSize: 12, color: Color(0xFF999999))),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildBarChart('129.22', '2023', 0.88),
                    _buildBarChart('147.01', '2024', 1.0),
                    _buildBarChart('132.72', '2025', 0.90),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFinancialTab(String title, bool isActive) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? Color(0xFF2196F3) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border:
            Border.all(color: isActive ? Color(0xFF2196F3) : Color(0xFFE0E0E0)),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          color: isActive ? Colors.white : Color(0xFF666666),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildBarChart(String value, String year, double heightFactor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        SizedBox(height: 8),
        Container(
          width: 40,
          height: 60 * heightFactor,
          decoration: BoxDecoration(
            color: Color(0xFF2196F3),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(height: 8),
        Text(
          year,
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF666666),
          ),
        ),
      ],
    );
  }

  Widget _buildIPOReservation(ThemeData theme) {
    final List<Map<String, dynamic>> reservations = [
      {"label": "Anchor Investor", "percent": 21.80, "color": Colors.red},
      {"label": "QIB", "percent": 36.41, "color": Colors.blue},
      {"label": "HNI", "percent": 10.96, "color": Colors.green},
      {"label": "Retail", "percent": 25.67, "color": Colors.purple},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'IPO Reservation',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Color(0xFFE0E0E0)),
          ),
          child: Column(
            children: reservations.map((res) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: res['color'],
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              res['label'],
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "${res['percent']}%",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: res['color'],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: (res['percent'] as double) / 100,
                      minHeight: 8,
                      backgroundColor: Colors.grey[300],
                      color: res['color'],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  TextStyle _whiteHeaderStyle() {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
  }

  TextStyle _tableContentStyle() {
    return TextStyle(
      fontSize: 12,
      color: Color(0xFF1A1A1A),
    );
  }
}
