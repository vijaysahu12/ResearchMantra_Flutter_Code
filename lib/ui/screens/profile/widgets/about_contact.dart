import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:research_mantra_official/constants/generic_message.dart';

import 'package:research_mantra_official/providers/get_support_mobile/support_mobile_state.dart';
import 'package:research_mantra_official/ui/components/common_box_buttons/box_shadow_buttons.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutAndContactUs extends StatefulWidget {
  final GetSupportState getMobileNumber;
  const AboutAndContactUs({super.key, required this.getMobileNumber});

  @override
  State<AboutAndContactUs> createState() => _AboutAndContactUsState();
}

class _AboutAndContactUsState extends State<AboutAndContactUs> {
  bool isCallButtonClicked = true;
  bool isAboutButtonClicked = true;

  @override
  void initState() {
    super.initState();
  }

  void makeCallTo() async {
    var phoneNumber = "tel:${widget.getMobileNumber.data}";
    if (isCallButtonClicked) {
      if (await canLaunch(phoneNumber)) {
        await launch(phoneNumber);
      } else {
        print('Could not launch $phoneNumber');
      }

      setState(() {
        isCallButtonClicked = false;
      });
    }
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isCallButtonClicked = true;
      });
    });
  }

  void aboutUs() async {
    if (isAboutButtonClicked) {
      await launchUrl(Uri.parse(aboutUsUrl));
      setState(() {
        isAboutButtonClicked = false;
      });
    }
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isAboutButtonClicked = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CommonBoxShadowButtons(
              buttonText: aboutText,
              iconTextName: Icons.info_outline,
              handleNavigateToScreen: aboutUs,
            ),
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        Row(
          children: [
            CommonBoxShadowButtons(
              buttonText: contactText,
              iconTextName: Icons.call_outlined,
              handleNavigateToScreen: makeCallTo,
            ),
          ],
        ),
      ],
    );
  }
}
