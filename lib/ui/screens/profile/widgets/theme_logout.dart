import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:research_mantra_official/providers/theme_provider/theme_provider.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

import 'package:sliding_switch/sliding_switch.dart';

//Widget for lightmode/darkmode button
class DarkLightModeWidget extends ConsumerStatefulWidget {
  final Function handleLogoutPopUp;
  const DarkLightModeWidget({
    super.key,
    required this.handleLogoutPopUp,
  });

  @override
  ConsumerState<DarkLightModeWidget> createState() => _DarkLightModeWidget();
}

class _DarkLightModeWidget extends ConsumerState<DarkLightModeWidget> {
  @override
  Widget build(BuildContext context) {
    // final locale = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final themeModeController = ref.read(themeModeProvider.notifier);
    final themeMode = ref.watch(themeModeProvider);
    final height = MediaQuery.of(context).size.height;
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            child: Container(
              padding: const EdgeInsets.all(10),
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
                children: [
                  themeMode == ThemeModeType.dark
                      ? Icon(
                          Icons.nightlight_outlined,
                          color: theme.primaryColorDark,
                        )
                      : Icon(
                          Icons.wb_sunny,
                          color: theme.primaryColorDark,
                        ),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    modeButttonText,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: theme.primaryColorDark,
                      fontFamily: fontFamily,
                      fontSize: height * 0.015,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                            color: theme.primaryColorDark.withOpacity(0.4),
                            width: 1)),
                    child: Row(
                      children: [
                        SlidingSwitch(
                            value:
                                themeMode == ThemeModeType.light ? false : true,
                            onChanged: (bool value) {
                              setState(() {
                                themeModeController.toggleThemeMode();
                              });
                            },
                            onTap: () {},
                            onDoubleTap: () {},
                            onSwipe: () {},
                            height: 20,
                            width: 40,
                            animationDuration: const Duration(milliseconds: 0),
                            textOn: '',
                            textOff: '',
                            background: theme.shadowColor,
                            buttonColor:
                                theme.primaryColorDark.withOpacity(0.7))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => widget.handleLogoutPopUp(context),
            child: Container(
              padding: const EdgeInsets.all(10),
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
                children: [
                  Icon(
                    Icons.power_settings_new_outlined,
                    color: theme.primaryColorDark,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    // locale.logout,
                    "Logout",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: theme.primaryColorDark,
                      fontFamily: fontFamily,
                      fontSize: height * 0.015,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
