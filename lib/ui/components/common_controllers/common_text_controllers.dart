import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

class CommonTextEditController extends StatelessWidget {
  final TextEditingController namedController;
  final FilteringTextInputFormatter? inputFormatters;
  final String hintText;
  final Future<void> Function()? onTap;
  final bool readOnly;
  final int? maxTextfieldLength;
  const CommonTextEditController(
      {super.key,
      required this.namedController,
      required this.hintText,
      this.inputFormatters,
      this.onTap,
      this.maxTextfieldLength,
      required this.readOnly});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fontSize = MediaQuery.of(context).size.height;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
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
      child: TextField(
        readOnly: readOnly,
        controller: namedController,
        maxLength: maxTextfieldLength,
        onTap: onTap ?? () {},
        // textCapitalization: TextCapitalization.characters, ////Todo: uncomment this line if you want to capitalize the text and make it dynamic as per the requirement
        inputFormatters: inputFormatters == null ? null : [inputFormatters!],
        style: TextStyle(
          fontSize: fontSize * 0.013,
          fontFamily: fontFamily,
          color: theme.primaryColorDark,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          counterText: '',
          hintStyle: TextStyle(
            fontFamily: fontFamily,
            color: theme.primaryColorDark,
            fontSize: fontSize * 0.013,
          ),
        ),
      ),
    );
  }
}
