import 'package:research_mantra_official/constants/env_config.dart';
import 'package:http/http.dart' as http;

class CommonImagesChecker {
  Future<List<String>> filterAvailableImages(List<dynamic> images) async {
    List<String> availableImages = [];

    for (var image in images) {
      String imagePath = image['name'];
      try {
        // Send a HEAD request to check if the image exists
        final response = await http.get(
          Uri.parse('$profileScreenAdvertisementImageUrl/$imagePath'),
        );

        // Check if the image exists
        if (response.statusCode == 200) {
          availableImages.add(imagePath); // Image exists, add to available list
        }
      } catch (e) {
        // Handle error (e.g., network issues, timeout)
        print('Error checking image $imagePath: $e');
        continue; // Skip to the next image
      }
    }

    return availableImages;
  }

  //Image checker for single image
  Future<bool> doesImageExist(String imageName, String imageType) async {
    try {
      // Send a GET request to check if the image exists
      final response =
          await http.get(Uri.parse('$imageType?imageName=$imageName'));
      // Return true if the image exists (status code 200)
      return response.statusCode == 200;
    } catch (e) {
      // Handle error (e.g., network issues, timeout)
      print('Error checking image $imageName: $e');
      return false; // Return false in case of an error
    }
  }
}
