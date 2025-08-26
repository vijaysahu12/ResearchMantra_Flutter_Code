import 'package:flutter/material.dart';

void showLoadingDialog(BuildContext context) {
  final theme = Theme.of(context);
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        alignment: Alignment.bottomCenter,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: SizedBox(
          width: 100,
          height: 50,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: theme.indicatorColor,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    "Loading...",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: theme.primaryColorDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
