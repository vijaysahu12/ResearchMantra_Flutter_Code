import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/services/secure_storage.dart';

enum ThemeModeType { light, dark }

class ToggleThemeModeButtonStateNotifier extends StateNotifier<ThemeModeType> {
  final SharedPref _sharedPref = SharedPref();

  ToggleThemeModeButtonStateNotifier() : super(ThemeModeType.dark) {
    _initThemeMode();
  }

  void _initThemeMode() async {
    // Retrieve the theme mode from storage when the notifier is initialized
    final savedThemeMode = await _sharedPref.getBool('themeMode');
    state = savedThemeMode ? ThemeModeType.light : ThemeModeType.dark;
    }

  void toggleThemeMode() async {
    state = (state == ThemeModeType.light)
        ? ThemeModeType.dark
        : ThemeModeType.light;

    // Store the updated theme mode value in SecureStorage
    await _sharedPref.setBool("themeMode", state == ThemeModeType.light);
  }
}

final themeModeProvider =
    StateNotifierProvider<ToggleThemeModeButtonStateNotifier, ThemeModeType>(
  (ref) => ToggleThemeModeButtonStateNotifier(),
);
