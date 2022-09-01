import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nizecart/Auth/controller/auth_controller.dart';
import 'package:nizecart/Screens/product_overview_screen.dart';
import 'package:nizecart/Screens/change_password_screen.dart';
import 'package:nizecart/Screens/profile_screen.dart';
import 'package:nizecart/Screens/search_screen.dart';
import 'package:nizecart/Widget/component.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';

import 'manage_product_screen.dart';
import 'change_address.dart';

class ProfileScreen extends ConsumerWidget {
  ProfileScreen({Key key}) : super(key: key);

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
        leadingWidth: 10,
        actions: [
          IconButton(
            icon: const Icon(Iconsax.search_normal),
            onPressed: () => Get.to(
              SearchScreen(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Cart(),
          ),
        ],
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
            const AccountListTile(text: 'Order'),
            AccountListTile(
              text: 'Profile',
              onTap: () => Get.to(ProfileScreen()),
            ),
            AccountListTile(
              text: 'Product Overview',
              onTap: () => Get.to(ProductsOverviewScreen()),
            ),
            AccountListTile(
              text: 'Manage Product',
              onTap: () => Get.to(ManageProducts()),
            ),
            AccountListTile(
              text: 'Change password',
              onTap: () => Get.to(ChangePassword()),
            ),
            AccountListTile(
              text: 'Change Address',
              onTap: () => Get.to(ChangeAddress()),
            ),
            AccountListTile(
                text: 'Sign Out',
                onTap: () {
                  ref.read(authtControllerProvider).signOut();
                }),
          ],
        ),
      ),
    );
  }
}
