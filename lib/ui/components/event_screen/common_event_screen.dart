import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonEventScreen extends StatefulWidget {
  const CommonEventScreen({super.key});

  @override
  State<CommonEventScreen> createState() => _CommonEventScreenState();
}

class _CommonEventScreenState extends State<CommonEventScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.appBarTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.cancel,
                    color: theme.primaryColorDark,
                    size: 20.w,
                  ),
                )
              ],
            ),
            SizedBox(height: 5.h),
            AspectRatio(
                aspectRatio: 2.4,
                child: Image.network(
                    "https://img.freepik.com/free-vector/gradient-electronic-music-twitter-header_23-2149814012.jpg?semt=ais_hybrid&w=740&q=80")),
          ],
        ),
      ),
    );
  }
}
