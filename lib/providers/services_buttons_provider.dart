import 'package:flutter_riverpod/flutter_riverpod.dart';

class ServicesButtonNotifier extends StateNotifier<bool> {
  ServicesButtonNotifier() : super(false); // Initial state as false

  void updateButtonType(bool value) {
    state = value;
  }
}

final servicesButtonNotifierProvider =
    StateNotifierProvider<ServicesButtonNotifier, bool>((ref) {
  return ServicesButtonNotifier();
});
