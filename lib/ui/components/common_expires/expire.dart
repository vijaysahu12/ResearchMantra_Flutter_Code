// lib/utils/expiration_utils.dart
class ExpirationUtils {
  static List<dynamic> filterExpiredImages(List<dynamic> imagesList) {
    return imagesList.where((image) {
      final String? expireOnStr = image['expireOn'];
      if (expireOnStr != null && expireOnStr.isNotEmpty) {
        try {
          final DateTime expireOn = DateTime.parse(expireOnStr);
          return DateTime.now()
              .isBefore(expireOn); // Only keep non-expired images
        } catch (e) {
          // If parsing fails, treat the image as non-expired
          print('Invalid date format: $expireOnStr');
          return true;
        }
      }
      // If expireOn is null or empty, the image does not expire
      return true;
    }).toList();
  }
}
