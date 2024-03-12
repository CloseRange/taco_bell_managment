// ignore_for_file: curly_braces_in_flow_control_structures, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:taco_bell_managment/main.dart';
import 'package:taco_bell_managment/page/account_setup/notification_screen.dart';

/// ***Handle Background Message***
///
/// Callback for when notificaition is clicked on
Future<void> _handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

/// Firebase API
///
/// Connects to Firebase and allows for generic calls to a database.
///
/// To initalize call the initialize function in main:
/// ```dart
/// FirebaseApi.initialize(
///   apiKey: ...,
///   appId: ...,
///   messagingSenderId: ...,
///   projectId: ...,
/// );
/// ```
///
class FirebaseApi {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static final _firebaseFunctions = FirebaseFunctions.instance;
  // static final _database = FirebaseDatabase.instance;
  static final _firestore = FirebaseFirestore.instance;

  static String? _token;

  /// ***Initialize***
  ///
  /// Initializes the firebase API along with notifications
  /// applies all paramaters to the FirebaseOptions
  ///
  /// Usage:
  /// ```dart
  /// FirebaseApi.initialize(
  ///   apiKey: ...,
  ///   appId: ...,
  ///   messagingSenderId: ...,
  ///   projectId: ...,
  /// );
  /// ```
  static Future<void> initialize({
    required String apiKey,
    required String appId,
    required String messagingSenderId,
    required String projectId,
  }) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: apiKey,
            appId: appId,
            messagingSenderId: messagingSenderId,
            projectId: projectId));
    await FirebaseApi._initNotifications();
  }

  /// ***Write***
  ///
  /// Writes message to the `Firestore` calling to the collection and document.
  ///
  /// Document is auto created and will generate a random key if not supplied.
  /// If no payload, an empty load will be used.
  ///
  /// Usage:
  /// ```dart
  /// Firebase.write("users", "user1", {"test": 25, "ok": "Hello"});
  /// ```
  static void write(
      {required String collection,
      String? document,
      Map<String, String> payload = const {}}) async {
    _firestore.collection(collection).doc(document).set(payload);
  }

  /// ***Handle Message***
  ///
  /// Callback for when a notification is clicked on.
  static void _handleMessage(RemoteMessage? message) {
    if (message == null) return;

    navigatorKey.currentState?.pushNamed(
      NotificationScreen.route,
      arguments: message,
    );
  }

  /// ***Init Push Notifications***
  static Future _initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance.getInitialMessage().then(_handleMessage);
    FirebaseMessaging.onMessageOpenedApp
        .listen(_handleMessage); // from background state
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
  }

  /// ***Init Notifications***
  static Future<void> _initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    _token = fCMToken;
    // print('Token: $fCMToken');
    _initPushNotifications();
  }

  /// ***Write Message***
  static Future<void> writeMessage(String message) async {
    HttpsCallable callable = _firebaseFunctions.httpsCallable("writeMessage");
    final resp = await callable.call(<String, dynamic>{"text": message});
    print("result: ${resp.data}");
  }

  /// ***Call Function***
  ///
  /// Directly calls a function from the firebase function set.
  ///
  /// Usage:
  /// ```dart
  /// FirebaseApi.callFirebase("function_name", {"data": "to send"});
  /// ```
  static Future<dynamic> callFunction(
      String callbackName, Map<String, dynamic> data) async {
    HttpsCallable callable = _firebaseFunctions.httpsCallable(callbackName);
    final resp = await callable.call(data);
    return resp.data;
  }

  /// ***Get Notification Token***
  ///
  /// ---
  /// Notification Identifier. Used to send notifications from the firebase server.
  static String? get notificationToken => _token;
}
