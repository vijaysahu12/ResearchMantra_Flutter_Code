import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:research_mantra_official/services/notification_navigation.dart';
import 'package:research_mantra_official/services/secure_storage.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/ui/components/king_research_loader/kingresearch_loader.dart';
import 'package:research_mantra_official/ui/screens/home/home_navigator.dart';
import 'package:research_mantra_official/utils/local_notifications_utils.dart';

SecureStorage secureStorage = getIt<SecureStorage>();

int? _lastHandledTimestamp;
bool _isFirstNotificationHandled = false;

// Utility class for managing Firebase Cloud Messaging (FCM) notifications
class FirebaseNotificationsUtils {
  // Initialize FirebaseMessaging instance
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  // Retrieve the FCM token asynchronously
  static Future<String?> getToken() async {
    await FirebaseMessaging.instance.deleteToken();
    try {
      print("------------Able o print ${await _firebaseMessaging.getToken()}");
      return await _firebaseMessaging.getToken();
    } catch (e) {
      print(
          'Error: Too many registration attempts. Please try again later. $e');

      return "NO_FCM_TOKEN"; // Or return an appropriate default token or handle as needed
    }
  }

  // Configure Firebase Cloud Messaging
  static Future<void> configureFirebaseMessaging() async {
    final messaging = FirebaseMessaging.instance;

    // Request permissions
    final settings = await messaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('🔐 Notification permission granted');

      if (Platform.isIOS) {
        String? apnsToken = await messaging.getAPNSToken();

        if (apnsToken != null) {
          print('📲 APNs Token got successful');
        } else {
          print('⚠️ APNs token not available after retrying.');
          
        }
      }
          

      // Now get FCM token (safe even on Android)
      String? fcmToken = await messaging.getToken();
      if (fcmToken != null) {
        print('📡 FCM Token got successful');
        // Optionally save to backend or local storage
      } else {
        print('⚠️ FCM token not available');
      }
    } else {
      print('🚫 Notification permission denied or not determined');
    }

    // Attach lifecycle observer
    WidgetsBinding.instance.addObserver(_AppLifecycleObserver());

    // Initialize local notifications
    LocalNotificationService.initialize();

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.data['trigger_promo'] == 'true') {
        final context = navigatorKey.currentContext;
        if (context != null) {
          // ref.read(promoControllerProvider.notifier).fetchPromoAndShow(context);
        }
        return; // Do not proceed to show notification
      }
      if (message.notification != null && message.data.isNotEmpty) {

        LocalNotificationService.showNotification(message);
      }
    });

    // Background opened messages
    FirebaseMessaging.onMessageOpenedApp.listen(handleNotification);

    // App launch via notification
    final initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      handleNotification(initialMessage);
    }
  }

  // Function to delete the FCM instance ID
  static Future<void> deleteInstanceID() async {
    try {
      // Resets Instance ID and revokes all tokens.
      await _firebaseMessaging.deleteToken();

      print('FCM Instance ID deleted');
    } catch (e) {
      print('Error deleting FCM Instance ID: $e');
    }
  }
}

void handleNotification(RemoteMessage? message) async {
  if (message == null) return;

  // ✅ Promo trigger patch
  // if (message.data['trigger_promo'] == 'true') {
  //   final context = navigatorKey.currentContext;
  //   if (context != null) {
  //     //  ref.read(promoControllerProvider.notifier).fetchPromoAndShow(context);
  //   }
  //   return; // Stop further navigation
  // }

  // Add delay only for the first notification after app start
  if (!_isFirstNotificationHandled) {
    await Future.delayed(Duration(seconds: 3));
    _isFirstNotificationHandled = true; // Mark first notification as handled
  }

  // Get the timestamp of the current notification (or use messageId if available)
  int currentTimestamp = DateTime.now().millisecondsSinceEpoch;

  // Ensure a gap of at least 1 second before handling a new notification
  if (_lastHandledTimestamp != null &&
      (currentTimestamp - _lastHandledTimestamp!) < 1000) {
    return;
  }

  _lastHandledTimestamp = currentTimestamp; // Update last handled time

  String? scannerFlag = message.data["Scanner"]?.toString().toLowerCase();
  String? screenName = message.data["ScreenName"]?.toString();
  String? productId = message.data["ProductId"]?.toString();
  String? productName = message.data["ProductName"]?.toString();
  // Show loader first (waits 3 seconds then auto-pops)

  if (scannerFlag == "true") {
    navigateToTradingNotificationsScreen(message.data);
  } else if (screenName != null && screenName.isNotEmpty && productId != null) {
    navigateToNotificationsScreen(screenName, productId, productName);
  } else {
    navigateToNotificationsScreen(screenName, "", '');
  }
}

//Navigate to the notification Screen
void navigateToNotificationsScreen(
    String? screenName, String? id, String? productName) async {
  // Call the navigate function from the helper
  final context = navigatorKey.currentContext;

  if (context == null) {
    print("Navigation aborted: context is null");
    return;
  }
  await showFullScreenLoader(context);
  navigateToSpecificName(
      screenName ?? '',
      id ?? '',
      productName ?? '',
      navigatorKey, // Pass the navigator key
      true);
}

//Navigate to the notification Screen
void navigateToTradingNotificationsScreen(details) {
  navigatorKey.currentState?.push(MaterialPageRoute(
    builder: (context) => HomeNavigatorWidget(
      initialIndex: 4,
      topicName: details['Topic'] ?? 'BREAKFAST',
    ),
  ));
}

// AppLifecycleObserver to track app lifecycle changes
class _AppLifecycleObserver with WidgetsBindingObserver {
  bool isAppInForeground = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      isAppInForeground = true;
    } else {
      isAppInForeground = false;
    }
  }
}

Future<void> showFullScreenLoader(context) async {
  if (context == null) return;
  final theme = Theme.of(context);

  Navigator.of(context).push(
    PageRouteBuilder(
      // opaque: false,
      pageBuilder: (_, __, ___) => Scaffold(
        backgroundColor: theme.primaryColor,
        body: CommonLoaderGif(),
      ),
    ),
  );

  // Wait 3 seconds
  await Future.delayed(Duration(seconds: 2));
  // Pop the loader
  Navigator.of(context).pop();
}
