import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:research_mantra_official/ui/common_components/common_outline_button.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';

class SharksStocksDetails extends StatefulWidget {
  final String name;
  const SharksStocksDetails({super.key, required this.name});

  @override
  State<SharksStocksDetails> createState() => _SharksStocksDetailsState();
}

class _SharksStocksDetailsState extends State<SharksStocksDetails>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Sample JSON-like data structure
  final Map<String, dynamic> portfolioData = {
    'investor': {
      'name': 'Rakesh Jhunjhunwala & Assoc.',
      'networth': 37991,
      'holdings': 24,
      'currency': '₹',
      'avatar': 'assets/investor_avatar.png'
    },
    'sectors': [
      {'name': 'Bank', 'percentage': 35, 'color': Color(0xFF1565C0)},
      {'name': 'Infrastruct...', 'percentage': 13, 'color': Color(0xFF4FC3F7)},
      {'name': 'Automobil...', 'percentage': 10, 'color': Color(0xFFFFB74D)},
      {'name': 'Diamond ...', 'percentage': 7, 'color': Color(0xFFFF8A65)},
      {'name': 'Healthcare', 'percentage': 7, 'color': Color(0xFFEF5350)},
      {'name': 'Others', 'percentage': 25, 'color': Color(0xFFBDBDBD)},
    ],
    "changes": [
      {
        "date": "2025-09-01",
        "investorName": "HDFC Mutual Fund",
        "investorDetails": "Top 10 Investors",
        "imageUrl":
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQmyKNYeA69wBdFuHZcsqwfjoMaBA-ln709uumi0VerDWfOsgWcFcWaBdx3qinBLEMqxRg&usqp=CAU",
        "action": "Bought",
        "qtyHeld": "₹250 Cr",
        "currentHoldingPercent": "5.5%",
        "qtyChangePercent": "+1.2%"
      },
      {
        "date": "2025-09-05",
        "investorName": "LIC of India",
        "investorDetails": "Insurance Giant",
        "imageUrl": "https://cdn-icons-png.flaticon.com/512/149/149071.png",
        "action": "Sold",
        "qtyHeld": "₹120 Cr",
        "currentHoldingPercent": "2.1%",
        "qtyChangePercent": "-0.8%"
      },
      {
        "date": "2025-09-10",
        "investorName": "SBI Mutual Fund",
        "investorDetails": "Long Term Investor",
        "imageUrl": "https://cdn-icons-png.flaticon.com/512/3135/3135715.png",
        "action": "Bought",
        "qtyHeld": "₹800 Cr",
        "currentHoldingPercent": "12.3%",
        "qtyChangePercent": "+3.0%"
      }
    ],
    'holdings': [
      {
        'symbol': 'STYLEBAAZA',
        'name': 'Baazar Style Retail Ltd.',
        'holding': 3.3,
        'value': 93,
        'returns': {'6M': 57.87, '1Y': 1.89, '5Y': null}
      },
      {
        'symbol': 'GEOJITFSL',
        'name': 'Geojit Financial Serv...',
        'holding': 7.2,
        'value': 155,
        'returns': {'6M': 3.16, '1Y': -49.46, '5Y': 116.36}
      },
      {
        'symbol': 'TITAN',
        'name': 'Titan Company Ltd.',
        'holding': 5.1,
        'value': 15878,
        'returns': {'6M': 9.63, '1Y': -9.24, '5Y': 183.40}
      },
      {
        'symbol': 'SINGER',
        'name': 'Singer India Ltd.',
        'holding': 6.8,
        'value': 39,
        'returns': {'6M': 57.84, '1Y': 0.32, '5Y': 220.25}
      },
      {
        'symbol': 'WABAG',
        'name': 'VA Tech Wabag Ltd.',
        'holding': 8.0,
        'value': 784,
        'returns': {'6M': 3.55, '1Y': 5.26, '5Y': 730.20}
      },
      {
        'symbol': 'DBREALTY',
        'name': 'Valor Estate Ltd.',
        'holding': 4.6,
        'value': 438,
        'returns': {'6M': 15.67, '1Y': -11.34, '5Y': 2661.73}
      },
      {
        'symbol': 'JUBLPHARMA',
        'name': 'Jubilant Pharmova Ltd.',
        'holding': 6.4,
        'value': 1127,
        'returns': {'6M': 21.86, '1Y': -9.82, '5Y': 54.94}
      },
      {
        'symbol': 'JUBLINGREA',
        'name': 'Jubilant Ingrevia Ltd.',
        'holding': 2.9,
        'value': 319,
        'returns': {'6M': -2.76, '1Y': -10.97, '5Y': null}
      },
      {
        'symbol': 'INDHOTEL',
        'name': 'The Indian Hotels Com...',
        'holding': 2.0,
        'value': 2234,
        'returns': {'6M': -5.96, '1Y': 8.50, '5Y': 733.13}
      },
      {
        'symbol': 'TATAMOTORS',
        'name': 'Tata Motors Ltd.',
        'holding': 1.3,
        'value': 3380,
        'returns': {'6M': 0.64, '1Y': -27.20, '5Y': 441.28}
      },
      {
        'symbol': 'TATACOMM',
        'name': 'Tata Communications Ltd.',
        'holding': 1.5,
        'value': 758,
        'returns': {'6M': 4.62, '1Y': -16.11, '5Y': 95.96}
      },
      {
        'symbol': 'FEDERALBNK',
        'name': 'The Federal Bank Ltd.',
        'holding': 1.4,
        'value': 713,
        'returns': {'6M': 5.67, '1Y': 5.47, '5Y': 274.14}
      },
      {
        'symbol': 'SUNDROP',
        'name': 'Agro Tech Foods Ltd.',
        'holding': 4.9,
        'value': 154,
        'returns': {'6M': 1.76, '1Y': 1.68, '5Y': 16.41}
      },
      {
        'symbol': 'KARURVYSYA',
        'name': 'Karur Vysya Bank Ltd.',
        'holding': 4.1,
        'value': 727,
        'returns': {'6M': 3.56, '1Y': -1.22, '5Y': 625.14}
      },
      {
        'symbol': 'CRISIL',
        'name': 'Crisil Ltd.',
        'holding': 5.1,
        'value': 1894,
        'returns': {'6M': 17.76, '1Y': 2.56, '5Y': 185.51}
      },
    ]
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: CommonAppBarWithBackButton(
        appBarText: "Shark Investor Stocks",
        handleBackButton: () => Navigator.pop(context),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildInvestorHeader(theme),
                _buildSectorChart(theme),
                SizedBox(height: 10.h),
                _buildLastChangesAll(theme),
                SizedBox(height: 10.h),
                _buildTabBar(theme),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildHoldingsTab(theme),
            _buildPerformanceTab(theme),
          ],
        ),
      ),
    );
  }

