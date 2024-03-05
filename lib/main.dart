import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:taco_bell_managment/api/firebase_api.dart';
import 'package:taco_bell_managment/page/account_setup/login_screen.dart';
import 'package:taco_bell_managment/page/account_setup/notification_screen.dart';
import 'package:taco_bell_managment/util/style_sheet.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyByF2JEvYpZBbWd_gAEkC-GFRPiwJlX5bE",
          appId: "1:1037146225574:android:0477527551c87a5c3aad67",
          messagingSenderId: "1037146225574",
          projectId: "taco-bell-management"));
  await FirebaseApi.initNotifications();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Taco Bell Managment',
        theme: ThemeData(
          primarySwatch: Colors.amber,
          textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 16)),
          fontFamily: "Slab",
            textSelectionTheme: TextSelectionThemeData(
              selectionColor: Palette.getTint().light,
              cursorColor: Palette.getTint().main,
              selectionHandleColor: Palette.getTint().main,
            )
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
          // useMaterial3: true,
        ),
        home: const LoginScreen(),
        routes: {
          NotificationScreen.route: (context) => const NotificationScreen()
        });
  }
}
