
import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/data/models/invoice/invoices_response_model.dart';
import 'package:research_mantra_official/data/models/my_bucket_list_api_response_model.dart';
import 'package:research_mantra_official/data/network/http_client.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IMybucket_list_repository.dart';
import 'package:research_mantra_official/main.dart';

//Repository implemtation for managing bucket list.
class MybucketListRepository implements IMybucketListRepository {
  final HttpClient _httpClient = getIt<HttpClient>();

  @override
  Future<List<MyBucketListApiResponseModel>?> getMyBucketContent(
      String mobileUserPublicKey) async {
    try {
      // Make HTTP GET request to get bucket list content
      final response = await _httpClient
          .get("$getmyBucketContent?userKey=$mobileUserPublicKey");
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> myBucketData = response.data;

        final List<MyBucketListApiResponseModel> myBucketListData = myBucketData
            .map((data) => MyBucketListApiResponseModel.fromJson(data))
            .toList();
        return myBucketListData;
      } else {
        if (response.data == null) {
          return [];
        } else {
          throw Exception(response.message);
        }
      }
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  @override
  Future<List<GetInvoicesModel>> getInvoicesByMobileUserKey(
      String mobileUserPublicKey, int pageNumber, int pagiSize) async {
    try {
      final response = await _httpClient.get(
          "$getInvoicesByMobileUserKeyApi?mobileUserKey=$mobileUserPublicKey&pageNumber=$pageNumber&pagiSize=$pagiSize");
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> invoiceData = response.data;

        final List<GetInvoicesModel> myBucketListData =
            invoiceData.map((data) => GetInvoicesModel.fromJson(data)).toList();
        return myBucketListData;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<GetInvoicesModel>> getInvoicesMoreByMobileUserKey(
      String mobileUserPublicKey, int pageNumber, int pagiSize) async {
    try {
      final response = await _httpClient.get(
          "$getInvoicesByMobileUserKeyApi?mobileUserKey=$mobileUserPublicKey&pageNumber=$pageNumber&pagiSize=$pagiSize");
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> invoiceData = response.data;

        final List<GetInvoicesModel> myBucketListData =
            invoiceData.map((data) => GetInvoicesModel.fromJson(data)).toList();
        return myBucketListData;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
