import 'dart:async';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:hive/hive.dart';
import 'package:research_mantra_official/data/models/hive_model/promo_hive_model.dart';
import 'package:research_mantra_official/providers/promo_advertisement/promo_advertisement_provider.dart';
import 'package:research_mantra_official/services/hive_service.dart';
import 'package:research_mantra_official/services/secure_storage.dart';
import 'package:research_mantra_official/ui/components/dynamic_promo_card/service/promo_manager.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:research_mantra_official/constants/assets.dart';
import 'package:research_mantra_official/constants/storage.dart';
import 'package:research_mantra_official/data/models/dashboard/dashboard_slider_model.dart';
import 'package:research_mantra_official/ui/screens/profile/widgets/extra_adds.dart';
import 'package:research_mantra_official/ui/screens/profile/widgets/full_screen_image_dialog.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

class Utils {
  int maxImageLimit = 3;
  static String formatDateTime(
      {required String dateTimeString, required String format}) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    String formattedDate = DateFormat.d().format(dateTime);
    String month =
        DateFormat.MMM().format(dateTime); // Full month name (e.g., July)

    String formattedTime = DateFormat.Hm().format(dateTime);
    String formatYear = DateFormat.y().format(dateTime);

    String dateInString = "";
    switch (format) {
      case mmddyy:
        dateInString = '${dateTime.month}/$formattedDate/$formatYear ';
        break;

      case mmddyyyy:
        dateInString = '$month $formattedDate, $formatYear ';
        break;
      case ddmmyy:
        dateInString = '$formattedDate $month $formatYear ';
        break;
      case ddmmtt:
        dateInString = '$formattedDate $month $formatYear , $formattedTime ';
        break;
      case yyyymmdd:
        dateInString = '$formatYear-${dateTime.month}-$formattedDate ';

      default:
        dateInString = '$formattedDate $month $formatYear ';
    }

