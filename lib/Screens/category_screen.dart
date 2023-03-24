import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:nizecart/Auth/screens/signInScreen.dart';
import 'package:nizecart/Screens/product_details.dart';
import 'package:nizecart/Screens/products_list.dart';
import 'package:nizecart/products/product_controller.dart';
import '../Models/data.dart';
import '../Widget/component.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  CategoryScreen({Key key}) : super(key: key);

  @override
  ConsumerState<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  List<Map> cat;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
        // IconButton(
        // onPressed: () => Get.to(SignInScreen()),
        // icon: Icon(Icons.arrow_back),
        // ),
        title: const Text(
          'Category',
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
      ),
      backgroundColor: white,
      body: FutureBuilder(
        future: ref.read(productControllerProvider).getProduct(),
        // .productCategory(categories.first),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return loader();
          } else {
            List<Map> product = snapshot.data;
            cat = product;
            // print("Category: $cat");
            return ListView.separated(
              itemCount: categories.length,
              separatorBuilder: (ctx, i) => Divider(),
              itemBuilder: (ctx, i) {
                return ListTile(
                  onTap: () {
                    setState(
                      () {
                        if (categories[i] == 'All Products') {
                          cat = product;
                          // print('All product $cat');
                          // print('Tapped');
                        } else {
                          cat = product
                              .where(
                                  (element) => element['tag'] == categories[i])
                              .toList();
                        }
                        Get.to(
                          ProductList(
                            data: cat,
                            productName: categories[i],
                          ),
                        );
                        // print('Tapped again');
                      },
                    );
                  },
                  contentPadding: EdgeInsets.only(left: 10, right: 10),
                  title: Text(
                    categories[i],
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  trailing: Icon(Icons.navigate_next),
                );
              },
            );
          }
        },
      ),
    );
  }
}
