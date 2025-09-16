import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:research_mantra_official/ui/common_components/common_ontap_button.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';
import 'package:research_mantra_official/ui/components/common_buttons/common_button.dart';
import 'package:research_mantra_official/ui/screens/market/screens/sharks/screens/key_changes.dart';
import 'package:research_mantra_official/ui/screens/market/screens/sharks/screens/sharks_list.dart';

// ✅ SharksScreen
class SharksScreen extends StatefulWidget {
  const SharksScreen({super.key});

  @override
  State<SharksScreen> createState() => _SharksScreenState();
}

class _SharksScreenState extends State<SharksScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _mainTabs = ["Sharks", "Key Changes"];
  final List<String> investorKeys = ['Individuals', 'Institutional', 'FIIs'];

  int _subTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _mainTabs.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _subTabIndex = 0;
        });
      }
    });
  }

// Json data for Key changes
  final Map<String, List<Map<String, dynamic>>> investorDetails = {
    "Individuals": [
      {
        "Id": 1,
        "Name": "Rohit Mehta",
        "Holdings": "22",
        "investedAmount": "41,250",
        "profileImageUrl": "https://randomuser.me/api/portraits/men/32.jpg",
        "date": "12-02-2025",
        "stockSymbol": "INFY",
        "companyName": "Infosys Ltd",
        "qtyHeld": "120",
        "qtyChange": "15",
        "currentChange": "2.5",
        "tradeType": "Bought"
      },
      {
        "Id": 2,
        "Name": "Priya Sharma",
        "Holdings": "18",
        "investedAmount": "27,880",
        "profileImageUrl": "https://randomuser.me/api/portraits/women/45.jpg",
        "date": "10-02-2025",
        "stockSymbol": "TCS",
        "companyName": "Tata Consultancy Services",
        "qtyHeld": "90",
        "qtyChange": "-10",
        "currentChange": "-1.8",
        "tradeType": "Sold"
      },
      {
        "Id": 3,
        "Name": "Ankit Verma",
        "Holdings": "12",
        "investedAmount": "16,430",
        "profileImageUrl": "https://randomuser.me/api/portraits/men/22.jpg",
        "date": "11-02-2025",
        "stockSymbol": "RELIANCE",
        "companyName": "Reliance Industries Ltd",
        "qtyHeld": "60",
        "qtyChange": "5",
        "currentChange": "3.1",
        "tradeType": "Added New"
      },
      {
        "Id": 4,
        "Name": "Neha Agarwal",
        "Holdings": "25",
        "investedAmount": "36,700",
        "profileImageUrl": "https://randomuser.me/api/portraits/women/30.jpg",
        "date": "12-02-2025",
        "stockSymbol": "HDFCBANK",
        "companyName": "HDFC Bank Ltd",
        "qtyHeld": "140",
        "qtyChange": "20",
        "currentChange": "4.0",
        "tradeType": "Bought"
      }
    ],
    "Institutional": [
      {
        "Id": 11,
        "Name": "ICICI Prudential MF",
        "Holdings": "48",
        "investedAmount": "82,400",
        "profileImageUrl": "https://logo.clearbit.com/icicipruamc.com",
        "date": "12-02-2025",
        "stockSymbol": "AXISBANK",
        "companyName": "Axis Bank Ltd",
        "qtyHeld": "500",
        "qtyChange": "-50",
        "currentChange": "-2.1",
        "tradeType": "Sold"
      },
      {
        "Id": 12,
        "Name": "SBI Mutual Fund",
        "Holdings": "65",
        "investedAmount": "1,25,700",
        "profileImageUrl": "https://logo.clearbit.com/sbi.co.in",
        "date": "11-02-2025",
        "stockSymbol": "HINDUNILVR",
        "companyName": "Hindustan Unilever Ltd",
        "qtyHeld": "750",
        "qtyChange": "30",
        "currentChange": "1.9",
        "tradeType": "Bought"
      },
      {
        "Id": 13,
        "Name": "Kotak Institutional Equities",
        "Holdings": "39",
        "investedAmount": "63,450",
        "profileImageUrl": "https://logo.clearbit.com/kotak.com",
        "date": "10-02-2025",
        "stockSymbol": "ITC",
        "companyName": "ITC Ltd",
        "qtyHeld": "420",
        "qtyChange": "15",
        "currentChange": "0.9",
        "tradeType": "Added New"
      }
    ],
    "FIIs": [
      {
        "Id": 21,
        "Name": "BlackRock Inc",
        "Holdings": "75",
        "investedAmount": "2,10,300",
        "profileImageUrl": "https://logo.clearbit.com/blackrock.com",
        "date": "12-02-2025",
        "stockSymbol": "ONGC",
        "companyName": "Oil & Natural Gas Corp",
        "qtyHeld": "1500",
        "qtyChange": "100",
        "currentChange": "2.8",
        "tradeType": "Bought"
      },
      {
        "Id": 22,
        "Name": "Goldman Sachs",
        "Holdings": "58",
        "investedAmount": "1,78,900",
        "profileImageUrl": "https://logo.clearbit.com/goldmansachs.com",
        "date": "09-02-2025",
        "stockSymbol": "ADANIPORTS",
        "companyName": "Adani Ports Ltd",
        "qtyHeld": "980",
        "qtyChange": "-70",
        "currentChange": "-3.0",
        "tradeType": "Sold"
      },
      {
        "Id": 23,
        "Name": "Morgan Stanley",
        "Holdings": "62",
        "investedAmount": "1,55,600",
        "profileImageUrl": "https://logo.clearbit.com/morganstanley.com",
        "date": "12-02-2025",
        "stockSymbol": "BHARTIARTL",
        "companyName": "Bharti Airtel Ltd",
        "qtyHeld": "1100",
        "qtyChange": "50",
        "currentChange": "1.5",
        "tradeType": "Added New"
      }
    ]
  };

