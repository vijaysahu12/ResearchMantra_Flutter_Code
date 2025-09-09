import 'package:flutter/material.dart';
import 'package:research_mantra_official/ui/common_components/trade_action_container.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';

class TradeDetailsWidget extends StatefulWidget {
  final List<Map<String, dynamic>> idea;
  const TradeDetailsWidget({super.key, required this.idea});

  @override
  State<TradeDetailsWidget> createState() => _TradeDetailsWidgetState();
}

class _TradeDetailsWidgetState extends State<TradeDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: CommonAppBarWithBackButton(
        appBarText: "About Trade",
        handleBackButton: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          TradeTable(actions: widget.idea),
        ],
      ),
    );
  }
}
