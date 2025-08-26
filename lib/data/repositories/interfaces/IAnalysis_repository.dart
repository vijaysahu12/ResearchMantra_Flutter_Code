import 'package:research_mantra_official/data/models/market_analysis/all_post_market_analysis.dart';
import 'package:research_mantra_official/data/models/market_analysis/all_premarket_analysis.dart';
import 'package:research_mantra_official/data/models/market_analysis/specifc_postmarket_analysis.dart';
import 'package:research_mantra_official/data/models/market_analysis/specifc_premarket_analysis.dart';



abstract class IAnalysisRepository {
  //This method for uopdate Fcm
  Future<List<AllPreMarketAnalysisDataModel>?> getAllPreMarketAnalysis(int id);

  Future<PreMarketAnalysisData?> getPreMarketAnalysisById(String id);
  Future<PostMarketAnalysisStockData?> getPostMarketAnalysisById(String id);
  Future<List<AllPostMarketStockReport?>> getAllPostMarketAnalysis(int pageNumber );
 

}