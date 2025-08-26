import 'package:flutter/material.dart';
import 'package:research_mantra_official/constants/assets.dart';

class CustomshowDailyQuote extends StatelessWidget {
  final String quoteTitle;
  final String quoteAuthor;

  const CustomshowDailyQuote(
      {super.key, required this.quoteTitle, required this.quoteAuthor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final height = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          image: const DecorationImage(
              image: AssetImage(quoteBackground),
              opacity: 0.8,
              fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(100),
        ),
        width: height * 0.85,
        height: height * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    quoteTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: height * 0.032,
                      color: theme.floatingActionButtonTheme.foregroundColor,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  child: Text(
                    "-- $quoteAuthor",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "poppins",
                      fontWeight: FontWeight.bold,
                      fontSize: height * 0.04,
                      color: theme.floatingActionButtonTheme.foregroundColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
