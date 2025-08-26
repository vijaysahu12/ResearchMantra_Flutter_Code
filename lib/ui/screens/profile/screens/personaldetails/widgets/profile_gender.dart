import 'package:flutter/material.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/ui/components/popupscreens/common_textspan.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

// GenderSelection widget
class GenderSelection extends StatefulWidget {
  final String? selectedGender;
  final void Function(String?) onGenderChanged;
  const GenderSelection(
      {super.key, required this.selectedGender, required this.onGenderChanged});

  @override
  State<GenderSelection> createState() => _GenderSelectionState();
}

class _GenderSelectionState extends State<GenderSelection> {
  String? _selectedGender;

  @override
  void initState() {
    super.initState();

    _selectedGender = widget.selectedGender!.toLowerCase().trim();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
      
        
        const CommonTextSpan(
            mandatoryFieldName: "Gender",
          ),
        const SizedBox(
          height: 5,
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: theme.primaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: theme.focusColor.withOpacity(0.4),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      maleGenderButton,
                      style: TextStyle(
                          fontSize: 12,
                          color: theme.primaryColorDark,
                          fontFamily: fontFamily),
                    ),
                    Radio(
                      value: maleGenderValue,
                      groupValue: _selectedGender!.toLowerCase(),
                      onChanged: (value) {
                        //local state
                        setState(() {
                          _selectedGender = value.toString();

                          widget.onGenderChanged(_selectedGender);
                        });
                      },
                      activeColor: theme.primaryColorDark,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: theme.primaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: theme.focusColor.withOpacity(0.4),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      femaleGenderButton,
                      style: TextStyle(
                          fontSize: 12,
                          color: theme.primaryColorDark,
                          fontFamily: fontFamily),
                    ),
                    Radio(
                      value: femaleGenderValue,
                      groupValue: _selectedGender!.toLowerCase(),
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value.toString();

                          widget.onGenderChanged(_selectedGender);
                        });
                      },
                      activeColor: theme.primaryColorDark,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
