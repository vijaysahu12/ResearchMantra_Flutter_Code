import 'package:flutter/material.dart';

class DeclaredResultScreen extends StatelessWidget {
  const DeclaredResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: const Center(
        child: Text(
          'Declared Results Screen',
        ),
      ),
    );
  }
}
