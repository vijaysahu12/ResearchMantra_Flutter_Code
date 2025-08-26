import 'package:flutter/material.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/ui/components/popupscreens/common_textspan.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

class PartnerName extends StatefulWidget {
  final String? selectedPartner;
  final void Function() togglePartnerNamesDropdown;
  final LayerLink partnerNameLayerLink;

  const PartnerName({
    super.key,
    this.selectedPartner,
    required this.togglePartnerNamesDropdown,
    required this.partnerNameLayerLink,
  });

  @override
  State<PartnerName> createState() => _PartnerNameState();
}

class _PartnerNameState extends State<PartnerName> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CommonTextSpan(
            mandatoryFieldName: partnerNameText,
          ),
          const SizedBox(
            height: 5,
          ),
          GestureDetector(
            onTap: () => widget.togglePartnerNamesDropdown(),
            child: CompositedTransformTarget(
              link: widget.partnerNameLayerLink,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.055,
                margin: const EdgeInsets.symmetric(vertical: 2),
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
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
                  children: [
                    Text(
                      widget.selectedPartner ?? '',
                      style: TextStyle(
                          fontSize: 14,
                          color: theme.primaryColorDark,
                          fontFamily: fontFamily),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: theme.primaryColorDark,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
