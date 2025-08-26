import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:research_mantra_official/ui/components/common_controllers/common_text_controllers.dart';
import 'package:research_mantra_official/ui/components/popupscreens/common_textspan.dart';


class MobileNumberAndCity extends StatelessWidget {
  final TextEditingController userMobileController;
  final TextEditingController userCityController;

  const MobileNumberAndCity(
      {super.key,
      required this.userMobileController,
      required this.userCityController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildMobileNumberTextField(context),
            const SizedBox(width: 8),
            _buildCityTextField(context),
          ],
        ),
      ],
    );
  }

  //Widget for mobileNumber[child_Widget]
  Widget _buildMobileNumberTextField(
    BuildContext context,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CommonTextSpan(
            mandatoryFieldName: "Mobile Number",
          ),
          const SizedBox(
            height: 5,
          ),
          CommonTextEditController(
            maxTextfieldLength: 10,
            namedController: userMobileController,
            hintText: 'Mobile Number ',
            readOnly: true,
          ),
        ],
      ),
    );
  }

//Widget for City [child_widget]
  Widget _buildCityTextField(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CommonTextSpan(
            mandatoryFieldName: "City",
          ),
          const SizedBox(
            height: 5,
          ),
          CommonTextEditController(
            namedController: userCityController,
            maxTextfieldLength: 25,
            hintText: 'City',
            readOnly: false,
            inputFormatters:
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
          ),
        ],
      ),
    );
  }
}
