import 'package:flutter/material.dart';

import 'dart:math' as math;

import 'package:research_mantra_official/ui/themes/text_styles.dart';

class TradeStats extends StatelessWidget {
  final String balance;
  final int totalTrades;
  final int profitableTrades;
  final int lossTrades;
  final int closedTrades;
  final int tradeOpen;

  const TradeStats(
      {super.key,
      required this.balance,
      required this.totalTrades,
      required this.profitableTrades,
      required this.lossTrades,
      required this.closedTrades,
      required this.tradeOpen});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fontSize = MediaQuery.of(context).size.height;
    final segments = [
      ProgressSegment(
        value: 0.0,
        color: theme.indicatorColor,
        label: 'Total Trades',
        displayValue: '($totalTrades)',
      ),
      ProgressSegment(
        value: profitableTrades.toDouble(),
        color: theme.secondaryHeaderColor,
        label: 'Total Profitable',
        displayValue: '($profitableTrades)',
      ),
      ProgressSegment(
        value: lossTrades.toDouble(),
        color: theme.disabledColor,
        label: 'Total Loss',
        displayValue: '($lossTrades)',
      ),
      ProgressSegment(
        value: 0.0,
        color: Colors.orange,
        label: 'Trade Closed',
        displayValue: '($closedTrades)',
      ),
      ProgressSegment(
        value: 0.0,
        color: theme.focusColor,
        label: 'Trade Open',
        displayValue: '($tradeOpen)',
      ),
    ];

    return Container(
      margin: const EdgeInsets.all(4),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Card(
          color: theme.appBarTheme.backgroundColor,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left side - Circular Progress
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: SizedBox(
                      child: CustomPaint(
                        painter: CircularProgressPainter(segments: segments),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'BALANCE',
                                style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: fontSize * 0.013,
                                  color: theme.focusColor,
                                ),
                              ),
                              Text(
                                balance,
                                style: TextStyle(
                                  fontFamily: fontFamily,
                                  color: theme.primaryColorDark,
                                  fontSize: fontSize * 0.015,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Right side - Labels
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: segments
                        .map((segment) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    margin: const EdgeInsets.only(
                                      right: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: segment.color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              segment.label,
                                              style: TextStyle(
                                                fontSize: fontSize * 0.012,
                                                color: theme.focusColor,
                                                fontFamily: fontFamily,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              segment.displayValue,
                                              style: TextStyle(
                                                fontFamily: fontFamily,
                                                color: theme.primaryColorDark,
                                                fontSize: fontSize * 0.012,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProgressSegment {
  final double value;
  final Color color;
  final String label;
  final String displayValue;

  ProgressSegment({
    required this.value,
    required this.color,
    required this.label,
    required this.displayValue,
  });
}

class CircularProgressPainter extends CustomPainter {
  final List<ProgressSegment> segments;

  CircularProgressPainter({required this.segments});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final strokeWidth = radius * 0.2;

    final total = segments.fold<double>(
        0, (previous, segment) => previous + segment.value);

    double startAngle = -math.pi / 2;

    for (var segment in segments) {
      final sweepAngle = 2 * math.pi * (segment.value / total);

      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..color = segment.color;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
