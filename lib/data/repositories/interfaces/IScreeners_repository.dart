import 'package:research_mantra_official/data/models/screeners/screeners_category_data_model.dart';
import 'package:research_mantra_official/data/models/screeners/stock_data_model.dart';

abstract class IScreenersRepository {
  //This method for uopdate Fcm
  Future< List<Category>> getCategoryScreeners();
  Future< List<Stock>> getStockScreeners(int id ,String code );

}