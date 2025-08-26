import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/ui/components/popupscreens/common_textspan.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

class PartnerApiKey extends StatefulWidget {
  final TextEditingController partnerApiController;
  final void Function() togglePartnerNamesDropdown;
  const PartnerApiKey(
      {super.key,
      required this.partnerApiController,
      required this.togglePartnerNamesDropdown});

  @override
  State<PartnerApiKey> createState() => _PartnerApiKeyState();
}

class _PartnerApiKeyState extends State<PartnerApiKey> {
  String partnerApiKeyError = '';
  int minLength = 10;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CommonTextSpan(
          mandatoryFieldName: partnerApiText,
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
            controller: widget.partnerApiController,
            maxLength: 35,
            style: TextStyle(
                fontSize: 13,
                color: theme.primaryColorDark,
                fontFamily: fontFamily),
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                  RegExp(r'[a-zA-Z0-9@#!.\-&$*]')),
            ],
            onChanged: (value) {
              if (value.length < minLength) {
                setState(() {
                  partnerApiKeyError = 'Please enter at least 10 characters';
                });
              } else {
                setState(() {
                  partnerApiKeyError = '';
                });
              }
            },
            onTap: () {
              widget.togglePartnerNamesDropdown();
            },
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: partnerApiText,
                hintStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: theme.focusColor),
                counterText: ''),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        if (partnerApiKeyError.isNotEmpty)
          Text(
            partnerApiKeyError,
            style: TextStyle(
                color: theme.disabledColor,
                fontSize: 12,
                fontFamily: fontFamily),
          )
      ],
    );
  }
}
