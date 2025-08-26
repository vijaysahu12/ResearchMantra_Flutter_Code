//DashBoard stateNotifier
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/models/dashboard/dashboard_slider_model.dart';
import 'package:research_mantra_official/providers/images/login_images/login_images_state.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IDashBoard_respository.dart';
import 'package:research_mantra_official/main.dart';


//Login images Notifier
class LoginScreenImagesStateNotifier extends StateNotifier<LoginScreenImagesState> {
  LoginScreenImagesStateNotifier(this._boardRepository)
      : super(LoginScreenImagesState.initail());

  final IDashBoardRepository _boardRepository;

//Method to Get DashBoard Ihages
  Future<void> getLoginScreenImagesList(String imageType) async {
    try {
      state = LoginScreenImagesState.loading();
      final List<CommonImagesResponseModel> loginImages =
          await _boardRepository.getDashBoardSliderImages(imageType);
      state = LoginScreenImagesState.loadedImages(loginImages);
    } catch (error) {
      state = LoginScreenImagesState.error(error.toString());
    }
  }


}

final loginScreenImagesProvider =
    StateNotifierProvider<LoginScreenImagesStateNotifier, LoginScreenImagesState>((ref) {
  final IDashBoardRepository loginScreenImages = getIt<IDashBoardRepository>();
  return LoginScreenImagesStateNotifier(loginScreenImages);
});



