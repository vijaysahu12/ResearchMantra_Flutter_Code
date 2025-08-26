import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

class TradingJournalInputField extends StatelessWidget {
  final String label;
  final double labelSize;
  final String hint;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter> inputFormatters;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final String? prefixText;
  final String? suffixText;
  final bool enabled;
  final int maxLines;
  final double prefixPadding;
  final bool readOnly;

  const TradingJournalInputField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixText,
    this.suffixText,
    this.inputFormatters = const [],
    this.enabled = true,
    this.labelSize = 12,
    this.maxLines = 1,
    this.prefixPadding = 10,
    this.textInputAction,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Field Label
        Text(
          label,
          style: TextStyle(
              fontSize: labelSize,
              fontWeight: FontWeight.w600,
              color: theme.primaryColorDark,
              fontFamily: fontFamily),
        ),
        const SizedBox(height: 10),
        //Input Field styled like the image
        TextFormField(
          readOnly: readOnly,
          textInputAction: textInputAction,
          maxLines: maxLines,
          inputFormatters: inputFormatters,
          cursorColor: theme.primaryColorDark,
          controller: controller,
          keyboardType: keyboardType,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          enabled: enabled,
          validator: validator,
          style: TextStyle(
              fontSize: 16,
              color: theme.primaryColorDark,
              fontWeight: FontWeight.normal,
              fontFamily: fontFamily),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(12),
            hintText: hint,
            hintStyle: TextStyle(
                color: theme.focusColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: fontFamily),
            prefixIcon: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: prefixPadding,
              ),
              child: Text(
                prefixText ?? '',
                style: TextStyle(
                    color: theme.primaryColorDark,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: fontFamily),
              ),
            ),
            prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
            suffixIcon: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Text(
                suffixText ?? '',
                style: TextStyle(
                    color: theme.primaryColorDark,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: fontFamily),
              ),
            ),
            suffixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: theme.shadowColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: theme.shadowColor, width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            filled: true,
            fillColor: theme.appBarTheme.backgroundColor,
            errorStyle: TextStyle(
                fontSize: 8,
                height: 0,
                fontWeight: FontWeight.bold,
                fontFamily: fontFamily),
          ),
        ),
        //const SizedBox(height: 10),
      ],
    );
  }
}
