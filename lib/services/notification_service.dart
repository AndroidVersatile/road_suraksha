import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../constants/app_cache.dart';


const appUpdate = 'appUpdate';
const helloTopic = 'HelloTopics';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();
  late NotificationDetails platformChannelSpecifics;
  FlutterLocalNotificationsPlugin? notificationManager;
  late String fcmToken = '';
  final AppCache _cache = AppCache();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal() {
    _initLocalNotifications();
    initFirebaseMessaging();
    subscribeInAppMessagingTopic(topic: helloTopic);
  }

  initFirebaseMessaging() async {
    FirebaseMessaging.onMessage.listen((event) {
      if (event.notification != null) {
        showPlainNotification(
            event.notification!.title ?? '', event.notification!.body ?? '');
      }
    });
    var fcmToken = await FirebaseMessaging.instance.getToken();
    debugPrint('$fcmToken');
    if (fcmToken == null) {
      initFirebaseMessaging();
      return;
    }
    await _cache.saveFCMToken(fcmToken);
    return fcmToken;
  }

  Future<bool> showPlainNotification(String title, String content) async {
    if (notificationManager == null) return false;

    notificationManager!.cancelAll();

    await notificationManager!
        .show(0, title, content, platformChannelSpecifics, payload: '');

    return true;
  }

  _initLocalNotifications() async {
    if (Platform.isIOS) return;
    notificationManager = FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    if (notificationManager != null) {
      await notificationManager?.initialize(initializationSettings);
    }

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('Govigyaan', 'exam notification',
            channelDescription: 'Used to display exam notifications',
            importance: Importance.max,
            priority: Priority.high,
            enableVibration: true,
            visibility: NotificationVisibility.public,
            ticker: 'Govigyaan');
    platformChannelSpecifics =
        const NotificationDetails(android: androidPlatformChannelSpecifics);
  }

  void selectNotification(String? payload) async {
    if (payload != null) {}
  }

  void subscribeInAppMessagingTopic({String topic = ''}) async {
    FirebaseMessaging.instance.subscribeToTopic(topic);
  }
}
