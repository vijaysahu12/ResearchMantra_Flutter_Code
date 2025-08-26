import 'package:research_mantra_official/data/models/invoice/invoices_response_model.dart';

import '../../models/my_bucket_list_api_response_model.dart';

//Interface for MyBucket List
abstract class IMybucketListRepository {
  //Get All My Bucket list Content
  Future<List<MyBucketListApiResponseModel>?> getMyBucketContent(
      String mobileUserPublicKey);

  Future<List<GetInvoicesModel>> getInvoicesByMobileUserKey(
      String mobileUserKey, int pageNumber, int pagiSize);

  Future<List<GetInvoicesModel>> getInvoicesMoreByMobileUserKey(
      String mobileUserKey, int pageNumber, int pagiSize);
}
