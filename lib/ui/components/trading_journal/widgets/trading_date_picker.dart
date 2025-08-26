import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TradingDatePicker extends StatelessWidget {
  final DateTime date;
  final Function(DateTime) onDateChanged;

  const TradingDatePicker({
    super.key,
    required this.date,
    required this.onDateChanged,

  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 20.0),
          child: Text(
            'Date',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: theme.primaryColorDark,
                fontFamily: '1'),
          ),
        ),
        CupertinoButton(
          onPressed: () async {
            final DateTime? picked = await showCupertinoModalPopup(
              context: context,
              builder: (context) => Align(
                alignment: Alignment.center,
                child: Container(
                  height: 150,
                  width: 280,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: theme.primaryColor,
                  ),
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: date,
                    minimumDate: DateTime(2000),
                    maximumDate: DateTime(2101),
                    onDateTimeChanged: (newDate) {
                      if (newDate != date) {
                        onDateChanged(newDate);
                      }
                    },
                  ),
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
                color: theme.appBarTheme.backgroundColor,
                border: Border.all(color: theme.shadowColor, width: 1),
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                children: [
                  Icon(CupertinoIcons.calendar, color: theme.primaryColorDark),
                  const SizedBox(width: 16),
                  Text(
                    DateFormat('dd/MM/yyyy').format(date),
                    style:
                        TextStyle(fontSize: 16, color: theme.primaryColorDark),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
