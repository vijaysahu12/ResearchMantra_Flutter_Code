import 'package:no_screenshot/no_screenshot.dart';

class NoScreenshotUtil {
  final NoScreenshot _noScreenshot = NoScreenshot.instance;

  /// Disables screenshot functionality and stops screenshot listening
  Future<void> disableScreenshots() async {
    try {
      await _noScreenshot.screenshotOff();
      await _noScreenshot.stopScreenshotListening();
    } catch (e) {
      print('Error disabling screenshots: $e');
    }
  }

  /// Enables screenshot functionality and starts screenshot listening
  Future<void> enableScreenshots() async {
    try {
      await _noScreenshot.screenshotOn();
      await _noScreenshot.startScreenshotListening();
    } catch (e) {
      print('Error enabling screenshots: $e');
    }
  }
}
