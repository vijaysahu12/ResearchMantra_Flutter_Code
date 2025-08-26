import 'package:flutter/material.dart';
import 'package:research_mantra_official/ui/components/common_controllers/common_text_controllers.dart';
import 'package:research_mantra_official/ui/components/popupscreens/common_textspan.dart';

class EmailIdTextField extends StatelessWidget {
  final TextEditingController userEmailController;
  const EmailIdTextField({super.key, required this.userEmailController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CommonTextSpan(
          mandatoryFieldName: "Email ID",
        ),
        const SizedBox(
          height: 5,
        ),
        CommonTextEditController(
          namedController: userEmailController,
          maxTextfieldLength: 40,
          hintText: 'Email Id',
          readOnly: false,
        ),
      ],
    );
  }
}
