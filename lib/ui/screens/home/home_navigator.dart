import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/constants/storage.dart';
import 'package:research_mantra_official/providers/services_buttons_provider.dart';
import 'package:research_mantra_official/services/secure_storage.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';
import 'package:research_mantra_official/ui/components/bottom_navigation.dart';
import 'package:research_mantra_official/ui/components/dynamic_promo_card/watcher/promo_activator.dart';
import 'package:research_mantra_official/ui/screens/home/home_screen.dart';
import 'package:research_mantra_official/ui/screens/market/market_screen.dart';

import 'package:research_mantra_official/ui/screens/screeners/screeners_home_screen.dart';
import 'package:research_mantra_official/ui/screens/trades/trades_screens.dart';
import 'package:showcaseview/showcaseview.dart';

class HomeNavigatorWidget extends ConsumerStatefulWidget {
  final int initialIndex;
  final bool isFromHome;
  final String topicName;

  const HomeNavigatorWidget(
      {super.key,
      this.initialIndex = 0,
      this.isFromHome = false,
      this.topicName = "Breakfast"});

  @override
  ConsumerState<HomeNavigatorWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends ConsumerState<HomeNavigatorWidget> {
  late PageController pageController;
  bool onBackButtonPress = false;
  late int _selectedIndex;
  bool isFromHome = false;
  late GlobalKey scannerKey;
  late SharedPref pref;

  @override
  void initState() {
    super.initState();

    scannerKey = GlobalKey();
    pref = SharedPref();
    _checkishownorNot();
    pageController = PageController();
    _selectedIndex = widget.initialIndex;
  }

  Future<void> _checkishownorNot() async {
    bool value = await pref.getBool(tutorialShown);

    if (!value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ShowCaseWidget.of(context).startShowCase([
          scannerKey,
        ]);
      });
    }
    // Properly update Riverpod state
    ref.read(servicesButtonNotifierProvider.notifier).updateButtonType(false);
  }

  Future<void> updateIsSHown() async {
    await pref.setBool(tutorialShown, true);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  Future<bool> onWillPopScope() async {
    if (_selectedIndex > 0) {
      setState(() {
        _selectedIndex = 0;
      });
      return false; // Prevent app exit, just decrement the index.
    } else {
      return await _showExitConfirmation();
    }
  }

  Future<bool> _showExitConfirmation() async {
    final theme = Theme.of(context);
    final shouldExit = await showModalBottomSheet<bool>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      backgroundColor: theme.primaryColor,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Exit app',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.primaryColorDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Do you want to exit the app?',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.focusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  // Cancel button
                  Expanded(
                    child: _buildActionButton(
                      label: 'Go back',
                      color: theme.focusColor,
                      textColor:
                          theme.floatingActionButtonTheme.foregroundColor ??
                              theme.textTheme.bodyLarge?.color,
                      onTap: () => Navigator.of(context).pop(false),
                    ),
                  ),
                  const SizedBox(width: 25),
                  // Exit button
                  Expanded(
                    child: _buildActionButton(
                      label: 'Yes, exit',
                      color: theme.indicatorColor,
                      textColor:
                          theme.floatingActionButtonTheme.foregroundColor ??
                              theme.textTheme.bodyLarge?.color,
                      onTap: () => Navigator.of(context).pop(true),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );

    // Exit the app if the user confirms.
    if (shouldExit == true) {
      return await _exitApp();
    }
    return false; // Stay in the app.
  }

  Widget _buildActionButton({
    required String label,
    required Color color,
    required Color? textColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _exitApp() async {
    try {
      // Exit the app programmatically
      SystemNavigator.pop(); // For Android devices
      return true;
    } catch (e) {
      return true; // Stay in the app if exiting fails
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentIndex = ref.watch(bottomNavProvider);
    final List<Widget> children = [
      HomeScreenWidget(),
      const TradeScreen(
        initialSelectedTabIndex: 0,
      ),
      ScreenersHomeScreen(),
      const MarketScreen(),
    ];

    return SafeArea(
      top: false,
      left: false,
      right: false,
      bottom: Theme.of(context).platform == TargetPlatform.android,
      child: Scaffold(
        backgroundColor: theme.primaryColor,
        appBar: AppBarScreen(
          selectedIndex: currentIndex,
          scannerkey: scannerKey,
        ),
        // ignore: deprecated_member_use
        body: IndexedStack(
          index: currentIndex, // 👈 only changes visibility
          children: children,
        ),

        bottomNavigationBar: Container(
          color: Colors.transparent,
          child: BottomNavigation(
            selectedIndex: currentIndex,
            onItemTapped: (index) async {
              ref.read(bottomNavProvider.notifier).state = index;
            },
          ),
        ),
      ),
    );
  }
}

final bottomNavProvider = StateProvider<int>((ref) => 0);
