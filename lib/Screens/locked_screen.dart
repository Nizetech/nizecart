import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:iconsax/iconsax.dart';
import 'package:local_auth/local_auth.dart';
import 'package:nizecart/custom_nav_bar.dart';
// import 'package:nizecart/botton_nav.dart';

import '../Widget/component.dart';

class LockScreen extends StatefulWidget {
  LockScreen({Key key}) : super(key: key);

  static var box = Hive.box('name');

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  bool isLocked = LockScreen.box.get('isLocked', defaultValue: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            const Icon(
              Iconsax.lock_1,
              size: 30,
              color: secColor,
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/NIZECART.png',
                  height: 42,
                  width: 120,
                  fit: BoxFit.contain,
                ),
                SizedBox(width: 5),
                const Text(
                  'Locked',
                  style: TextStyle(
                      fontSize: 28,
                      color: mainColor,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .25),
            IconButton(
              icon: Icon(
                Icons.fingerprint,
                size: 60,
                color: mainColor,
              ),
              onPressed: () {
                LocalAuthentication()
                    .authenticate(
                        localizedReason: 'Please authenticate to Unlock',
                        options: const AuthenticationOptions(
                          biometricOnly: true,
                        ))
                    .then(
                  (value) {
                    if (value) {
                      Get.offAll(CustomNavBar());
                    }
                  },
                );
              },
            ),
            SizedBox(height: 30),
            const Text(
              'Touch the fingerprint sensor to unlock.',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
            ),
          ],
        ),
      ),
    );
  }
}
