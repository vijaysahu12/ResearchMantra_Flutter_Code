import 'package:flutter/material.dart';
import 'package:research_mantra_official/data/models/calculater/caliculate_future_model.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';
import 'package:research_mantra_official/ui/components/button.dart';

class GenerateWealthScreen extends StatelessWidget {
  final int currentAge;
  final double inflationRate;
  final String currentMonthlyExpense;
  final String futureMonthlyExpenseAtAgeOf60;
  final String capitalNeededAt60;
  final String anyCurrentInvestment;
  final InvestmentPlans investmentPlans;
  final String? summaryLabel1;
  final String? summaryLabel2;
  final bool allowPdf;
  const GenerateWealthScreen(
      {super.key,
      required this.currentAge,
      required this.inflationRate,
      required this.currentMonthlyExpense,
      required this.futureMonthlyExpenseAtAgeOf60,
      required this.capitalNeededAt60,
      required this.anyCurrentInvestment,
      required this.investmentPlans,
      this.summaryLabel1,
      this.summaryLabel2,
      required this.allowPdf});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        backgroundColor: theme.primaryColor,
        appBar: CommonAppBarWithBackButton(
          appBarText: "Generate Wealth",
          handleBackButton: () {
            Navigator.pop(context);
          },
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gradient Container with Message
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 165, 61, 61),
                        Color.fromARGB(255, 176, 39, 39),
                        Color.fromARGB(255, 23, 26, 29)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    summaryLabel1 ??
                        "To achieve your goal, you have to invest amount from today onwards",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 24),

                // Information Rows
                _buildInfoRow("Current Age", "$currentAge Years"),
                _buildInfoRow("Retirement Age", "60 Years"),
                _buildInfoRow(
                    "Current Monthly Expenses", "₹$currentMonthlyExpense"),

                _buildInfoRow(
                    "SIP Amount", "₹${investmentPlans.monthlySipAmount}month"),
                _buildInfoRow(
                    "Currently Invested Amount", "₹$anyCurrentInvestment"),
                _buildInfoRow("Inflation Rate ",
                    "${(inflationRate * 100).toStringAsFixed(2)} %"),

                _buildInfoRow("Capital Need At 60", "₹$capitalNeededAt60"),
                _buildInfoRow("Future Monthly Expenses",
                    "₹$futureMonthlyExpenseAtAgeOf60"),

                const SizedBox(height: 24),

                // Table Heading
                Text(
                  summaryLabel2 ?? "Projected Wealth Growth (Every 3 Years)",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                // Wealth Projection Table
                _buildWealthTable(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: allowPdf
            ? Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: Button(
                        text: "Get Pdf",
                        onPressed: () {
                          // Add navigation to next screen here
                          // You can pass currentAge, monthlyExpense values
                        },
                        backgroundColor: theme.indicatorColor,
                        textColor:
                            theme.floatingActionButtonTheme.foregroundColor,
                      ),
                    )
                  ],
                ),
              )
            : null);
  }

  // Common method to build information rows
  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Method to create a table
  Widget _buildWealthTable() {
    // Sample data - Years and projected corpus (Assume 12% CAGR growth)

    return Table(
      border: TableBorder.all(color: Colors.grey),
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(2),
      },
      children: [
        // Table Header
        const TableRow(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromARGB(255, 165, 61, 61),
                Color.fromARGB(255, 176, 39, 39),
                Color.fromARGB(255, 23, 26, 29)
              ]),
              color: Colors.blueAccent),
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Year",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Retirement Corpus",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
            ),
          ],
        ),
        // Table Rows
        ...investmentPlans.projectedGrowths.map(
          (data) => TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(data.year.toString(), textAlign: TextAlign.center),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    Text(data.amount.toString(), textAlign: TextAlign.center),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
