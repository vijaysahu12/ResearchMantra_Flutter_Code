import 'package:flutter/material.dart';

class UpcomingResults extends StatefulWidget {
  const UpcomingResults({super.key});

  @override
  State<UpcomingResults> createState() => _UpcomingResultsState();
}

class _UpcomingResultsState extends State<UpcomingResults> {
  final List<Map<String, dynamic>> results = [
    {
      "date": "22 Sep",
      "stocks": [
        {
          "symbol": "V",
          "stockSymbol": "VIKRAN",
          "companyName": "VIKRAN ENGINEERING LTD",
          "cmp": "₹111.20",
          "changeInPrice": "-3.68",
          "changeInPercentage": "-3.20%",
          "isPositive": false,
        },
        {
          "symbol": "E",
          "stockSymbol": "EROSMEDIA-BZ",
          "companyName": "Eros International Media",
          "cmp": "₹7.89",
          "changeInPrice": "+0.37",
          "changeInPercentage": "+4.92%",
          "isPositive": true,
        },
      ]
    },
    {
      "date": "23 Sep",
      "stocks": [
        {
          "symbol": "S",
          "stockSymbol": "SUDARSCHEM",
          "companyName": "Sudarshan Chemical Industries",
          "cmp": "₹1,515.10",
          "changeInPrice": "+40.70",
          "changeInPercentage": "+2.76%",
          "isPositive": true,
        }
      ]
    },
    {
      "date": "25 Sep",
      "stocks": [
        {
          "symbol": "C",
          "stockSymbol": "CEDAAR-SM",
          "companyName": "CEDAAR TEXTILE LIMITED",
          "cmp": "₹103.00",
          "changeInPrice": "-1.20",
          "changeInPercentage": "-1.15%",
          "isPositive": false,
        }
      ]
    },
    {
      "date": "26 Sep",
      "stocks": [
        {
          "symbol": "A",
          "stockSymbol": "AMANTA-BE",
          "companyName": "Amanta Healthcare Ltd",
          "cmp": "₹143.65",
          "changeInPrice": "+2.50",
          "changeInPercentage": "+1.77%",
          "isPositive": true,
        }
      ]
    },
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
              ...stocks.map((stock) {
                final isPositive = stock["isPositive"] as bool;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: theme.shadowColor,
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Stock Initial Circle
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: theme.shadowColor,
                        child: Text(
                          stock["symbol"],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Stock Info
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
                      // CMP + Change
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            stock["cmp"],
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: theme.primaryColorDark,
                            ),
                          ),
                          Text(
                            "${stock["changeInPrice"]} (${stock["changeInPercentage"]})",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isPositive
                                  ? theme.secondaryHeaderColor
                                  : theme.disabledColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
