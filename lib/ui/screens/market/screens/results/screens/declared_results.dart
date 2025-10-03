import 'package:flutter/material.dart';

class DeclaredResultScreen extends StatefulWidget {
  const DeclaredResultScreen({super.key});

  @override
  State<DeclaredResultScreen> createState() => _DeclaredResultScreenState();
}

class _DeclaredResultScreenState extends State<DeclaredResultScreen> {
  final List<Map<String, dynamic>> results = [
    {
      "date": "2024-09-04",
      "stocks": [
        {
          "stockSymbol": "GSPL",
          "companyName": "Gujarat State Petro",
          "price": 313.20,
          "priceChange": -1.15,
          "priceChangePercent": -0.37,
          "financials": {
            "unit": "Rs Cr",
            "periods": ["Jun'24", "Jun'25", "YoY (%)"],
            "metrics": [
              {
                "label": "Revenue",
                "values": [4301.43, 4891.54, -12.06]
              },
              {
                "label": "Op Profit",
                "values": [822.88, 906.25, -9.20]
              },
              {
                "label": "Op Margin",
                "values": [19.13, 18.53, 3.26]
              },
              {
                "label": "Yoy",
                "values": [314.68, 374.97, -16.08]
              }
            ]
          }
        },
        {
          "stockSymbol": "TCS",
          "companyName": "Tata Consultancy Services",
          "price": 3450.50,
          "priceChange": 12.75,
          "priceChangePercent": 0.37,
          "financials": {
            "unit": "Rs Cr",
            "periods": ["Jun'24", "Jun'25", "YoY (%)"],
            "metrics": [
              {
                "label": "Revenue",
                "values": [4301.43, 4891.54, -12.06]
              },
              {
                "label": "Op Profit",
                "values": [822.88, 906.25, -9.20]
              },
              {
                "label": "Op Margin",
                "values": [19.13, 18.53, 3.26]
              },
              {
                "label": "Yoy",
                "values": [314.68, 374.97, -16.08]
              }
            ]
          }
        },
        {
          "stockSymbol": "INFY",
          "companyName": "Infosys Ltd",
          "price": 1795.30,
          "priceChange": -8.40,
          "priceChangePercent": -0.46,
          "financials": {
            "unit": "Rs Cr",
            "periods": ["Jun'24", "Jun'25", "YoY (%)"],
            "metrics": [
              {
                "label": "Revenue",
                "values": [4301.43, 4891.54, -12.06]
              },
              {
                "label": "Op Profit",
                "values": [822.88, 906.25, -9.20]
              },
              {
                "label": "Op Margin",
                "values": [19.13, 18.53, 3.26]
              },
              {
                "label": "Yoy",
                "values": [314.68, 374.97, -16.08]
              }
            ]
          }
        }
      ]
    },
    {
      "date": "2024-10-04",
      "stocks": [
        {
          "stockSymbol": "GSPL",
          "companyName": "Gujarat State Petro",
          "price": 313.20,
          "priceChange": -1.15,
          "priceChangePercent": -0.37,
          "financials": {
            "unit": "Rs Cr",
            "periods": ["Jun'24", "Jun'25", "YoY (%)"],
            "metrics": [
              {
                "label": "Revenue",
                "values": [4301.43, 4891.54, -12.06]
              },
              {
                "label": "Operating Profit",
                "values": [822.88, 906.25, -9.20]
              },
              {
                "label": "Operating Margin",
                "values": [19.13, 18.53, 3.26]
              },
              {
                "label": "Net Profit",
                "values": [314.68, 374.97, -16.08]
              }
            ]
          }
        }
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: results.length,
        itemBuilder: (context, index) {
          final dateGroup = results[index];
          final date = dateGroup["date"];
          final stocks = dateGroup["stocks"] as List<dynamic>;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date Header
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  date,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.focusColor,
                  ),
                ),
              ),
              // Stocks List
              ...stocks.map((stock) => StockCard(stock: stock)).toList(),
            ],
          );
        },
      ),
    );
  }
}

// ------------------ Stock Card Widget ------------------
class StockCard extends StatelessWidget {
  final Map<String, dynamic> stock;
  const StockCard({super.key, required this.stock});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final financials = stock["financials"];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.primaryColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.shadowColor, width: 0.8),
      ),
      child: Column(
        children: [
          // Stock Info Row
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: theme.shadowColor,
                child: Text(
                  stock["stockSymbol"][0],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stock["stockSymbol"],
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.primaryColorDark,
                      ),
                    ),
                    Text(
                      stock["companyName"],
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.focusColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    stock["price"].toString(),
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.primaryColorDark,
                    ),
                  ),
                  Text(
                    "${stock["priceChange"]} (${stock["priceChangePercent"]})",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: (stock["priceChange"] as double) >= 0
                          ? theme.secondaryHeaderColor
                          : theme.disabledColor,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),
          // Financial Table
          FinancialTable(financials: financials),
        ],
      ),
    );
  }
}

// ------------------ Financial Table Widget ------------------
class FinancialTable extends StatelessWidget {
  final Map<String, dynamic> financials;
  const FinancialTable({super.key, required this.financials});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final periods = financials["periods"] as List<dynamic>;
    final metrics = financials["metrics"] as List<dynamic>;

    // Table Header
    Widget headerRow() {
      return Container(
        decoration: BoxDecoration(
          color: theme.shadowColor,
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child: Center(
                    child: Text("Metric", style: tableHeaderStyle(theme)))),
            ...periods.map((p) => Expanded(
                flex: p == "YoY (%)" ? 1 : 2,
                child: Center(child: Text(p, style: tableHeaderStyle(theme))))),
          ],
        ),
      );
    }

    // Table Rows
    List<Widget> dataRows() {
      return metrics.map((metric) {
        final values = metric["values"] as List<dynamic>;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              Expanded(
                  flex: 2,
                  child: Text(metric["label"], style: tableValueStyle(theme))),
              ...values.map((v) {
                final isYoY = v == values.last;
                return Expanded(
                  flex: isYoY ? 1 : 2,
                  child: Center(
                    child: Text(
                      v.toString(),
                      style: isYoY
                          ? tableValueStyle(theme).copyWith(
                              color: (v as double) >= 0
                                  ? theme.secondaryHeaderColor
                                  : theme.disabledColor,
                            )
                          : tableValueStyle(theme),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      }).toList();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        headerRow(),
        const SizedBox(height: 4),
        ...dataRows(),
      ],
    );
  }

  TextStyle tableHeaderStyle(ThemeData theme) =>
      theme.textTheme.titleSmall!.copyWith(
          color: theme.focusColor, fontWeight: FontWeight.bold, fontSize: 10);

  TextStyle tableValueStyle(ThemeData theme) => theme.textTheme.bodySmall!
      .copyWith(color: theme.focusColor, fontSize: 10);
}
