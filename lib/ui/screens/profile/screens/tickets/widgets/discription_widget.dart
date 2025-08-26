import 'package:flutter/material.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

class DescriptionWidget extends StatefulWidget {
  final TextEditingController descriptionEditingController;
  final String? initialDescription;
  final void Function() handleToRemovePriorityDropDown;
  final void Function() handleToRemoveTicketTypeDropDown;
  final double height;
  const DescriptionWidget(
      {super.key,
      required this.descriptionEditingController,
      this.initialDescription,
      required this.handleToRemovePriorityDropDown,
      required this.handleToRemoveTicketTypeDropDown,
      required this.height});

  @override
  State<DescriptionWidget> createState() => _DescriptionWidgetState();
}

class _DescriptionWidgetState extends State<DescriptionWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        Container(
          height: widget.height * 0.18,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 5),
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
            maxLength: 500,
            maxLines: null,
            controller: widget.descriptionEditingController,
            onChanged: (value) {
              setState(() {});
            },
            onTap: () {
              widget.handleToRemovePriorityDropDown();
              widget.handleToRemoveTicketTypeDropDown();
            },
            decoration: InputDecoration(
              counterText: "",
              hintText: "Description",
              hintStyle: TextStyle(
                fontSize: 13,
                fontFamily: fontFamily,
                color: theme.focusColor,
                fontWeight: FontWeight.w600,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 20,
          child: Text(
            '${widget.descriptionEditingController.text.length}/500',
            style: TextStyle(
              fontSize: 12,
              color: theme.primaryColorDark,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
