import 'package:research_mantra_official/data/models/services/services_response_model.dart';

class ServicesState{
  final List<ServicesResponseModel> servicesList;
  final bool isLoading;
  final dynamic error;
  ServicesState({
    required this.servicesList,
    required this.isLoading,
    required this.error,
  });

  factory ServicesState.initial() {
    return ServicesState(
      servicesList: [],
      isLoading: false,
      error: null,
    );
  }
  factory ServicesState.loading() {
    return ServicesState(
      servicesList: [],
      isLoading: true,
      error: null,
    );
  }
  factory ServicesState.error(dynamic error) {
    return ServicesState(
      servicesList: [],
      isLoading: false,
      error: error,
    );
  }
  factory ServicesState.success(List<ServicesResponseModel> servicesList) {
    return ServicesState(
      servicesList: servicesList,
      isLoading: false,
      error: null,
    );
  }
}