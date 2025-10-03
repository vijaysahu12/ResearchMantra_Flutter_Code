import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/models/app_version_response_model.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IUser_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/newversion/new_version_states.dart';

class NewVersionStateNotifier extends StateNotifier<NewVersionState> {
  NewVersionStateNotifier(this._iUserRepository)
      : super(NewVersionState.loading());

  final IUserRepository _iUserRepository;


  Future<void> getAppNewVersionData(
      String deviceType, String versionName) async {
    try {
      state = NewVersionState.loading();
      final AppVersionResponseModel responseData =
          await _iUserRepository.getApiVersion(deviceType, versionName);
      state = NewVersionState.loaded(responseData);
        } catch (e) {
      state = NewVersionState.error('no Data$e');
    }
  }
}

final newVersionDetailsProvider =
    StateNotifierProvider<NewVersionStateNotifier, NewVersionState>((ref) {
  final IUserRepository iUserRepositoryDetails = getIt<IUserRepository>();
  return NewVersionStateNotifier(iUserRepositoryDetails);
});
