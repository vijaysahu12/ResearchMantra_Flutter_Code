import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

class PaymentButtonWidget extends StatelessWidget {
  final ThemeData theme;
  final bool isLoading;

  // final int mappingId;
  final String buyButtonText;
  // final BuildContext context;

  final VoidCallback onStartPayment;

  const PaymentButtonWidget({
    super.key,
    required this.theme,
    required this.isLoading,
    // required this.mappingId,
    required this.buyButtonText,
    // required this.context,
    required this.onStartPayment,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Container(
      height: height * 0.14,
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          SizedBox(
            height: height * 0.05,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      onStartPayment(); // Calls function from parent
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: const RadialGradient(
                          colors: [
                            Color.fromARGB(255, 167, 25, 25),
                            Color.fromARGB(248, 107, 42, 42),
                          ],
                          radius: 10,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Align(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (isLoading)
                                SizedBox(
                                  width: height * 0.016,
                                  height: height * 0.016,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: theme.floatingActionButtonTheme
                                        .foregroundColor,
                                  ),
                                ),
                              const SizedBox(width: 10),
                              Text(
                                buyButtonText,
                                style: TextStyle(
                                  fontSize: height * 0.014,
                                  fontFamily: fontFamily,
                                  color: theme.floatingActionButtonTheme
                                      .foregroundColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'By proceeding, I accept the ',
                  style: TextStyle(
                    fontSize: 11,
                    fontFamily: fontFamily,
                    fontWeight: FontWeight.w600,
                    color: theme.focusColor,
                  ),
                ),
                TextSpan(
                  text: 'Terms',
                  style: TextStyle(
                    fontSize: 11,
                    fontFamily: fontFamily,
                    fontWeight: FontWeight.w600,
                    color: theme.focusColor,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      // TODO: Handle Terms navigation
                    },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
