import 'package:research_mantra_official/data/models/total_products/active_product_count_model.dart';

abstract class IActiveProductCountRepository {
  Future<ActiveProductCountModel> getActiveProducts();
}
