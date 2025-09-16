import 'package:flutter/material.dart';

class IpoDetailsScreen extends StatefulWidget {
  const IpoDetailsScreen({super.key});

  @override
  State<IpoDetailsScreen> createState() => _IpoDetailsScreenState();
}

class _IpoDetailsScreenState extends State<IpoDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: Center(
        child: Text("iposs"),
      ),
    );
  }
}
