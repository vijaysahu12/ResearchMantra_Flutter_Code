import 'package:flutter/material.dart';

import 'package:research_mantra_official/constants/assets.dart';
import 'package:research_mantra_official/ui/router/app_routes.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

class BottomSheetHelper {
  static void showCustomBottomSheet({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 18,
                      color: theme.primaryColorDark,
                      fontFamily: "poppins",
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 16.0),
              Image.asset(
                failedImage,
                scale: 5.5,
              ),
              const SizedBox(height: 16.0),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    message,
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.focusColor,
                      fontFamily: fontFamily,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  // Cancel button
                  Expanded(
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(false),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                          color: theme.focusColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Go back',
                            style: TextStyle(
                                fontFamily: fontFamily,
                                color: theme
                                    .floatingActionButtonTheme.foregroundColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(true),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                          color: theme.indicatorColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Retry payment',
                            style: TextStyle(
                                color: theme
                                    .floatingActionButtonTheme.foregroundColor,
                                fontFamily: fontFamily,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        );
      },
    );
  }

  static void showCustomSuccessBottomSheet({
    required BuildContext context,
    required dynamic title,
    required dynamic validity,
    required dynamic fromDate,
    required dynamic toDate,
  }) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 18,
                      color: theme.primaryColorDark,
                      fontFamily: "poppins",
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 16.0),
              Image.asset(
                successgif,
                scale: 1,
              ),
              const SizedBox(height: 16.0),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Your service is extended for $validity days, from\n$fromDate to $toDate",
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.focusColor,
                      fontFamily: fontFamily,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  // Cancel button
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, myBucketList);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                          color: theme.focusColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Checkout My Bucket",
                            style: TextStyle(
                              fontFamily: fontFamily,
                              color: theme
                                  .floatingActionButtonTheme.foregroundColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        );
      },
    );
  }
}
