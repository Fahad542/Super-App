import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> backgroundMessageHandler(RemoteMessage message) async {
  try {
    print("Handling a background message: ${message.messageId}");

    if (message.notification != null) {
      print('Notification Title: ${message.notification!.title}');
      print('Notification Body: ${message.notification!.body}');
    }

    print('Payload data: ${message.data}');
  } catch (e) {
    print('Error handling background message: $e');
  }
}


class FirebaseApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


  Future<void> initNotification({BuildContext? context}) async {
    await Firebase.initializeApp();


    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Request permission
    await _firebaseMessaging.requestPermission();
    String? token = await _firebaseMessaging.getToken();

      print("FCM Token: $token");
      // Save the token to your backend or local storage as needed


    // Get FCM token
    await _firebaseMessaging.subscribeToTopic('general');
    print("Subscribed to topic 'general'");

    // Set up message handlers
    FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Received a message in the foreground: ${message.messageId}');

      if (message.notification != null) {
        print('Title: ${message.notification!.title}');
        print('Body: ${message.notification!.body}');

        // Show the local notification
        showLocalNotification(message.notification!);

        // Capture the current time
        DateTime currentTime = DateTime.now();
        print('Current Time: $currentTime');


        // Insert the notification into the database


      }

      print('Data: ${message.data}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked!');
      if (message.notification != null && context != null) {
        print('Title: ${message.notification!.title}');
        print('Body: ${message.notification!.body}');
      }
      print('Data: ${message.data}');
    });

  }

  void showLocalNotification(RemoteNotification notification) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'default_channel_id', // id
      'Default', // title
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      platformChannelSpecifics,
    );
  }
}