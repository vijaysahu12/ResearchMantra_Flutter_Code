import 'package:flutter/material.dart';
import 'package:research_mantra_official/ui/themes/light_theme.dart';
import 'package:sliding_switch/sliding_switch.dart';

class NotificationSettingsWidget extends StatefulWidget {
  const NotificationSettingsWidget({super.key});

  @override
  State<NotificationSettingsWidget> createState() => _NotificationsScreen();
}

class _NotificationsScreen extends State<NotificationSettingsWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: lightTheme.primaryColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: lightTheme.scaffoldBackgroundColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Notifications',
                      style: TextStyle(
                          fontSize: 22,
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w800,
                          color: lightTheme.primaryColor),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    color: lightTheme.shadowColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: lightTheme.primaryColor, width: 2))),
                        child: Row(
                          children: [
                            Text(
                              'News',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'poppins',
                                  fontWeight: FontWeight.w500,
                                  color: lightTheme.primaryColor),
                            ),
                            const Spacer(),
                            slidingSwitch((v) {}),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: lightTheme.primaryColor, width: 2))),
                        child: Row(
                          children: [
                            Text(
                              'Community',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'poppins',
                                  fontWeight: FontWeight.w500,
                                  color: lightTheme.primaryColor),
                            ),
                            const Spacer(),
                            slidingSwitch((p0) => {}),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: lightTheme.primaryColor, width: 2))),
                        child: Row(
                          children: [
                            Text(
                              'Weekly Price Updates',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'poppins',
                                  fontWeight: FontWeight.w500,
                                  color: lightTheme.primaryColor),
                            ),
                            const Spacer(),
                            slidingSwitch((v) => {}),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: lightTheme.primaryColor, width: 2))),
                        child: Row(
                          children: [
                            Text(
                              'Account Updates',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'poppins',
                                  fontWeight: FontWeight.w500,
                                  color: lightTheme.primaryColor),
                            ),
                            const Spacer(),
                            slidingSwitch((p0) => {}),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          children: [
                            Text(
                              'Groups',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'poppins',
                                  fontWeight: FontWeight.w500,
                                  color: lightTheme.primaryColor),
                            ),
                            const Spacer(),
                            slidingSwitch((p0) => {}),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

//Widget for SlidingSwitch
  Widget slidingSwitch(Function(bool) onSwitchChanged) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: lightTheme.primaryColor, width: 1)),
      child: Row(
        children: [
          SlidingSwitch(
              value: false,
              onChanged: onSwitchChanged,
              onTap: () {},
              onDoubleTap: () {},
              onSwipe: () {},
              height: 29,
              width: 58,
              animationDuration: const Duration(milliseconds: 200),
              textOn: '',
              textOff: '',
              buttonColor: lightTheme.primaryColor),
        ],
      ),
    );
  }
}
