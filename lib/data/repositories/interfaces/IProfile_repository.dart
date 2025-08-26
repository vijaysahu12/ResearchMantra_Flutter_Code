import 'package:research_mantra_official/data/models/advertisement/advertisement_response.dart';

abstract class IProfileRepository {
  Future<AdvertisementResponseModel?> getAdvertisementList();
}
