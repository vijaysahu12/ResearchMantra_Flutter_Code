import 'package:research_mantra_official/data/models/dynamic_bottom_sheet/dynamic_promo_model.dart';

class PromoState {
  final bool isLoading;
  final dynamic error;
  final List<PromoModel> promos;

  PromoState({
    required this.isLoading,
    required this.error,
    required this.promos,
  });

  factory PromoState.initial() => PromoState(
      isLoading: false, error: null, promos: []);

  factory PromoState.loading() => PromoState(
      isLoading: true, error: null, promos: []);

  factory PromoState.success(List<PromoModel> data) => PromoState(
      isLoading: false, error: null, promos: data);

  factory PromoState.error(dynamic error) => PromoState(
      isLoading: false, error: error, promos: []);
}
