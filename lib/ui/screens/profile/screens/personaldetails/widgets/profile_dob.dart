import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:research_mantra_official/ui/components/common_controllers/common_text_controllers.dart';
import 'package:research_mantra_official/ui/components/popupscreens/common_textspan.dart';

class DateOfBirthWidget extends StatefulWidget {
  final TextEditingController userDateOfBirthController;

  const DateOfBirthWidget({
    super.key,
    required this.userDateOfBirthController,
  });

  @override
  State<DateOfBirthWidget> createState() => _DateOfBirthWidgetState();
}

class _DateOfBirthWidgetState extends State<DateOfBirthWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CommonTextSpan(
          mandatoryFieldName: "Date of Birth",
        ),
        const SizedBox(
          height: 5,
        ),
        CommonTextEditController(
          namedController: widget.userDateOfBirthController,
          hintText: 'DD/MM/YYYY',
          onTap: () => _selectedDate(context),
          readOnly: true,
        ),
      ],
    );
  }

  Future<void> _selectedDate(BuildContext context) async {
    final theme = Theme.of(context);

    final DateFormat dateFormat = DateFormat('dd-MMM-yyyy');
    DateTime initialDate = DateTime.now(); // Default initial date

    // Parse the date string "30-May-2024" to DateTime if available
    try {
      initialDate = dateFormat.parse(widget.userDateOfBirthController.text);
    } catch (e) {
      // Parsing error, use default initial date
    }

    DateTime? picked = await showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.symmetric(vertical: 5),
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: theme.primaryColor,
            ),
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: initialDate,
              onDateTimeChanged: (DateTime newDate) {
                setState(() {
                  widget.userDateOfBirthController.text =
                      dateFormat.format(newDate);
                });
              },
              minimumYear: 1930,
              maximumDate: DateTime.now(),
            ),
          ),
        );
      },
    );

    if (picked != null) {
      widget.userDateOfBirthController.text = dateFormat.format(picked);
    }
  }
}
