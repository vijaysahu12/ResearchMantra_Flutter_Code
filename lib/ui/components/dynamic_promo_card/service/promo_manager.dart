import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:research_mantra_official/data/models/hive_model/promo_hive_model.dart';
import 'package:research_mantra_official/ui/components/dynamic_promo_card/dynamic_promo_card.dart';

class PromoManager {
  static final PromoManager _instance = PromoManager._internal();
  factory PromoManager() => _instance;
  PromoManager._internal();

  DateTime? _lastShownTime;

  Future<void> tryShowPromo(BuildContext context,
      {bool disable = false}) async {
    if (disable) {
      print("Promo disabled on this screen.");
      return;
    }
    final now = DateTime.now();

    if (_lastShownTime == null ||
        now.difference(_lastShownTime!).inSeconds >= 5) {
      _lastShownTime = now;

      final box = Hive.box<PromoHiveModel>('promos');
      final promos = box.values.toList();
      await Future.delayed(const Duration(seconds: 2));

      if (promos.isEmpty) {
        print("No promos available to show.");
        return;
      }

      for (var promo in promos) {
        if (_shouldShowPromoNow(promo)) {
          await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => PromoBottomSheet(promo: promo),
          ).then((value) async {
            final updatedPromo = promo.copyWith(
              maxDisplayCount: promo.maxDisplayCount - 1,
              lastShownAt: DateTime.now().toIso8601String(),
            );

            if (promo.maxDisplayCount <= 0) {
              promo.shouldDisplay = false;
              await box.delete(promo.key);
            } else {
              await box.put(promo.id, updatedPromo);
            }
          });
        }
      }
    } else {
      print("⏳ Promo skipped due to throttle .");
    }
  }

  bool _shouldShowPromoNow(PromoHiveModel promo) {
    try {
      /// 👇 Parse string to DateTime
      final start = DateTime.parse(promo.startDate);
      final end = DateTime.parse(promo.endDate);

      final isFirstTime = promo.lastShownAt.trim().isEmpty;
      final lastShown = promo.lastShownAt.isNotEmpty
          ? DateTime.parse(promo.lastShownAt)
          : DateTime.fromMillisecondsSinceEpoch(0);

      final minutesSinceLast = DateTime.now().difference(lastShown).inMinutes;

      return promo.shouldDisplay &&
          DateTime.now().isAfter(start) &&
          DateTime.now().isBefore(end) &&
          promo.maxDisplayCount > 0 &&
          (isFirstTime || minutesSinceLast >= promo.displayFrequency);
    } catch (e) {
      print("Promo check failed: $e");
      return false;
    }
  }
}
