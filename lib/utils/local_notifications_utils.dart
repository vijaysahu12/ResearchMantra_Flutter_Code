
import 'dart:typed_data';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:research_mantra_official/data/network/http_client.dart';
import 'package:research_mantra_official/main.dart';

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final StreamController<ReceivedNotification> didReceiveLocalNotificationStream =
    StreamController<ReceivedNotification>.broadcast();

final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();

const String navigationActionId = 'id_3';

final HttpClient _httpClient = getIt<HttpClient>();
// Service class for handling local notifications
// Create an instance of FlutterLocalNotificationsPlugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class LocalNotificationService {
  // Initialize the local notification service
  static Future initialize() async {
    // Request notification permissions for Android
    await Future.delayed(const Duration(seconds: 1));
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    // Request notification permissions for iOS
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    // Configure Android initialization settings for the local notifications
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      // onDidReceiveLocalNotification:
      //     (int id, String? title, String? body, String? payload) async {}
    );

    // Create InitializationSettings for the local notifications
    InitializationSettings initializationSettings = InitializationSettings(
        iOS: initializationSettingsIOS, android: androidInitializationSettings);

    @pragma('vm:entry-point')
    Future<dynamic> onSelectNotification(
        NotificationResponse notificationResponse) async {
      print("----notificationResponse$notificationResponse");
      // implement the navigation logic
    }

    @pragma('vm:entry-point')
    void notificationTapBackground(NotificationResponse notificationResponse) {
      // ignore: avoid_print

      print('notification(${notificationResponse.id}) action tapped: '
          '${notificationResponse.actionId} with'
          ' payload: ${notificationResponse.payload}');
      if (notificationResponse.input?.isNotEmpty ?? false) {
        // ignore: avoid_print
        print(
            'notification action tapped with input: ${notificationResponse.input}');
      }
    }

    // Initialize the FlutterLocalNotificationsPlugin with the settings
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            selectNotificationStream.add(notificationResponse.payload);
            break;
          case NotificationResponseType.selectedNotificationAction:
            if (notificationResponse.actionId == navigationActionId) {
              selectNotificationStream.add(notificationResponse.payload);
            }
            break;
        }
      },
      // onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  // Show a local notification based on the received RemoteMessage
  static Future showNotification(
    RemoteMessage message,
  ) async {
    try {
      print("__________________${message.data}");
      String? imageUrl = message.data['NotificationImage'];

      Uint8List? bytes;
      if (imageUrl != null && imageUrl.isNotEmpty) {
        final http.Response response = await http.get(Uri.parse(imageUrl));

        if (response.statusCode == 200) {
          bytes = response.bodyBytes;
        } else {
          print("Failed to download image: ${response.statusCode}");
        }
      }

      // Resize image if available
      String? base64Image;
      if (bytes != null) {
        final img.Image? originalImage = img.decodeImage(bytes);
        if (originalImage != null) {
          final img.Image resizedImage = img.copyResize(originalImage,
              maintainAspect: true, width: 400, height: 200);
          final List<int> resizedBytes =
              img.encodeJpg(resizedImage, quality: 85);
          base64Image = base64Encode(resizedBytes);
        } else {
          print("Failed to decode image");
        }
      }

//Added custom sound for notification
      const DarwinNotificationDetails iOSPlatformChannelSpecifics =
          DarwinNotificationDetails(
              presentSound: true,
              presentAlert: true,
              presentBadge: true,

              // threadIdentifier: 'thread_id',
              sound: 'notification_tone.wav');

// Define Android notification details
      AndroidNotificationDetails androidDetails;

      if (base64Image != null) {
        // Case when image is available
        androidDetails = AndroidNotificationDetails(
          "researchmantraofficial",
          "researchmantraofficial",
          enableLights: true,
          enableVibration: true,
          priority: Priority.high,
          importance: Importance.max,
          styleInformation: BigPictureStyleInformation(
            ByteArrayAndroidBitmap.fromBase64String(base64Image),
            //  htmlFormatContent: true,
            htmlFormatTitle: true,
          ),
          sound: RawResourceAndroidNotificationSound("notification_tone"),
        );
      } else {
        // Case when image is missing
        androidDetails = AndroidNotificationDetails(
          "researchmantraofficial",
          "researchmantraofficial",
          enableLights: true,
          enableVibration: true,
          priority: Priority.high,
          importance: Importance.max,
          styleInformation: BigTextStyleInformation(
            message.notification?.body ?? "",
            htmlFormatContent: true,
            //  htmlFormatBigText: true
            // htmlFormatTitle: true,
          ),
          //  DefaultStyleInformation(true, true),
          sound: RawResourceAndroidNotificationSound("notification_tone"),
        );
      }

      // Use a 32-bit integer id for the notification
      int notificationId = message.notification.hashCode.abs() & 0x7FFFFFFF;

      // Show the local notification using FlutterLocalNotificationsPlugin


      await flutterLocalNotificationsPlugin.show(
          notificationId,
          message.notification?.title ?? "Embrace the Journey!",
          message.notification?.body ??
              "Every day is a new opportunity to learn, grow, and achieve. Stay focused and keep moving forward!",
          NotificationDetails(
            android: androidDetails,
            iOS: iOSPlatformChannelSpecifics,
          ),
          payload: jsonEncode(message.data));

      // await _httpClient.postOthers(
      //     "$other?message=Notification Received  ${message.data.toString()} at ${DateTime.now()}");
    } catch (e) {
      print(e.toString());
    }
  }
}