    return dateInString;
  }

  static Color matchPriorityColor(String priority) {
    switch (priority) {
      case "M":
        return Colors.orange;
      case "H":
        return Colors.red;

      default:
        return Colors.green;
    }
  }

  static bool isWithin30MinutesDifference(
      {required String dateTimeString,
      required String publicKeyData,
      required String publicKey}) {
    if (publicKey != publicKeyData) {
      return false;
    }

    DateTime dateTime = DateTime.parse(dateTimeString);

    DateTime now = DateTime.now(); // Current date and time

    // Calculate the difference in milliseconds
    Duration difference = now.difference(dateTime).abs();

    // Convert milliseconds to minutes
    double differenceInMinutes = difference.inMilliseconds / (1000.0 * 60.0);

    // Check if the difference is less than 30 minutes
    return differenceInMinutes < 30;
  }

  static Widget buildAdvertisementSection(
    BuildContext context,
    List<CommonImagesResponseModel> images,
    dynamic error,
    bool isLoading,
  ) {
    // Check for error or loading state first

    if (error != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.asset(
          profileScreenDefaultImage,
          fit: BoxFit.fitHeight,
          width: double.infinity,
        ),
      );
    } else if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Handle the expiration logic
    final expireOnStr = images.isNotEmpty ? images[0].expireOn : null;

    final DateTime? expireOn =
        expireOnStr != null ? DateTime.parse(expireOnStr) : null;

    final bool isExpired =
        expireOn != null ? DateTime.now().isAfter(expireOn) : false;

    // If the image is expired or the list is empty after loading, show the default image
    if (isExpired || images.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.asset(
          profileScreenDefaultImage,
          fit: BoxFit.fitHeight,
          width: double.infinity,
        ),
      );
    }

    // Show the image if available and not expired
    return GestureDetector(
      onTap: () {},
      child: ExtraAddsWidget(
        getProfileScreenImages: images,
      ),
    );
  }

  static void showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Camera Permission Required'),
        content: const Text(
            'To pick an image, the app needs access to your camera. Please grant camera permissions in the app settings.'),
        actions: <Widget>[
          TextButton(
            child: const Text('Open Settings'),
            onPressed: () {
              // Open app settings
              openAppSettings();
            },
          ),
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  // Check and request camera permissions.
  static Future<bool> checkAndRequestCameraPermissions() async {
    PermissionStatus status = await Permission.camera.status;

    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      // Show dialog directly
      return false;
    }

    // Request permission
    PermissionStatus newStatus = await Permission.camera.request();
    return newStatus.isGranted;
  }

  static Future<Map<String, dynamic>?> pickImageFromCamera(
      BuildContext context) async {
    final picker = ImagePicker();
    try {
      bool cameraPermissionGranted = await checkAndRequestCameraPermissions();

      if (!cameraPermissionGranted) {
        final status = await Permission.camera.status;
        if (status.isPermanentlyDenied || status.isDenied) {
          showPermissionDeniedDialog(context);
        }
      }

      if (cameraPermissionGranted) {
        final pickedImage = await picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 50,
        );

        if (pickedImage != null) {
          File imageFile = File(pickedImage.path);
          double fileSizeInMb = imageFile.lengthSync() / (1024 * 1024);

          if (fileSizeInMb > 3) {
            ToastUtils.showToast("Image size exceeds 3MB limit", "");
            return null;
          }

          CroppedFile? croppedFile = await ImageCropper().cropImage(
            sourcePath: pickedImage.path,
            uiSettings: [
              AndroidUiSettings(
                toolbarTitle: 'Edit',
                backgroundColor: Colors.transparent,
                hideBottomControls: false,
                lockAspectRatio: false, // Allow all sizes
              ),
              IOSUiSettings(
                title: 'Edit Image',
                aspectRatioLockEnabled: false, // Allow all sizes
              ),
              WebUiSettings(
                context: context,
              ),
            ],
          );

          if (croppedFile != null) {
            final xFile = XFile(croppedFile.path);

            // Get cropped image info
            final croppedImageInfo = await getImageInfo(croppedFile.path);

            return {
              'file': xFile,
              'aspectRatioLabel': croppedImageInfo['aspectRatioLabel'],
            };
          }
        } else {
          ToastUtils.showToast("No image was selected", "");
        }
      } else {
        if (await Permission.camera.status == PermissionStatus.denied) {
          showPermissionDeniedDialog(context);
        }
      }
    } catch (e) {
      print("Error picking image from camera: $e");
    }
    return null;
  }

  //pick image from gallery
  static Future<Map<String, dynamic>?> pickImageFromGallery(
      BuildContext context) async {
    final picker = ImagePicker();
    try {
      bool galleryPermissionGranted = await checkAndRequestCameraPermissions();

      if (!galleryPermissionGranted) {
        if (Platform.isAndroid &&
            (await Permission.storage.status).isPermanentlyDenied) {
          showPermissionDeniedDialog(context);
        } else if (Platform.isIOS &&
            (await Permission.photos.status).isPermanentlyDenied) {
          showPermissionDeniedDialog(context);
        }
      }

      if (galleryPermissionGranted) {
        final pickedImage = await picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 50,
        );

        if (pickedImage != null) {
          File imageFile = File(pickedImage.path);
          double fileSizeInMb = imageFile.lengthSync() / (1024 * 1024);

          if (fileSizeInMb > 3) {
            ToastUtils.showToast("Image size exceeds 3MB limit", "");
            return null;
          }

          // Get original image info before cropping

          CroppedFile? croppedFile = await ImageCropper().cropImage(
            sourcePath: pickedImage.path,
            uiSettings: [
              AndroidUiSettings(
                toolbarTitle: 'Edit',
                toolbarColor: Theme.of(context).primaryColor,
                toolbarWidgetColor: Theme.of(context).primaryColorDark,
                backgroundColor: Theme.of(context).primaryColor,
                hideBottomControls: false,
                lockAspectRatio: false, // Allow all sizes
              ),
              IOSUiSettings(
                title: 'Edit Image',
                aspectRatioLockEnabled: false, // Allow all sizes
              ),
              WebUiSettings(
                context: context,
              ),
            ],
          );

          if (croppedFile != null) {
            final xFile = XFile(croppedFile.path);

            // Get cropped image info
            final croppedImageInfo = await getImageInfo(croppedFile.path);

            return {
              'file': xFile,
              'aspectRatioLabel': croppedImageInfo['aspectRatioLabel'],
            };
          }
        }
      } else {
        if (await Permission.storage.status == PermissionStatus.denied ||
            await Permission.photos.status == PermissionStatus.denied) {
          showPermissionDeniedDialog(context);
        }
      }
    } catch (e) {
      print("Error picking image from gallery: $e");
    }
    return null;
  }

  // Helper function to determine aspect ratio label from width/height
  static String getAspectRatioLabel(double width, double height) {
    final ratio = width / height;

    // For uncommon aspect ratios, return the numeric value
    return ratio.toStringAsFixed(2);
  }

  // Get image dimensions and aspect ratio from file
  static Future<Map<String, dynamic>> getImageInfo(String imagePath) async {
    final File imageFile = File(imagePath);
    final Uint8List bytes = await imageFile.readAsBytes();
    final decodedImage = await decodeImageFromList(bytes);

    final width = decodedImage.width;
    final height = decodedImage.height;
    final ratio = width / height;
    final label = getAspectRatioLabel(width.toDouble(), height.toDouble());

    return {
      'width': width,
      'height': height,
      'aspectRatio': ratio,
      'aspectRatioLabel': label,
    };
  }

  static double parseAspectRatio(String aspectRatio) {
    // Split the string by '/'
    List<String> parts = aspectRatio.split('/');
    if (parts.length == 2) {
      double numerator = double.parse(parts[0]);
      double denominator = double.parse(parts[1]);
      return numerator / denominator; // Return the aspect ratio as a double
    }
    return 1.0; // Default aspect ratio if parsing fails
  }

  static void showFullScreenImage(BuildContext context,
      ImageProvider imageProvider, Uint8List? uint8Listtype) {
    Navigator.of(context).push(MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return FullScreenImageDialog(
            imageProvider: imageProvider,
            imageUrl: "fhjkfhjkdj",
          );
        },
        fullscreenDialog: true));
  }

  static Color hexToColor(String hex) {
    // Remove the leading '#' if it's present
    hex = hex.replaceAll('#', '');

    // If the hex is 6 characters, add 'FF' (fully opaque) as the alpha channel
    if (hex.length == 6) {
      hex = 'FF$hex'; // Adding default alpha value (FF = 255 = fully opaque)
    }

    // Convert the hex string to an integer and return as a Color object
    return Color(int.parse('0x$hex'));
  }

  // Format number with commas and handle decimals
  static String formatNumber(double? number) {
    if (number == null) return 'N/A';
    final formatter = NumberFormat('#,##0.00', 'en_US'); // Use a custom pattern
    return formatter.format(number);
  }

  // Parse the string number (removes commas) and return as double
  static double? parseNumber(String? str) {
    if (str == null || str.isEmpty) return null;
    // Remove commas and attempt to parse the string into a double
    final sanitizedStr = str.replaceAll(',', '');
    return double.tryParse(sanitizedStr);
  }

  // Determine the color based on the number (positive = green, negative = red)
  static Color textColor(double? number, BuildContext context) {
    if (number == null) {
      return Theme.of(context).primaryColorDark; // Default color
    }
    return number < 0
        ? Theme.of(context).disabledColor
        : Theme.of(context).secondaryHeaderColor;
  }

  static String durationConverter(int seconds) {
    int second = seconds * 1;
    int hours = seconds ~/ 3600; // Convert to hours
    int minutes =
        (seconds % 3600) ~/ 60; // Convert remaining seconds to minutes

    if (hours > 0) {
      return '${hours}Hr ${minutes}Min';
    } else if (minutes < 1) {
      return '${second}Sec';
    } else {
      return '${minutes}Min';
    }
  }

  static String formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  // number formatter to K,Lakhs,Crores
  static String formatValue(dynamic value) {
    if (value is String) {
      value = value.trim().replaceAll(",", ""); // Remove commas and trim spaces
      if (value.isEmpty) return "0.00"; // Handle empty strings
      value = double.tryParse(value); // Convert to double
    }

    if (value == null || value is! num) {
      return "0.00"; // Return default value if parsing fails
    }

    bool isNegative = value < 0; // Check if the value is negative
    value = value.abs(); // Use absolute value for formatting

    String formattedValue;
    if (value >= 10000000) {
      formattedValue = '${(value / 10000000).toStringAsFixed(2)} Cr'; // Crores
    } else if (value >= 100000) {
      formattedValue = '${(value / 100000).toStringAsFixed(2)} L'; // Lakhs
    } else if (value >= 1000) {
      formattedValue = '${(value / 1000).toStringAsFixed(2)} K'; // Thousands
    } else {
      formattedValue = value.toStringAsFixed(2);
    }

    return isNegative ? '-$formattedValue' : formattedValue;
  }
}

