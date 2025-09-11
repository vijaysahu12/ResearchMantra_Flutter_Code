import 'package:flutter/material.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';

class IposScreen extends StatefulWidget {
  const IposScreen({super.key});

  @override
  State<IposScreen> createState() => _IposScreenState();
}

class _IposScreenState extends State<IposScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: CommonAppBarWithBackButton(
        appBarText: "Ipos",
        handleBackButton: () => Navigator.pop(context),
      ),
      body: const Center(
        child: Text('Ipos Screen'),
      ),
    );
  }
}
