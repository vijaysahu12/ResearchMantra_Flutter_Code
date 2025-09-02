import 'package:flutter/material.dart';
import 'package:research_mantra_official/ui/components/trading_journal/trading_journal_screen.dart';
import 'package:research_mantra_official/ui/components/widget/notification_count_widget.dart';
import 'package:research_mantra_official/ui/components/widget/username_profileimage_dashboard.dart';
import 'package:research_mantra_official/ui/router/app_routes.dart';
import 'package:research_mantra_official/ui/screens/home/home_navigator.dart';

class AppBarScreen extends StatefulWidget implements PreferredSizeWidget {
  final int selectedIndex;
  final GlobalKey scannerkey;

  const AppBarScreen({
    super.key,
    required this.selectedIndex,
    required this.scannerkey,
  });

  @override
  State<AppBarScreen> createState() => _AppBarScreenState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppBarScreenState extends State<AppBarScreen> {
  void handleNavigateToScannerScreen() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => HomeNavigatorWidget(
          initialIndex: 4, // Assuming index 4 is for Screeners tab
          isFromHome: false,
        ),
      ),
      (route) => false,
    );
  }

  void handleNavigateToJournalScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TradingJournalScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fontSize = MediaQuery.of(context).size.height;

    return AppBar(
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: theme.appBarTheme.backgroundColor,
      title: Row(
        children: [
          const ProfileImageAndUserName(),
          const Spacer(),
          // if (widget.selectedIndex == 3 || widget.selectedIndex == 4)
            Row(
              children: [
                Stack(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, notifications,
                            arguments: widget.selectedIndex);
                      },
                      icon: Icon(
                        Icons.notifications,
                        color: theme.primaryColorDark,
                      ),
                    ),
                    const Positioned(
                      top: 2,
                      right: 3,
                      child: NotificationCountWidget(),
                    )
                  ],
                ),
              ],
            ),
          // if (widget.selectedIndex != 3 && widget.selectedIndex != 4)
          //   InkWell(
          //     onTap: handleNavigateToJournalScreen,
          //     borderRadius: BorderRadius.circular(6),
          //     child: Container(
          //       padding:
          //           const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          //       decoration: BoxDecoration(
          //         gradient: LinearGradient(
          //           colors: [
          //             theme.disabledColor.withOpacity(0.9),
          //             theme.disabledColor.withOpacity(0.7),
          //           ],
          //           begin: Alignment.topLeft,
          //           end: Alignment.bottomRight,
          //         ),
          //         borderRadius: BorderRadius.circular(6),
          //         boxShadow: [
          //           BoxShadow(
          //             color: theme.shadowColor.withOpacity(0.1),
          //             blurRadius: 6,
          //             offset: const Offset(0, 2),
          //           ),
          //         ],
          //       ),
          //       child: Text(
          //         myJournalButtonText,
          //         style: TextStyle(
          //           fontSize: fontSize * 0.012,
          //           fontFamily: fontFamily,
          //           fontWeight: FontWeight.w600,
          //           color: theme.floatingActionButtonTheme.foregroundColor,
          //           letterSpacing: 0.2,
          //         ),
          //       ),
          //     ),
          //   ),
      
      
      
        ],
      ),
    );
  }
}

//Widget for Common App Bar
class CommonAppBarWithBackButton extends StatefulWidget
    implements PreferredSizeWidget {
  final String appBarText;
  final VoidCallback? handleBackButton;
  final Widget? widget;
  const CommonAppBarWithBackButton(
      {super.key,
      required this.appBarText,
      this.handleBackButton,
      this.widget});

  @override
  State<CommonAppBarWithBackButton> createState() =>
      _CommonAppBarWithBackButtonState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CommonAppBarWithBackButtonState
    extends State<CommonAppBarWithBackButton> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fontSize = MediaQuery.of(context).size.height;
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: theme.appBarTheme.backgroundColor,
      title: Text(
        widget.appBarText,
        style: TextStyle(
            color: theme.primaryColorDark,
            fontSize: fontSize * 0.02,
            fontWeight: FontWeight.bold),
      ),
      leading: IconButton(
        onPressed: widget.handleBackButton,
        icon: Icon(
          Icons.arrow_back_ios,
          color: theme.primaryColorDark,
          size: fontSize * 0.03,
        ),
      ),
    );
  }
}