//Platform check
bool isGetIOSPlatform() {
  return Platform.isIOS || Platform.isMacOS;
}

//Like formater converting to K
String formatLikesCount(int likesCount) {
  if (likesCount < 1000) {
    return likesCount.toString();
  } else if (likesCount < 10000) {
    final double thousands = likesCount / 1000;
    if (thousands % 1 >= 0.5) {
      return '${(thousands + 0.1).toStringAsFixed(1)}k';
    } else {
      return '${thousands.toStringAsFixed(1)}k';
    }
  } else if (likesCount < 1000000) {
    final double thousands = likesCount / 1000;
    return '${(thousands.toStringAsFixed(0))}k';
  } else if (likesCount < 10000000) {
    final double millions = likesCount / 1000000;
    if (millions % 1 >= 0.5) {
      return '${(millions + 0.1).toStringAsFixed(1)}m';
    } else {
      return '${millions.toStringAsFixed(1)}m';
    }
  } else {
    final double millions = likesCount / 1000000;
    return '${millions.toStringAsFixed(0)}m';
  }
}

//Share multiple images with text
Future<void> shareMultipleImagesWithText(String content, imageUrls) async {
  const String brandingText = '''
📢 Post shared from King Research Academy.
📲 Download app now 👇
 https://www.kingresearch.co.in/app/
''';
  final String finalShareText =
      '$brandingText \n$content\n\n #StockMarket #TradingTips #KingResearchAcademy #InvestSmart #MarketInsights #FinanceApp';
  try {
    final tempDir = await getTemporaryDirectory();
    List<XFile> imageFiles = [];

    for (int i = 0; i < imageUrls.length; i++) {
      final response = await http.get(Uri.parse(imageUrls[i]));
      if (response.statusCode == 200) {
        final file = File('${tempDir.path}/shared_image_$i.jpg');
        await file.writeAsBytes(response.bodyBytes);
        imageFiles.add(XFile(file.path));
      }
    }

    if (imageFiles.isNotEmpty) {
      await Share.shareXFiles(
        imageFiles,
        text: finalShareText,
      );
    } else {
      await Share.share(finalShareText); // fallback to text only
    }
  } catch (e) {
    print('Sharing error: $e');
    await Share.share(finalShareText); // fallback on error
  }
}

