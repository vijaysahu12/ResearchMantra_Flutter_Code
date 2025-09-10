import 'package:flutter/material.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';

class SharksScreen extends StatefulWidget {
  const SharksScreen({super.key});

  @override
  State<SharksScreen> createState() => _SharksScreenState();
}

class _SharksScreenState extends State<SharksScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: CommonAppBarWithBackButton(
        appBarText: "Sharks",
        handleBackButton: () => Navigator.pop(context),
      ),
      body: const Center(
        child: Text('Sharks Screen'),
      ),
    );
  }
}
