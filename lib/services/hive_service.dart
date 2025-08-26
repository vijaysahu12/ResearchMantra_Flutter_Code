import 'package:hive_flutter/hive_flutter.dart';
import 'package:research_mantra_official/data/models/dynamic_bottom_sheet/dynamic_promo_model.dart';
import 'package:research_mantra_official/data/models/hive_model/blog_hive_model.dart';
import 'package:research_mantra_official/data/models/hive_model/product_hive_model.dart';
import 'package:research_mantra_official/data/models/hive_model/promo_hive_model.dart';


class HiveServiceStorage {
  final Box<ProductHiveModel> _productBox =
      Hive.box<ProductHiveModel>('productsBox');
  final Box<BlogsHiveModel> _blogsBox = Hive.box<BlogsHiveModel>('blogPost');
  final Box<PromoHiveModel> _promos = Hive.box<PromoHiveModel>('promos');

  void addInHive(ProductHiveModel productHiveModel) {
    _productBox.put(productHiveModel.id, productHiveModel);
  }

  void addBlogPostInHive(BlogsHiveModel blogsHiveModel) {
    _blogsBox.put(blogsHiveModel.objectId, blogsHiveModel);
  }

  List<ProductHiveModel> getAllData() {
    return _productBox.values.toList();
  }

  List<BlogsHiveModel> getAllBlogsData() {
    return _blogsBox.values.toList();
  }

  void deleteAllHiveData() {
    _productBox.clear();
  }

  void deleteAllBlogsHiveData() {
    _blogsBox.clear();
  }

  // Method to save multiple promos to Hive
  Future<void> savePromos(List<PromoModel> promos) async {
    final box = Hive.box<PromoHiveModel>('promos');
    await box.clear(); // Optional: clear old promos

    for (var promo in promos) {
      final hiveModel = promo.toHiveModel();
      await box.put(promo.id, hiveModel); // ✅ Use promo.id as the key
    }
  }

  // Method to get all promos from Hive
  Future<void> deleteAllBoxsHiveData() async {
    await _productBox.clear();
    await _blogsBox.clear();
    await _promos.clear();
    print("All Hive boxes cleared.");
  }
}

// Extension to convert PromoModel to PromoHiveModel

extension PromoModelMapper on PromoModel {
  PromoHiveModel toHiveModel() {
    return PromoHiveModel(
      id: id,
      mediaType: mediaType,
      shouldDisplay: shouldDisplay,
      maxDisplayCount: maxDisplayCount,
      displayFrequency: displayFrequency,
      lastShownAt: lastShownAt,
      globalButtonAction: globalButtonAction,
      target: target,
      productName: productName,
      productId: productId,
      startDate: startDate,
      endDate: endDate,
      mediaItems: mediaItems
          .map(
            (mediaItem) => MediaHiveItem(
              mediaUrl: mediaItem.mediaUrl,
              buttons: mediaItem.buttons
                  .map(
                    (btn) => ButtonHiveModel(
                      buttonName: btn.buttonName,
                      actionUrl: btn.actionUrl,
                      productId: btn.productId,
                      productName: btn.productName,
                    ),
                  )
                  .toList(),
            ),
          )
          .toList(),
    );
  }
}
