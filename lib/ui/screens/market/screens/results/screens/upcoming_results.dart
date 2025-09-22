import 'package:flutter/material.dart';

class UpcomingResults extends StatefulWidget {
  const UpcomingResults({super.key});

  @override
  State<UpcomingResults> createState() => _UpcomingResultsState();
}

class _UpcomingResultsState extends State<UpcomingResults> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: const Center(
        child: Text('Upcoming Results Screen'),
      ),
    );
  }
}
