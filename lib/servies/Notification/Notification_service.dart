import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:app_settings/app_settings.dart';
import '../../main.dart';
import '../../screen/Bottom nav screens/home_screen.dart';

class NotificationService {
  static final FirebaseMessaging messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      badge: true,
      alert: true,
      announcement: true,
      carPlay: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Notification permission granted');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('Notification permission provisionally granted');
    } else {
      print('Notification permission denied — opening settings');
      AppSettings.openAppSettings(type: AppSettingsType.notification);
    }
  }

  static Future<void> initialize() async {
    const AndroidInitializationSettings androidSetting =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSetting = DarwinInitializationSettings();

    final initializationSettings = InitializationSettings(
      android: androidSetting,
      iOS: iosSetting,
    );

    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final payload = response.payload;
        print('Notification tapped with payload: $payload');

        if (payload == 'home') {
          navigatorKey.currentState?.pushReplacement(
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else {
          print('Unknown payload, navigating to HomeScreen by default');
          navigatorKey.currentState?.pushReplacement(
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        }
      },
    );
  }

  void firebaseInit() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground message received!');
      print('Title: ${message.notification?.title}');
      print('Body: ${message.notification?.body}');

      showMessage(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification clicked from background');
      navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  void showMessage(RemoteMessage message) {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(10000).toString(),
      'High Importance Channel',
      importance: Importance.max,
    );

    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: 'Channel for important messages',
      importance: Importance.high,
      priority: Priority.max,
      ticker: 'ticker',
    );

    DarwinNotificationDetails iosDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentSound: true,
      presentBadge: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    Future.delayed(Duration.zero, () {
      notificationsPlugin.show(
        0,
        message.notification?.title ?? 'No Title',
        message.notification?.body ?? 'No Body',
        notificationDetails,
        payload: 'home',
      );
      print('Local notification displayed successfully');
    });
  }
}
