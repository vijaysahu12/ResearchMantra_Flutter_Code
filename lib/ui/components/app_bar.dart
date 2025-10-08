import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:research_mantra_official/ui/components/widget/notification_count_widget.dart';
import 'package:research_mantra_official/ui/components/widget/username_profileimage_dashboard.dart';
import 'package:research_mantra_official/ui/router/app_routes.dart';
import 'package:research_mantra_official/ui/screens/home/home_navigator.dart';
import 'package:research_mantra_official/ui/screens/subscription_screen/common_subscription_screen.dart';

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

  void handleNavigateToPaymentScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: theme.appBarTheme.backgroundColor,
      title: Row(
        children: [
          const ProfileImageAndUserName(),
          const Spacer(),
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
          InkWell(
            onTap: handleNavigateToPaymentScreen,
            borderRadius: BorderRadius.circular(6),
            child: Container(
              decoration: BoxDecoration(
                color: theme.indicatorColor,
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              child: Text(
                "Subscribe",
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.floatingActionButtonTheme.foregroundColor,
                  fontSize: 10.sp,
                ),
              ),
            ),
          ),
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

    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: theme.primaryColor,
      title: Text(
        widget.appBarText,
        style: TextStyle(
            color: theme.primaryColorDark,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold),
      ),
      leading: IconButton(
        onPressed: widget.handleBackButton,
        icon: Icon(
          Icons.arrow_back_rounded,
          color: theme.primaryColorDark,
          size: 20.sp,
        ),
      ),
    );
  }
}