//Widget for Invsestor Header
  Widget _buildInvestorHeader(ThemeData theme) {
    final investor = portfolioData['investor'] as Map<String, dynamic>;

    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          SizedBox(
            width: 45.w,
            height: 45.h,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CachedNetworkImage(
                  imageUrl:
                      "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ea/Shri_Rakesh_Radheyshyam_Jhunjhunwala.jpg/250px-Shri_Rakesh_Radheyshyam_Jhunjhunwala.jpg"),
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            widget.name,
            style: theme.textTheme.titleSmall
                ?.copyWith(color: theme.primaryColorDark),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.shadowColor, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatColumn('Networth (in Cr)',
                    '${investor['currency']} ${investor['networth']}', theme),
                _buildStatColumn('Holdings', '${investor['holdings']}', theme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, ThemeData theme) {
    return Column(
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.focusColor,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.indicatorColor,
          ),
        ),
      ],
    );
  }

//Widget For Top Sectors
  Widget _buildSectorChart(ThemeData theme) {
    final sectors = portfolioData['sectors'] as List<Map<String, dynamic>>;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Top sector holdings',
              style: theme.textTheme.titleMedium
                  ?.copyWith(color: theme.primaryColorDark)),
          SizedBox(height: 10.h),
          Container(
            height: 22.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
            ),
            clipBehavior:
                Clip.hardEdge, // 👈 this makes children respect radius
            child: Row(
              children: sectors.map((sector) {
                return Expanded(
                  flex: sector['percentage'] as int,
                  child: Container(
                    color: sector['color'] as Color,
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 15.h),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: sectors.map((sector) {
              return _buildSectorLegend(
                sector['name'] as String,
                sector['percentage'] as int,
                sector['color'] as Color,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectorLegend(String name, int percentage, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 6),
        Text(
          '$name ($percentage%)',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

//Widget for Changes in Last 30 Days
  Widget _buildLastChangesAll(
    ThemeData theme,
  ) {
    return Container(
      color: theme.shadowColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 5.h,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text('Changes in last 30 days',
                style: theme.textTheme.titleMedium
                    ?.copyWith(color: theme.primaryColorDark)),
          ),
          SizedBox(
            height: 150.h,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: portfolioData['changes'].length,
                itemBuilder: (context, index) {
                  final item = portfolioData['changes'][index];

                  return _buildLastChanges(theme, item);
                }),
          ),
        ],
      ),
    );
  }

  Widget _buildLastChanges(ThemeData theme, dynamic item) {
    return Container(
      width: 300.w,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: theme.primaryColor,
          border: Border.all(color: theme.shadowColor)),
      child: Column(
        children: [
          SizedBox(
            height: 5.h,
          ),
          Row(
            children: [
              Text(
                item['date'],
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.primaryColorDark, fontSize: 10.sp),
              ),
            ],
          ),
          SizedBox(
            height: 5.h,
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 35.w,
                    height: 35.h,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CachedNetworkImage(imageUrl: item['imageUrl']),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['investorName'],
                        style: theme.textTheme.titleSmall?.copyWith(
                            color: theme.primaryColorDark, fontSize: 10.sp),
                      ),
                      Text(
                        item['investorDetails'],
                        style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.primaryColorDark, fontSize: 10.sp),
                      )
                    ],
                  ),
                ],
              ),
              CommonOutlineButton(
                textStyle:
                    TextStyle(fontSize: 10.sp, color: theme.primaryColor),
                borderColor: Colors.transparent,
                borderRadius: 4.0,
                backgroundColor: theme.secondaryHeaderColor,
                text: item['action'],
              ),
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
                        color: theme.primaryColorDark, fontSize: 10.sp),
                  ),
                  Text(
                    item['qtyHeld'],
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
                        color: theme.primaryColorDark, fontSize: 10.sp),
                  ),
                  Text(
                    item['currentHoldingPercent'],
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
                        color: theme.primaryColorDark, fontSize: 10.sp),
                  ),
                  Text(
                    item['qtyChangePercent'],
                    style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.primaryColorDark, fontSize: 10.sp),
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTabBar(ThemeData theme) {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        tabs: [
          Tab(text: 'Holdings'),
          Tab(text: 'Performance'),
        ],
        labelColor: Colors.blue,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Colors.blue,
      ),
    );
  }

  Widget _buildHoldingsTab(ThemeData theme) {
    final holdings = portfolioData['holdings'] as List<Map<String, dynamic>>;

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _buildTableHeader(),
          Expanded(
            child: ListView.builder(
              itemCount: holdings.length,
              itemBuilder: (context, index) {
                return _buildHoldingRow(holdings[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Expanded(
              flex: 4, child: Text('Stock name', style: _headerTextStyle())),
          Expanded(flex: 1, child: Text('%', style: _headerTextStyle())),
          Expanded(flex: 2, child: Text('Value', style: _headerTextStyle())),
          Expanded(flex: 1, child: Text('Chg', style: _headerTextStyle())),
        ],
      ),
    );
  }

  TextStyle _headerTextStyle() {
    return TextStyle(
      fontSize: 12,
      color: Colors.grey[600],
      fontWeight: FontWeight.w500,
    );
  }

  Widget _buildHoldingRow(Map<String, dynamic> holding) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  holding['symbol'],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  holding['name'],
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              holding['holding'].toString(),
              style: TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '₹${holding['value']} Cr',
              style: TextStyle(
                fontSize: 12,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '3.3',
              style: TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceTab(ThemeData theme) {
    final holdings = portfolioData['holdings'] as List<Map<String, dynamic>>;

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _buildPerformanceHeader(),
          Expanded(
            child: ListView.builder(
              itemCount: holdings.length,
              itemBuilder: (context, index) {
                return _buildPerformanceRow(holdings[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Expanded(
              flex: 4, child: Text('Stock name', style: _headerTextStyle())),
          Expanded(flex: 2, child: Text('6M (%)', style: _headerTextStyle())),
          Expanded(flex: 2, child: Text('1Y (%)', style: _headerTextStyle())),
          Expanded(flex: 2, child: Text('5Y (%)', style: _headerTextStyle())),
        ],
      ),
    );
  }

  Widget _buildPerformanceRow(Map<String, dynamic> holding) {
    final returns = holding['returns'] as Map<String, dynamic>;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  holding['symbol'],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  holding['name'],
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: _buildReturnText(returns['6M']),
          ),
          Expanded(
            flex: 2,
            child: _buildReturnText(returns['1Y']),
          ),
          Expanded(
            flex: 2,
            child: _buildReturnText(returns['5Y']),
          ),
        ],
      ),
    );
  }

  Widget _buildReturnText(dynamic value) {
    if (value == null) {
      return Text(
        '-',
        style: TextStyle(fontSize: 12, color: Colors.grey),
      );
    }

    final doubleValue = value as double;
    final isPositive = doubleValue >= 0;

    return Text(
      doubleValue.toStringAsFixed(2),
      style: TextStyle(
        fontSize: 12,
        color: isPositive ? Colors.green : Colors.red,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
