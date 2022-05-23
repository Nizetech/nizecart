import 'package:flutter/material.dart';
import 'package:nizecart/Screens/search_screen.dart';
import 'package:nizecart/Widget/component.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';

import 'manage_product_screen.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
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
            onPressed: () => Get.to(SearchScreen()),
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
            const Text(
              'Welcome fortune!',
              style: TextStyle(
                  fontSize: 20, color: mainColor, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const ListTile(
              leading: Icon(Iconsax.wallet_check),
              title: Text(
                'Orders',
                style: TextStyle(color: Colors.grey),
              ),
              trailing: Icon(Icons.navigate_next_sharp),
            ),
            ListTile(
              leading: const Icon(Iconsax.shop),
              title: const Text(
                'Manage Products',
                style: TextStyle(color: Colors.grey),
              ),
              trailing: const Icon(Icons.navigate_next_sharp),
              // onTap: () => Get.to(ManageProduct()),
            )
          ],
        ),
      ),
    );
  }
}
