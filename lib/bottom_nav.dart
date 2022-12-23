import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nizecart/Auth/screens/signInScreen.dart';
import 'package:nizecart/Auth/screens/signUp_screen.dart';
import 'package:nizecart/Screens/product_details.dart';
import 'package:nizecart/Widget/component.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:nizecart/services/service_controller.dart';
import 'Screens/account_screen.dart';
import 'Screens/category_screen.dart';
import 'Screens/favourite_screen.dart';
import 'Screens/home_screen.dart';
import 'Screens/profile_screen.dart';

class BottomNav extends ConsumerStatefulWidget {
  BottomNav({Key key}) : super(key: key);

  @override
  ConsumerState<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends ConsumerState<BottomNav> {
  // static Box box = Hive.box('name');
  // bool isLoggedIn = box.get('isLoggedIn', defaultValue: false);
  
  int index = 0;
  int currentIndex = 0;
  List<Widget> body = [
    HomeScreen(),
    CategoryScreen(),
    FavouriteScreen(),
    // AccountScreen(),
    ProfileScreen(),
  ];
  // final fcm = FirebaseMessaging();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body[index],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: index,
        unselectedItemColor: Color(0xFFC7D1D7),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: mainColor,
        unselectedLabelStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
        onTap: (int selectedPage) {
          setState(() => index = selectedPage);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Iconsax.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(
                Iconsax.category,
              ),
              label: 'Category'),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.heart),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.user),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
