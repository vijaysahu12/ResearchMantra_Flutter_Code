import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/data/models/my_bucket_list_api_response_model.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IMybucket_list_repository.dart';
import 'package:research_mantra_official/data/repositories/interfaces/INotification_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/mybucket/my_bucket_list_state.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';

//Notifier class for managing the State of bucket list Screen
class MyBucketListStateNotifier extends StateNotifier<MyBucketListState> {
  MyBucketListStateNotifier(
      this._mybucketListRepository, this._iNotificationRepository)
      : super(MyBucketListState.initial());

  final IMybucketListRepository _mybucketListRepository;
  final INotificationRepository _iNotificationRepository;

//fetch the bukect list itmes
  Future<void> getMyBucketListItems(
      String mobileUserPublicKey, bool isRefresh) async {
    try {
      if (isRefresh && state.myBucketListApiResponseModel.isEmpty) {
        state = MyBucketListState.loading();
      } else if (isRefresh == false) {
        state = MyBucketListState.loading();
      }

      final List<MyBucketListApiResponseModel>? getMyBucketListOfItems =
          await _mybucketListRepository.getMyBucketContent(mobileUserPublicKey);
      state = MyBucketListState.success(getMyBucketListOfItems!);
    } catch (error) {
      state = MyBucketListState.error(error.toString());
    }
  }

  Future<void> manageAllowNotification(bool isToggleNotification,
      String mobileUserPublicKey, int productId) async {
    try {
      final response =
          await _iNotificationRepository.manageProductNotifications(
              isToggleNotification, mobileUserPublicKey, productId);

      final List<MyBucketListApiResponseModel> updatedProducts =
          state.myBucketListApiResponseModel.map((product) {
        if (product.id == productId) {
          return product.copyWith(
            notificationEnabled: !product.notificationEnabled,
          );
        }
        return product;
      }).toList();

      if (response.status) {
        if (response.data == true) {
          ToastUtils.showToast(notificationRTurnedon, "");
          state = MyBucketListState.success(updatedProducts);
        } else if (response.data == false) {
          ToastUtils.showToast(notificationturnedof, "");
          state = MyBucketListState.success(updatedProducts);
        }
      } else {
        ToastUtils.showToast(somethingWentWrongString, "");
      }
    } catch (e) {
      state = MyBucketListState.error(e.toString());
    }
  }
}

//provider for managing the states
final myBucketListProvider =
    StateNotifierProvider<MyBucketListStateNotifier, MyBucketListState>((ref) {
  final IMybucketListRepository myBucketListProviderRepository =
      getIt<IMybucketListRepository>();
  final INotificationRepository iNotificationRepository =
      getIt<INotificationRepository>();
  return MyBucketListStateNotifier(
      myBucketListProviderRepository, iNotificationRepository);
});
