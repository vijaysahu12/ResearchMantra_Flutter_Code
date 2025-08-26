import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:research_mantra_official/ui/components/button.dart';

//UpdateButton Widget
class UpdatePersonalDetailsButton extends ConsumerWidget {
  final Function handleManageUserDetails;

  const UpdatePersonalDetailsButton({
    super.key,
    required this.handleManageUserDetails,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Button(
      textColor: theme.floatingActionButtonTheme.foregroundColor,
      isLoading: false,
      text: "Update",
      onPressed: () async {
        handleManageUserDetails();
      },
      backgroundColor: theme.indicatorColor,
    );
  }
}
