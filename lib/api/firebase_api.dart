// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:taco_bell_managment/main.dart';
import 'package:taco_bell_managment/page/account_setup/notification_screen.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class FirebaseApi {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static final _firebaseFunctions = FirebaseFunctions.instance;
  static final _database = FirebaseDatabase.instance;
  static final _firestore = FirebaseFirestore.instance;

  static String? token;

  static void initialize() {}
  static void write(String collection,
      {String? document, Map<String, String> payload = const {}}) async {
    // var ref = _database.ref("messages/123");
    // await ref.set({
    //   // update to only update some values
    //   "name": name
    // });
    _firestore.collection(collection).doc(document).set(payload);
    // print("testing123");
  }

  static void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    navigatorKey.currentState?.pushNamed(
      NotificationScreen.route,
      arguments: message,
    );
  }

  static Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp
        .listen(handleMessage); // from background state
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  static Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    token = fCMToken;
    print('Token: $fCMToken');
    initPushNotifications();
  }

  static Future<void> writeMessage(String message) async {
    HttpsCallable callable = _firebaseFunctions.httpsCallable("writeMessage");
    final resp = await callable.call(<String, dynamic>{"text": message});
    print("result: ${resp.data}");
  }

  static Future<dynamic> callFirebase(
      String callbackName, Map<String, dynamic> data) async {
    HttpsCallable callable = _firebaseFunctions.httpsCallable(callbackName);
    final resp = await callable.call(data);
    return resp.data;
  }

  static String? getToken() {
    return token;
  }
}
