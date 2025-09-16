import 'package:flutter/material.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';

class SharksStocksDetails extends StatefulWidget {
  const SharksStocksDetails({super.key});

  @override
  State<SharksStocksDetails> createState() => _SharksStocksDetailsState();
}

class _SharksStocksDetailsState extends State<SharksStocksDetails> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: CommonAppBarWithBackButton(
        appBarText: "Shark Investor Stocks",
        handleBackButton: () => Navigator.pop(context),
      ),
      body: const Center(
        child: Text('Sharks Stocks Details Content'),
      ),
    );
  }
}
