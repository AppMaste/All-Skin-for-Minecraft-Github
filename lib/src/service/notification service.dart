// ignore_for_file: invalid_use_of_protected_member, deprecated_member_use

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../main.dart';

class NotificationService {
  static final NotificationService _notificationService =
  NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  Future<void> initNotification() async {
    // Android initialization
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // ios initialization
    // const IOSInitializationSettings initializationSettingsIOS =
    // IOSInitializationSettings(
    //   requestAlertPermission: false,
    //   requestBadgePermission: false,
    //   requestSoundPermission: false,
    // );

    const InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,);
    // the initialization settings are initialized after they are setted
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future showNotification(int id, String title, String body) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.now(tz.local).add(
        Duration(minutes: minecraftData.value["minecraft-messageTime"]),
      ),
      const NotificationDetails(
        // Android details
        android: AndroidNotificationDetails(
            'main_channel', 'Main Channel',
            importance: Importance.max, priority: Priority.max),
        // iOS details
      ),

      // Type of time interpretation
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle:
      true, // To show notification even when the app is closed
    );
  }
}
AndroidNotificationChannel channel = const AndroidNotificationChannel(
    "Hello!!", "All Skin for MineCraft",
    importance: Importance.high, playSound: true);
Future<void> firebasemessgingBackgroundMessagingHandler(
    RemoteMessage message) async {
  await Firebase.initializeApp();
  print("A bg message just showed up : ${message.messageId}");
}


