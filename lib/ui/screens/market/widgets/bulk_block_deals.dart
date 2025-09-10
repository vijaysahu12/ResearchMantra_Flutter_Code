import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:research_mantra_official/ui/common_components/common_ontap_button.dart';

class DealsScreen extends StatefulWidget {
  const DealsScreen({super.key});

  @override
  State<DealsScreen> createState() => _DealsScreenState();
}

class _DealsScreenState extends State<DealsScreen> {
  String selectedFilter = "All";

  // ✅ Sample deals data
  final List<Map<String, dynamic>> deals = [
    {
      "symbol": "TCS",
      "date": "10-Sep-2025",
      "company": "Tata Consultancy Services",
      "type": "Bulk",
      "holder": "Seshi",
      "quantity": "5.2L NSE",
      "price": 2486.50
    },
    {
      "symbol": "INFY",
      "date": "10-Sep-2025",
      "company": "Infosys Ltd",
      "type": "Block",
      "holder": "Ramesh",
      "quantity": "3.8L BSE",
      "price": 1560.30
    },
    {
      "symbol": "HDFC",
      "date": "09-Sep-2025",
      "company": "HDFC Bank",
      "type": "Bulk",
      "holder": "Mohan",
      "quantity": "6.1L NSE",
      "price": 1650.00
    },
    {
      "symbol": "RELIANCE",
      "date": "09-Sep-2025",
      "company": "Reliance Industries",
      "type": "Block",
      "holder": "Anil",
      "quantity": "4.5L NSE",
      "price": 2420.40
    },
    {
      "symbol": "ITC",
      "date": "08-Sep-2025",
      "company": "ITC Ltd",
      "type": "Bulk",
      "holder": "Kiran",
      "quantity": "2.7L BSE",
      "price": 456.70
    },
  ];

  // ✅ Filter deals
  List<Map<String, dynamic>> get filteredDeals {
    if (selectedFilter == "All") return deals;
    return deals.where((d) => d["type"] == selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Heading
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Bulk/Block Deals",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),

          // 🔹 Filter buttons
          CustomTabBarOnTapButton(
            borderRadius: 12,
            fontSize: 10.sp,
            isBorderEnabled: true,
            buttonTextColor: theme.primaryColor,
            buttonBackgroundColor: theme.primaryColorDark,
            tabLabels: ["All", "Block", "Bulk"],
            selectedIndex: ["All", "Block", "Bulk"].indexOf(selectedFilter),
            onTabSelected: (index) {
              setState(() {
                selectedFilter =
                    ["All", "Block", "Bulk"][index]; // ✅ update state
              });
            },
          ),

          const SizedBox(height: 8),

          // 🔹 Deals List (Horizontal scroll)
          SizedBox(
            height: 130.sp,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: filteredDeals.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final deal = filteredDeals[index];
                return _buildDealCard(deal, context, theme);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Card widget
  Widget _buildDealCard(
      Map<String, dynamic> deal, BuildContext context, ThemeData theme) {
    return Container(
      width: 280.sp,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: theme.primaryColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.shadowColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stock Symbol + Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                deal["symbol"],
                style: theme.textTheme.titleSmall
                    ?.copyWith(color: theme.primaryColorDark, fontSize: 13.sp),
              ),
              Text(
                deal["date"],
                style: theme.textTheme.titleSmall
                    ?.copyWith(color: theme.focusColor, fontSize: 12.sp),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Company Name + Type
          Text(
            deal["company"],
            style: theme.textTheme.headlineSmall
                ?.copyWith(color: theme.primaryColorDark, fontSize: 12.sp),
          ),
          Text(
            "Type: ${deal["type"]}",
            style: theme.textTheme.headlineMedium
                ?.copyWith(color: theme.focusColor, fontSize: 10.sp),
          ),
          const SizedBox(height: 6),

          // Holder
          Text(
            "Holder: ${deal["holder"]}",
            style: theme.textTheme.headlineMedium
                ?.copyWith(color: theme.focusColor, fontSize: 10.sp),
          ),
          const Spacer(),

          // Quantity + Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                deal["quantity"],
                style: theme.textTheme.headlineMedium
                    ?.copyWith(color: theme.focusColor, fontSize: 10.sp),
              ),
              Text(
                "₹${deal["price"].toStringAsFixed(2)}",
                style: theme.textTheme.headlineMedium
                    ?.copyWith(color: theme.focusColor, fontSize: 10.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
