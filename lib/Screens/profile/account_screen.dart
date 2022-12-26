import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nizecart/Screens/manage_product_screen.dart';

import 'package:nizecart/Screens/product_overview_screen.dart';
import 'package:nizecart/Screens/profile/profile_screen.dart';
import 'package:nizecart/Widget/component.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';
import 'package:nizecart/chat/chat_screen.dart';

import '../../Auth/controller/auth_controller.dart';
import '../manage_product_screen.dart';
import 'account settings/change_password_screen.dart';

class AccountScreen extends ConsumerWidget {
  AccountScreen({Key key}) : super(key: key);

  static var box = Hive.box('name');
  String name = box.get('displayName');
  final String lname = box.get('lname');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        title: const Text(
          'Account',
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
      ),
      backgroundColor: white,
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome ${name} ' ' ${lname} !',
              style: const TextStyle(
                  fontSize: 20, color: mainColor, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            AccountListTile(
              text: 'Profile',
              onTap: () => Get.to(ProfileScreen()),
            ),
            AccountListTile(
              text: 'Product Overview',
              onTap: () => Get.to(ProductsOverviewScreen()),
            ),
            AccountListTile(
              text: 'Admin Board',
              onTap: () => Get.to(ManageProducts()),
            ),
            AccountListTile(
              text: 'Change password',
              onTap: () => Get.to(ChangePassword()),
            ),
          ],
        ),
      ),
    );
  }
}
