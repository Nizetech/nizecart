import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nizecart/Auth/signInScreen.dart';
import 'package:nizecart/Screens/home_screen.dart';
import 'package:nizecart/Widget/bottonNav.dart';
import 'package:nizecart/Widget/component.dart';
import 'package:path_provider/path_provider.dart' as path;

void main() async {
  // final applicationDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(
      // applicationDocumentDir.path
      );
  await Hive.openBox('name');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NizeCart',
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
              elevation: 0, color: secColor, foregroundColor: white),
          primarySwatch: Colors.blue,
          backgroundColor: white),
      home: BottomNav(),
    );
  }
}
