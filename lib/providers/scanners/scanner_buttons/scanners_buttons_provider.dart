import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScannersButtonStateNotifier extends StateNotifier<int> {
  ScannersButtonStateNotifier() : super(0);

  void updateButton(int index) {
    state = index;
  }
}

final scannersButtonsStateNotifierProvider =
    StateNotifierProvider.autoDispose<ScannersButtonStateNotifier, int>((ref) {
  return ScannersButtonStateNotifier();
});
