import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/providers/gender/gender_state.dart';

class GetGenderNotifier extends StateNotifier<GenderState> {
  GetGenderNotifier() : super(GenderState.initial());

  Future<void> updateGender(String genderValue) async {
    try {
      state = GenderState.update(genderValue);
    } catch (e) {
      state = GenderState.update('male');
    }
  }
}

final getGenderProvider = StateNotifierProvider<GetGenderNotifier, GenderState>(
    ((ref) => GetGenderNotifier()));
