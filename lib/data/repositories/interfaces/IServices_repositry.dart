 import 'package:research_mantra_official/data/models/services/services_response_model.dart';

abstract class IServicesReposity{
  Future<List<ServicesResponseModel>> getServicesList();

 }