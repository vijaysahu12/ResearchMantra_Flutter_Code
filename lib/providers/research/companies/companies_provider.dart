import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/models/research/get_companies_data_model.dart';

import 'package:research_mantra_official/data/repositories/interfaces/IResearch_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/research/companies/companies_state.dart';

class CompaniesDetailsNotifier extends StateNotifier<CompaniesState> {
  CompaniesDetailsNotifier(this._researchRepository)
      : super(CompaniesState.initial());

  final IResearchRepository _researchRepository;

  Future<void> getCompaniesDataModel(
      Map<String, dynamic> body, isRefresh) async {
    try {
      if (isRefresh) {
        state = CompaniesState.loading();
      }

      final companiesDataModel = await _researchRepository.getCompanies(body);

      state = CompaniesState.loaded(companiesDataModel);
    } catch (e) {
      state = CompaniesState.error(e.toString());
    }
  }

  Future<void> updateCompaniesDataModel() async {
    try {
      // Get company data

      List<CompanyData> companyData =
          state.companiesDataModel?.companyData ?? [];

      // Modify the companyStatus to "View" by creating new

      if (companyData.isNotEmpty) {
        companyData = companyData.map((company) {
          if (company.companyStatus == null ||
              company.companyStatus != "View") {
            // If companyStatus is null or not "View", update it to "Read"
            return company.copyWith(companyStatus: "Read");
          }
          return company; // Return unchanged company if it's already "View"
        }).toList();
      }
      CompaniesDataModel companiesDataModel = CompaniesDataModel(
        hasResearchProduct: true,
        companyData: companyData,
      );

      state = CompaniesState.loaded(companiesDataModel);
    } catch (e) {
      state = CompaniesState.error(e.toString());
    }
  }
}

final companiesDetailsProvider =
    StateNotifierProvider<CompaniesDetailsNotifier, CompaniesState>(((ref) {
  final IResearchRepository companiesResearchRepository =
      getIt<IResearchRepository>();
  return CompaniesDetailsNotifier(companiesResearchRepository);
}));
