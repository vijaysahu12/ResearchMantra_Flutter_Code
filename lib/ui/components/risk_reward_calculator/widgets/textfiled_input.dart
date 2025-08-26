import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:research_mantra_official/ui/components/risk_reward_calculator/widgets/colors/app_colors.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

class RiskRewardAppInputField extends StatelessWidget {
  final String label;
  final double labelSize;
  final String hint;
  final List<TextInputFormatter> inputFormatters;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final String? prefixText;
  final String? suffixText;
  final bool enabled;
  final double prefixPadding;

  const RiskRewardAppInputField({
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
    this.labelSize = 14,
    this.prefixPadding = 14,
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
              color: CAppColors.label(context),
              fontFamily: fontFamily),
        ),
        const SizedBox(height: 4),
        //Input Field styled like the image
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextFormField(
            inputFormatters: inputFormatters,
            cursorColor: CAppColors.subtitle(context),
            controller: controller,
            keyboardType: keyboardType,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            enabled: enabled,
            validator: validator,
            style: TextStyle(
                fontSize: 16,
                color: CAppColors.inputText(context),
                fontWeight: FontWeight.bold,
                fontFamily: fontFamily),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                  color: CAppColors.label(context).withAlpha(120),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: fontFamily),
              prefixIcon: Padding(
                padding:  EdgeInsets.symmetric(
                  horizontal: prefixPadding,
                ),
                child: Text(
                  prefixText ?? '',
                  style: TextStyle(
                      color: CAppColors.label(context),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: fontFamily),
                ),
              ),
              prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
              suffixIcon: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                ),
                child: Text(
                  suffixText ?? '',
                  style: TextStyle(
                      color: CAppColors.label(context),
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
                borderSide: BorderSide(
                    color: CAppColors.subtitle(context).withAlpha(180), width: 1),
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
              fillColor: CAppColors.border(context).withAlpha(110),
              errorStyle:  TextStyle(fontSize: 8, height: 0, fontWeight: FontWeight.bold, fontFamily: fontFamily),
              
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
