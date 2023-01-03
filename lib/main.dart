import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nizecart/Auth/screens/signInScreen.dart';
import 'package:nizecart/Screens/home_screen.dart';
import 'package:nizecart/Screens/profile/locked_screen.dart';
import 'package:nizecart/Screens/product_details.dart';
import 'package:nizecart/Screens/product_overview_screen.dart';
// import 'package:nizecart/botton_nav.dart';
import 'package:nizecart/Widget/component.dart';
import 'package:nizecart/custom_nav_bar.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'Screens/manage_product_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox('name');
  // runApp(MyApp());
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({Key key}) : super(key: key);
  static Box box = Hive.box('name');

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // bool isLoggedIn = box.get('isLoggedIn', defaultValue: false);
    bool isLocked = box.get('isLocked', defaultValue: false);
    bool isLoggedIn = box.get('isLoggedIn', defaultValue: false);

    if (Platform.isIOS) {
      FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    }
    final fcmToken = FirebaseMessaging.instance
        .getToken()
        .then((value) => log('Firebase Toke: $value'));

    // FirebaseMessag,
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'NizeCart',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            // backgroundColor: secColor,
            elevation: 0,
            color: secColor,
            foregroundColor: white,
          ),
          scaffoldBackgroundColor: Colors.grey[100],
          primarySwatch: Colors.red,
          fontFamily: 'Poppins',
          visualDensity: VisualDensity.adaptivePlatformDensity,
          backgroundColor: white,
        ),
        home: !isLoggedIn
            ? SignInScreen()
            : isLocked
                ? LockScreen()
                : CustomNavBar());
  }
}
