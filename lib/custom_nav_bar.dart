import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nizecart/Screens/account_screen.dart';
import 'package:nizecart/Screens/category_screen.dart';
import 'package:nizecart/Screens/favourite_screen.dart';
import 'package:nizecart/Screens/home_screen.dart';
import 'package:nizecart/Screens/profile_screen.dart';
import 'package:nizecart/Widget/component.dart';
import 'package:nizecart/services/service_controller.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class CustomNavBar extends ConsumerStatefulWidget {
  CustomNavBar({Key key}) : super(key: key);

  @override
  ConsumerState<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends ConsumerState<CustomNavBar> {
  PersistentTabController _controller;
  bool _hideNavBar;

  @override
  void initState() {
    super.initState();

    _controller = PersistentTabController(initialIndex: 0);
    _hideNavBar = false;

    FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();

    final fcmToken = FirebaseMessaging.instance
        .getToken()
        .then((value) => log('Fcm Token: $value'));

    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_importance_channel', //id
      'Orders Notifications', // title
      description: 'This channel is used for importance notification.',
      importance: Importance.high, showBadge: true, playSound: true,
    );

    void handleMessage(RemoteMessage message) {
      RemoteNotification notification = message.notification;
      if (notification != null) {
        plugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            iOS: const DarwinNotificationDetails(
              sound: 'default',
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              enableVibration: true,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      }
    }

    FirebaseMessaging.instance.getToken().then((value) {
      log('Firebase Token: $value');
      ref.read(serviceControllerProvider).saveToken(value);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      handleMessage(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});

    FirebaseMessaging.instance.onTokenRefresh
        .listen(ref.read(serviceControllerProvider).saveToken);
  }

  List<Widget> body() {
    return [
      HomeScreen(),
      CategoryScreen(),
      FavouriteScreen(),
      // AccountScreen(),
      ProfileScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Iconsax.home),
        title: "Home",
        activeColorPrimary: mainColor,
        inactiveColorPrimary: Colors.grey,
        inactiveColorSecondary: secColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          Iconsax.category,
        ),
        title: "Category",
        activeColorPrimary: mainColor,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Iconsax.heart),
        title: "Favorite",
        activeColorPrimary: mainColor,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Iconsax.user),
        title: "Account",
        activeColorPrimary: mainColor,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: body(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        navBarHeight: kBottomNavigationBarHeight,
        hideNavigationBarWhenKeyboardShows: true,
        margin: EdgeInsets.all(0.0),
        popActionScreens: PopActionScreensType.all,
        bottomScreenMargin: 0.0,
        // onWillPop: (context) async {
        //   await showDialog(
        //     context: context,
        //     useSafeArea: true,
        //     builder: (context) => Container(
        //       height: 50.0,
        //       width: 50.0,
        //       color: Colors.white,
        //       child: ElevatedButton(
        //         child: Text("Close"),
        //         onPressed: () {
        //           Navigator.pop(context);
        //         },
        //       ),
        //     ),
        //   );
        //   return false;
        // },
        hideNavigationBar: _hideNavBar,
        decoration: NavBarDecoration(
            colorBehindNavBar: Colors.indigo,
            borderRadius: BorderRadius.circular(20.0)),
        popAllScreensOnTapOfSelectedTab: true,
        itemAnimationProperties: ItemAnimationProperties(
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation(
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle:
            NavBarStyle.style1, // Choose the nav bar style with this property
      ),
    );
  }
}
