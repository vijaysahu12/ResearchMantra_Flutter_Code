import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:research_mantra_official/ui/components/common_controllers/common_text_controllers.dart';
import 'package:research_mantra_official/ui/components/popupscreens/common_textspan.dart';

class NameTextField extends StatelessWidget {
  final TextEditingController userNameController;
  const NameTextField({super.key, required this.userNameController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          child: CommonTextSpan(
            mandatoryFieldName: "Full Name",
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        CommonTextEditController(
          readOnly: false,
          maxTextfieldLength: 25,
          namedController: userNameController,
          hintText: "Name",
          inputFormatters:
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
        ),
      ],
    );
  }
}
