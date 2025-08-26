import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:research_mantra_official/data/models/dashboard/dashboard_slider_model.dart';
import 'package:path_provider/path_provider.dart';

class ImageStorageLocally {
  // Method to download and save the image
  Future<String?> downloadAndSaveImage(String url, String fileName) async {
    try {
      final response = await http.get(Uri.parse(
          'http://testmobileapi.kingresearch.co.in/api/Product/GetImage?imageName=$url'));
      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = '${directory.path}/$fileName';
        final file = File(imagePath);
        await file.writeAsBytes(response.bodyBytes);
        print('all imae paths $imagePath');
        return imagePath;
      } else {
        throw Exception("Failed to download image");
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<String>> downloadAndSaveTheImageList(
      List<DashBoardTopImagesModel> imageList) async {
    List<String> downloadedPaths = [];
    for (var image in imageList) {
      String fileName;
      if (image.type!.trim().toLowerCase() == 'scanner') {
        fileName = 'Scanner_image_${image.id}';
      } else if (image.type!.trim().toLowerCase() == 'strategies') {
        fileName = 'Strategies_image_${image.id}';
      } else {
        fileName = 'image_${image.id}'; // Default case if type is unknown
      }
      final path = await downloadAndSaveImage(image.listImage!, fileName);
      if (path != null) {
        downloadedPaths.add(path);
      }
    }
    return downloadedPaths;
  }

  // Method to get local image paths based on type
  Future<List<String>> getLocalImagePathsByType(String type) async {
    final directory = await getApplicationDocumentsDirectory();
    final files = directory.listSync();
    final imagePaths = files
        .where((file) => file is File && file.path.contains(type.toLowerCase()))
        .map((file) => file.path)
        .toList();
    return imagePaths;
  }
}
