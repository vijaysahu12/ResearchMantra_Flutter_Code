import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shimmer/shimmer.dart';

class UnlockCustomPopUp extends StatefulWidget {
  final void Function()? onPressed;
  const UnlockCustomPopUp({super.key,this.onPressed});

  @override
  State<UnlockCustomPopUp> createState() => _UnlockCustomPopUpState();
}

class _UnlockCustomPopUpState extends State<UnlockCustomPopUp> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimationConfiguration.staggeredList(
      position: 1,
      duration: const Duration(milliseconds: 250),
      child: SlideAnimation(
        verticalOffset: 100.0,
        child: FadeInAnimation(
          child: 
          Center(
            child: Dialog(
              backgroundColor: theme.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Container(
                height: MediaQuery.of(context)
                    .size
                    .width, // Fixed size of the dialog
                // width: 300,
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Shimmer effect only on the Lock Icon
                    Shimmer.fromColors(
                      baseColor: Colors.grey[400]!,
                      highlightColor: Colors.white,
                      child: Icon(
                        Icons.lock,
                        size: 120,
                        color: Colors.blueAccent,
                      ),
                    ),
                    SizedBox(height: 30),

                    // Static description text (no shimmer)
                    Text(
                      'Unlock exclusive content and features by completing the payment.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColorDark,
                        letterSpacing: 1.1,
                      ),
                    ),
                    SizedBox(height: 40),

                    ElevatedButton(
                      onPressed: widget.onPressed,
                      style: ElevatedButton.styleFrom(
                        // primary: Colors.grey[600], // Grey button
                        // onPrimary: Colors.white, // White text
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                        elevation: 5,
                      ),
                      child: Text('Proceed to Payment'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
