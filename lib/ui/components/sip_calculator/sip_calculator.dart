import 'package:flutter/material.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';
import 'package:research_mantra_official/ui/components/sip_calculator/widget/sip_calculator_widget.dart';

class SipCalculator extends StatelessWidget {
  const SipCalculator({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: CommonAppBarWithBackButton(
        appBarText: "Step-Up SIP Calculator",
        handleBackButton: () {
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SipCalculatorWidget(),
          ),
        ),
      ),
    );
  }
}
