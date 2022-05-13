import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nizecart/Auth/signInScreen.dart';
import 'package:nizecart/Widget/component.dart';

void main() {
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
          appBarTheme: AppBarTheme(
              elevation: 0, color: secColor, foregroundColor: white),
          primarySwatch: Colors.blue,
          backgroundColor: white),
      home: SignInSCreen(),
    );
  }
}