Future<void> downloadAndShareFile(String url,
    {required String fileName}) async {
  try {
    // Download PDF file
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // Get device temp directory
      final tempDir = await getTemporaryDirectory();
      final filePath = path.join(tempDir.path, fileName);

      // Write bytes to file
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      // Share file
      await Share.shareXFiles([XFile(filePath)], text: fileName);
    } else {
      debugPrint('Download failed with status: ${response.statusCode}');
    }
  } catch (e) {
    debugPrint('Error downloading or sharing file: $e');
  }
}

//Function to get Device type
Future<String?> getDevice() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  try {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print("--------- ${androidInfo.device}");
      return 'Android: ${androidInfo.device}';
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return 'IOS & IosId: ${iosInfo.identifierForVendor}';
    }
  } catch (e) {
    print('Error getting device info: $e');
    return null;
  }
  return null;
}

final HiveServiceStorage hiveServiceStorage = HiveServiceStorage();
final SharedPref pref = SharedPref();
Future<void> handleFirebaseValueChanged({ref, context}) async {
  if (!context.mounted) return;

  final box = Hive.box<PromoHiveModel>('promos');
  await box.clear();

  print("🔥 Firebase value changed → true, showing promo...");
  if (!context.mounted) return;
  await ref.read(promoStateNotifierProvider.notifier).fetchPromos();
  await Future.delayed(const Duration(milliseconds: 500));

  final promoData = ref.read(promoStateNotifierProvider);
  hiveServiceStorage.savePromos(promoData.promos);

  await Future.delayed(const Duration(milliseconds: 300));
  if (!context.mounted) return;
  await PromoManager().tryShowPromo(context);
  print("🔥 PromoManager showed promo...");
}
