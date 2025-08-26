import 'package:flutter_riverpod/flutter_riverpod.dart';

class ServicesChsptertitleoNtifier extends StateNotifier<String> {
  ServicesChsptertitleoNtifier() : super(""); // Initial state as false


  void updateChapterTitle(String  value) {
    state = value;
  }
}

final servicestitleNotifierProvider =
    StateNotifierProvider<ServicesChsptertitleoNtifier, String>((ref) {
  return ServicesChsptertitleoNtifier();
});