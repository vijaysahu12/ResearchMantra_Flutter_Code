import 'package:flutter/material.dart';

import 'package:research_mantra_official/services/user_secure_storage_service.dart';
import 'package:research_mantra_official/ui/Screens/home/home_navigator.dart';
import 'package:research_mantra_official/ui/Screens/login/login_screen.dart';

class AuthRouteResolverWidget extends StatefulWidget {
  // final bool isNewVersion;
  final bool userLoggedIn;

  const AuthRouteResolverWidget(
      {super.key,
      // required this.isNewVersion,
      required this.userLoggedIn});

  @override
  State<AuthRouteResolverWidget> createState() =>
      _AuthRouteResolverWidgetState();
}

class _AuthRouteResolverWidgetState extends State<AuthRouteResolverWidget> {
  final UserSecureStorageService userSecureStorageService =
      UserSecureStorageService();

  @override
  Widget build(BuildContext context) {
    return widget.userLoggedIn
        ? const HomeNavigatorWidget()
        : const LoginWidget();
  }
}
