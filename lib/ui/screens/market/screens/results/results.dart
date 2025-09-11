import 'package:flutter/material.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: CommonAppBarWithBackButton(
        appBarText: "Results",
        handleBackButton: () => Navigator.pop(context),
      ),
      body: const Center(
        child: Text('Results Screen'),
      ),
    );
  }
}
