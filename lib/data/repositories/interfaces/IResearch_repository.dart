
//Interface for Research Repository
import 'package:research_mantra_official/data/models/research/get_basket_data_model.dart';
import 'package:research_mantra_official/data/models/research/get_companies_data_model.dart';
import 'package:research_mantra_official/data/models/research/get_reserach_comments.dart';
import 'package:research_mantra_official/data/models/research/research_detail_data_model.dart';

abstract class IResearchRepository {
  //This method for get all reports
  Future<ResearchDataModel> getReport(Map<String,dynamic> body);
  //This method for get all baskets
  Future<List<BasketDataModel>> getBasket();
  //This method for get all Companies
   Future<CompaniesDataModel> getCompanies(Map<String,dynamic> body);
  //This method for get all Comments
   Future<List<ResearchMessage>> getReserachMessages(num id);
  //This method for get all Comments
   Future<  Map<String,dynamic> > postReserachMessages(Map<String,dynamic> body);

}
