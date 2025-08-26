import 'package:flutter_riverpod/flutter_riverpod.dart';

class AspectRatioNotifier extends StateNotifier<Map<String, double>> {
  AspectRatioNotifier() : super({});

  void calculateAspectRatios(fileList) async {
    final newAspectRatios = <String, double>{};

    state = newAspectRatios;
  }
}

final aspectRatioProvider =
    StateNotifierProvider<AspectRatioNotifier, Map<String, double>>((ref) {
  return AspectRatioNotifier();
});