//Json Data for Sharks List
  final Map<String, List<Map<String, dynamic>>> investorSharksDetails = {
    "Individuals": [
      {
        "Id": 1,
        "Name": "Rakesh Jhunjhunwala",
        "Holdings": "24",
        "investedAmount": "38,338",
        "profileImageUrl": "https://randomuser.me/api/portraits/men/32.jpg"
      },
      {
        "Id": 2,
        "Name": "Radhakishan Damani",
        "Holdings": "15",
        "investedAmount": "27,540",
        "profileImageUrl": "https://randomuser.me/api/portraits/men/45.jpg"
      },
      {
        "Id": 3,
        "Name": "Mukul Agrawal",
        "Holdings": "12",
        "investedAmount": "18,920",
        "profileImageUrl": "https://randomuser.me/api/portraits/men/22.jpg"
      },
    ],
    "Institutional": [
      {
        "Id": 11,
        "Name": "ICICI Prudential MF",
        "Holdings": "48",
        "investedAmount": "82,400",
        "profileImageUrl": "https://logo.clearbit.com/icicipruamc.com"
      },
      {
        "Id": 12,
        "Name": "SBI Mutual Fund",
        "Holdings": "65",
        "investedAmount": "1,25,700",
        "profileImageUrl": "https://logo.clearbit.com/sbi.co.in"
      },
      {
        "Id": 13,
        "Name": "Kotak Institutional Equities",
        "Holdings": "39",
        "investedAmount": "63,450",
        "profileImageUrl": "https://logo.clearbit.com/kotak.com"
      },
    ],
    "FIIs": [
      {
        "Id": 21,
        "Name": "BlackRock Inc",
        "Holdings": "75",
        "investedAmount": "2,10,300",
        "profileImageUrl": "https://logo.clearbit.com/blackrock.com"
      },
      {
        "Id": 22,
        "Name": "Goldman Sachs",
        "Holdings": "58",
        "investedAmount": "1,78,900",
        "profileImageUrl": "https://logo.clearbit.com/goldmansachs.com"
      },
      {
        "Id": 23,
        "Name": "Morgan Stanley",
        "Holdings": "62",
        "investedAmount": "1,55,600",
        "profileImageUrl": "https://logo.clearbit.com/morganstanley.com"
      },
    ],
  };

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
        appBarText: "Shark portfolios",
        handleBackButton: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          // ✅ Custom TabBar
          CustomTabBar(
            tabController: _tabController,
            tabTitles: _mainTabs,
          ),
          SizedBox(
            height: 5.h,
          ),
          CustomTabBarOnTapButton(
            borderRadius: 12,
            fontSize: 10.sp,
            isBorderEnabled: true,
            buttonTextColor: theme.primaryColor,
            buttonBackgroundColor: theme.primaryColorDark,
            tabLabels: investorKeys,
            selectedIndex: _subTabIndex,
            onTabSelected: (index) {
              setState(() {
                _subTabIndex = index;
                final selectedName = investorKeys[index];
                print("Selected Tab: $selectedName");
              });
            },
            isScrollHorizontal: false,
          ),

          // ✅ TabBarView
          // 👇 Replace TabBarView with simple conditional rendering
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // 👉 Individuals Tab Content
                SharksListScreen(
                  investorSharksDetails:
                      investorSharksDetails[investorKeys[_subTabIndex]] ?? [],
                ),

                // 👉 Institutional / FIIs Tab Content
                KeyChangesScreen(
                  investorDetails:
                      investorDetails[investorKeys[_subTabIndex]] ?? [],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
