import 'package:research_mantra_official/data/models/research/get_companies_data_model.dart';

class CompaniesState {
  final dynamic error;
  final bool isLoading;
  final  CompaniesDataModel ? companiesDataModel;

  CompaniesState({
    required this.isLoading,
    this.error,
    this.companiesDataModel,
  });

  factory CompaniesState.initial() => CompaniesState(
        isLoading: false,
        companiesDataModel: null,
      );
  factory CompaniesState.loading() => CompaniesState(
        isLoading: true,
      );

  factory CompaniesState.loaded(CompaniesDataModel ? companiesDataModel) =>
      CompaniesState(
        isLoading: false,
        companiesDataModel: companiesDataModel,
      );
  factory CompaniesState.error(dynamic error) => CompaniesState(
        isLoading: false,
        error: error,
        companiesDataModel: null,
      );
}

