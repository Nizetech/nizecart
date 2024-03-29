import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nizecart/Widget/component.dart';

import '../Screens/account_screen.dart';
import '../Screens/category_screen.dart';
import '../Screens/favourite_screen.dart';
import '../Screens/home_screen.dart';

class BottomNav extends StatefulWidget {
  BottomNav({Key key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int index = 0;
  int currentIndex = 0;
  List body = [
    HomeScreen(),
    CategoryScreen(),
    FavouriteScreen(),
    ProfileScreen(),
    // Container(),
    // Container()
  ];

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
        unselectedLabelStyle: TextStyle(
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
            label: 'Favourite',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Iconsax.message),
          //   label: 'Inbox',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.user),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
