import 'package:flutter/material.dart';

import 'package:research_mantra_official/constants/generic_message.dart';

class DeleteAndDeactivateButtons extends StatelessWidget {
  final void Function(BuildContext context) handleDeleteAccountPopUp;

  const DeleteAndDeactivateButtons({
    super.key,
    required this.handleDeleteAccountPopUp,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: theme.disabledColor, width: 2))),
          child: InkWell(
              onTap: () => handleDeleteAccountPopUp(context),
              child: Text(
                deleteAccountbuttonText,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: theme.disabledColor),
              )),
        ),
      ],
    );
  }
}
