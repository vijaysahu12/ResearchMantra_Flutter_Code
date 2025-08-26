import 'package:flutter/material.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/ui/components/dynamic_promo_card/service/promo_manager.dart';

class AutoBottomSheetObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    _maybeShowPromo();
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    _maybeShowPromo();
  }

  void _maybeShowPromo() {
    final context = navigatorKey.currentState?.overlay?.context;
    if (context != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        PromoManager().tryShowPromo(context);
      });
    }
  }
}
