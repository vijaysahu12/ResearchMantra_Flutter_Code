import 'package:research_mantra_official/data/models/perfomance/perfomance_header_response_model.dart';
import 'package:research_mantra_official/data/models/perfomance/perfomance_response_model.dart';

abstract class IPerformanceRepository {
  Future<PerformanceResponseModel> getPerfomanceData(String code);
  Future<List<GetPerformanceHeaderResponseModel>> getPerformanceHeader();

}
