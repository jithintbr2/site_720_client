import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:site720_client/model/pushNotificationModel.dart';
import 'package:site720_client/screens/login.dart';

class FirebaseServices {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final initializationSettings = new InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'));

  Future<String?> get token => FirebaseMessaging.instance.getToken();

  void init(BuildContext context) {
    _initNotification(context);
  }

  void _initNotification(BuildContext context) {
    if (Platform.isAndroid) {
      flutterLocalNotificationsPlugin.initialize(initializationSettings);
    }

    if (Platform.isAndroid) {
      flutterLocalNotificationsPlugin.initialize(initializationSettings);
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final fbNotification = PushNotificationModel.fromJson(
          Map<String, dynamic>.from(message.data));
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'delvento', 'Delvento',
          importance: Importance.max,
          priority: Priority.high,
          ticker: fbNotification.message);
      var platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
          fbNotification.notificationId ?? 0,
          fbNotification.title,
          fbNotification.message,
          platformChannelSpecifics,
          payload: fbNotification.toString());
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('bb');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
      // add(RedirectToNotifications(message.data == null
      //         ? null
      //         : PushNotificationModel.fromJson(
      //             Map<String, dynamic>.from(message.data))));
    });

    FirebaseMessaging.instance.requestPermission();
  }
}
