import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Commentary {
  final int id;
  final String description;
  final String time;

  Commentary({
    required this.id,
    required this.description,
    required this.time,
  });

  factory Commentary.fromJson(Map<String, dynamic> json) {
    return Commentary(
      id: json['id'],
      description: json['description'],
      time: json['time'],
    );
  }
}

class LiveCommentaryScreen extends StatefulWidget {
  const LiveCommentaryScreen({super.key});

  @override
  State<LiveCommentaryScreen> createState() => _LiveCommentaryScreenState();
}

class _LiveCommentaryScreenState extends State<LiveCommentaryScreen> {
  final List<Map<String, dynamic>> dummyData = [
    {
      "id": 1,
      "description":
          "Nice one! Captured 180 points in NIFTY — bought at 24950.2, now trading at 25132.0!",
      "time": "11:40 AM",
    },
    {
      "id": 2,
      "description":
          "Crushed it! Captured 200 points in NIFTY — bought at 24950.2, now trading at 25150.4!",
      "time": "12:51 PM",
    },
    {
      "id": 3,
      "description":
          "Bang on! Captured 220 points in NIFTY — bought at 24950.2, now trading at 25171.0!",
      "time": "1:08 PM",
    },
    {
      "id": 4,
      "description":
          "Clean move!! Captured 4100.0 points in GOLDM — bought at 115161.0, now trading at 119265.0!",
      "time": "1:29 PM",
    },
    {
      "id": 5,
      "description":
          "Sweet!! Captured 240 points in NIFTY — bought at 24950.2, now trading at 25190.7!",
      "time": "1:32 PM",
    },
    {
      "id": 6,
      "description":
          "Lit!! Captured 4150.0 points in GOLDM — bought at 115161.0, now trading at 119314.0!",
      "time": "1:36 PM",
    },
    {
      "id": 7,
      "description":
          "Fire!! Captured 4200.0 points in GOLDM — bought at 115161.0, now trading at 119367.0!",
      "time": "1:38 PM",
    },
  ];

  late List<Commentary> commentaries;

  @override
  void initState() {
    super.initState();
    commentaries = dummyData.map((data) => Commentary.fromJson(data)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.appBarTheme.backgroundColor,
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: commentaries.length,
        itemBuilder: (context, index) {
          final commentary = commentaries[index];
          return _buildCommentaryCard(commentary, theme);
        },
      ),
    );
  }

  //Widget for Commentary Card
  Widget _buildCommentaryCard(Commentary commentary, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            commentary.description,
            style: theme.textTheme.bodyMedium!.copyWith(
              color: theme.primaryColorDark,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                commentary.time,
                style: theme.textTheme.titleSmall!
                    .copyWith(color: theme.primaryColorDark, fontSize: 10.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
