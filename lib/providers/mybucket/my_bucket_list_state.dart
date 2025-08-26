import '../../data/models/my_bucket_list_api_response_model.dart';

//my bucket list State
class MyBucketListState {
  final bool isLoading; //loading
  final List<MyBucketListApiResponseModel>
      myBucketListApiResponseModel; //get  response data
  final dynamic error; //error

  MyBucketListState(
      {required this.myBucketListApiResponseModel,
      required this.error,
      required this.isLoading});

//initail State
  factory MyBucketListState.initial() => MyBucketListState(
        myBucketListApiResponseModel: [],
        error: null,
        isLoading: false,
      );

  //loading State
  factory MyBucketListState.loading() => MyBucketListState(
        myBucketListApiResponseModel: [],
        error: null,
        isLoading: true,
      );

//loaded/success State
  factory MyBucketListState.success(
          List<MyBucketListApiResponseModel> myBucketListApiResponseModel) =>
      MyBucketListState(
        myBucketListApiResponseModel: myBucketListApiResponseModel,
        error: null,
        isLoading: false,
      );

//Error state
  factory MyBucketListState.error(dynamic error) => MyBucketListState(
        myBucketListApiResponseModel: [],
        error: error,
        isLoading: false,
      );

//like unlike manageState
  factory MyBucketListState.manageLikeUnlikestate(
    List<MyBucketListApiResponseModel> myBucketListApiResponseModel,
  ) {
    final updatedProducts = myBucketListApiResponseModel.map((product) {
      if (product.isHeart == !product.isHeart) {
        return product.copyWith(isHeart: !product.isHeart);
      }
      return product; // Return the unchanged product for other items
    }).toList();

    return MyBucketListState(
      myBucketListApiResponseModel: updatedProducts,
      isLoading: false,
      error: null,
    );
  }
}
