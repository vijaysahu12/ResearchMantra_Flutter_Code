import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/ui/components/popupscreens/common_textspan.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

class PartnerId extends StatefulWidget {
  final TextEditingController partnerIdController;
  final void Function() togglePartnerNamesDropdown;
  const PartnerId(
      {super.key,
      required this.partnerIdController,
      required this.togglePartnerNamesDropdown});

  @override
  State<PartnerId> createState() => _PartnerIdState();
}

class _PartnerIdState extends State<PartnerId> {
  String partnerIdErrorMessage = '';
  int minLength = 3;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CommonTextSpan(
          mandatoryFieldName: partnerIdText,
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
            controller: widget.partnerIdController,
            maxLength: 20,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
            ],
            onChanged: (value) {
              if (value.length < minLength) {
                setState(() {
                  partnerIdErrorMessage = 'Please enter at least 3 characters';
                });
              } else {
                setState(() {
                  partnerIdErrorMessage = '';
                });
              }
            },
            onTap: () {
              widget.togglePartnerNamesDropdown();
            },
            style: TextStyle(
                fontSize: 13,
                color: theme.primaryColorDark,
                fontFamily: fontFamily),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: partnerIdText,
              hintStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: theme.focusColor),
              counterText: '',
            ),
          ),
        ),
        if (partnerIdErrorMessage.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              partnerIdErrorMessage,
              style: TextStyle(
                  color: theme.disabledColor,
                  fontSize: 12,
                  fontFamily: fontFamily),
            ),
          ),
      ],
    );
  }
}
