import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/ui/components/popupscreens/common_textspan.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

class PartnerSecretKey extends StatefulWidget {
  final TextEditingController partnerSecretKeyController;
  final void Function() togglePartnerNamesDropdown;
  const PartnerSecretKey(
      {super.key,
      required this.partnerSecretKeyController,
      required this.togglePartnerNamesDropdown});
  @override
  State<PartnerSecretKey> createState() => _PartnerSecretKeyState();
}

class _PartnerSecretKeyState extends State<PartnerSecretKey> {
  String partnerSecretKeyErrorMessage = '';
  int minlength = 10;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CommonTextSpan(
          mandatoryFieldName: partnerSecretKeyText,
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.055,
          padding: const EdgeInsets.symmetric(horizontal: 10),
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
            controller: widget.partnerSecretKeyController,
            maxLength: 500,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                  RegExp(r'[a-zA-Z0-9@#!.\-&$*]')),
            ],
            style: TextStyle(
                fontSize: 13,
                color: theme.primaryColorDark,
                fontFamily: fontFamily),
            onChanged: (value) {
              if (value.length < minlength) {
                setState(() {
                  partnerSecretKeyErrorMessage =
                      'Please enter at least 10 characters';
                });
              } else {
                setState(() {
                  partnerSecretKeyErrorMessage = '';
                });
              }
            },
            onTap: () {
              widget.togglePartnerNamesDropdown();
            },
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: partnerSecretKeyText,
                hintStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    fontFamily: fontFamily,
                    color: theme.focusColor),
                counterText: ''),
          ),
        ),
        if (partnerSecretKeyErrorMessage.isNotEmpty)
          Text(
            partnerSecretKeyErrorMessage,
            style: TextStyle(
              color: theme.disabledColor,
              fontSize: 12,
              fontFamily: fontFamily,
            ),
          )
      ],
    );
  }
}
