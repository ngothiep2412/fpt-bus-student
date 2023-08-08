import 'dart:convert';
import 'package:fbus_app/src/environment/environment.dart';
import 'package:fbus_app/src/models/notification.dart';
import 'package:fbus_app/src/models/users.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class PushNotificationsProvider {
  FlutterSecureStorage storage = FlutterSecureStorage();
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.high,
  );

  FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();

  void initPushNotifications() async {
    await plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void onMessageListener(BuildContext context) async {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        print('NEW NOTIFICATION');
      }
    });

    _createNotification(PushNotification notification) async {
      var user = UserModel.fromJson(GetStorage().read('user') ?? {}).obs;
      String? jwtToken = await storage.read(key: 'jwtToken');
      Uri uri =
          Uri.http(Environment.API_URL_OLD, '/api/v1/notification/create');
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      };

      final Map<String, dynamic> body = {
        "title": notification.title,
        "body": notification.body,
        "dataTitle": notification.dataTitle,
        "dataBody": notification.dataBody,
        "sentTime": notification.sentTime,
        "userId": user.value.id
      };

      final http.Response response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(body),
      );
      print('response.statusCode Trip Today: ${response.statusCode}');
      // Handle the response from the API
      if (response.statusCode == 401) {
        Get.snackbar("Fail", "You are not logged into the system");
      }
      if (response.statusCode == 403) {
        Get.snackbar("Fail", "Access denied");
      }
      // if (response.statusCode == 404) {
      //   final data = json.decode(response.body);
      //   final responseApi = ResponseApi.fromJson(data);
      //   _noTripToday = responseApi.message;
      // }
      if (response.statusCode == 500) {
        Get.snackbar("Fail", "Internal server error");
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Create notification successfully!');
      }
    }

    // PRIMER PLANO
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('NEW NOTIFICATION IN FOREGROUND');
      PushNotification notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
        dataTitle: message.data['title'],
        dataBody: message.data['body'],
        sentTime: DateFormat('yyyy-MM-dd HH:mm:ss').format(
          DateTime.fromMillisecondsSinceEpoch(
            message.sentTime?.millisecondsSinceEpoch ??
                DateTime.now().millisecondsSinceEpoch,
          ),
        ),
      );
      print('NOTIFICAITON: ${notification.title}');
      _createNotification(notification);

      showNotification(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
        dataTitle: message.data['title'],
        dataBody: message.data['body'],
        sentTime: DateFormat('yyyy-MM-dd HH:mm:ss').format(
          DateTime.fromMillisecondsSinceEpoch(
            message.sentTime?.millisecondsSinceEpoch ??
                DateTime.now().millisecondsSinceEpoch,
          ),
        ),
      );
      _createNotification(notification);
      if (message.notification!.body != null) {
        Get.toNamed('/navigation/home/notifications');
      }
    });
  }

  void showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      String sentTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(
        DateTime.fromMillisecondsSinceEpoch(
          message.sentTime?.millisecondsSinceEpoch ??
              DateTime.now().millisecondsSinceEpoch,
        ),
      );

      // Add the sent time to the notification body
      String notificationBody = '${notification.body} - Sent at: $sentTime';

      plugin.show(
        notification.hashCode,
        notification.title,
        notificationBody,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            icon: 'launch_background',
          ),
        ),
      );
    }
  }
}
