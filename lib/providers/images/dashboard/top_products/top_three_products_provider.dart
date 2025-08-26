import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/models/dashboard/dashboard_slider_model.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IDashBoard_respository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/images/dashboard/top_products/top_three_products_states.dart';

class TopThreeProductsStateNotifier
    extends StateNotifier<TopThreeProductsStates> {
  TopThreeProductsStateNotifier(this._topThreeProductsRepository)
      : super(TopThreeProductsStates.initail());

  final IDashBoardRepository _topThreeProductsRepository;

  //Method to  getTopThreeProducts
  Future<void> getTopThreeProducts(String mobileUserKey, bool isRefresh) async {
    try {
      if (state.topThreeImagesList.isEmpty && isRefresh) {
        state = TopThreeProductsStates.loading();
      }

      final List<DashBoardTopImagesModel> topThreeProducts =
          await _topThreeProductsRepository.getTopThreeProducts(mobileUserKey);

      state = TopThreeProductsStates.loadedImages(topThreeProducts);
    } catch (error) {
      state = TopThreeProductsStates.error(error.toString());
    }
  }
}

final topThreeProductsProvider = StateNotifierProvider<
    TopThreeProductsStateNotifier, TopThreeProductsStates>((ref) {
  final IDashBoardRepository topThreeProducts = getIt<IDashBoardRepository>();
  return TopThreeProductsStateNotifier(topThreeProducts);
});
