import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nizecart/Screens/updateScreen.dart';
import 'package:nizecart/products/product_controller.dart';
import '../Widget/component.dart';

class ProductsOverviewScreen extends ConsumerStatefulWidget {
  // final productID;
  ProductsOverviewScreen({
    Key key,
  }) : super(key: key);

  @override
  ConsumerState<ProductsOverviewScreen> createState() =>
      _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState
    extends ConsumerState<ProductsOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    // products = Hive.box('name')
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        // leading: IconButton(
        // onPressed: (() => Get.back()),
        // icon: Icon(Icons.arrow_back),
        // )
      ),
      body: FutureBuilder<List<dynamic>>(
        future: ref.read(productControllerProvider).getProduct(),
        builder: (context, snapshot) {
          // print(snapshot.data);
          if (!snapshot.hasData) {
            return loader();
          } else {
            List data = snapshot.data;
            // print(data);
            return data.isEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/cart.png',
                          height: 120,
                          width: 150,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 10),
                      const Text(
                        'No Products Found',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    itemCount: data.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      print(data[index]);
                      Map item = data[index];
                      return GestureDetector(
                        onTap: () => Get.to(UpdateScreen(data: item)),
                        child: Slidable(
                          startActionPane: ActionPane(
                              extentRatio: 0.25,
                              motion: ScrollMotion(),
                              children: [
                                SlidableAction(
                                  padding: EdgeInsets.zero,
                                  onPressed: (context) {
                                    ref
                                        .read(productControllerProvider)
                                        .deleteProduct(
                                          data[index]['productID'],
                                        );
                                    setState(() {});
                                  },
                                  spacing: 2,
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  icon: Icons.save,
                                  label: 'Delete',
                                ),
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                radius: 50,
                                child: data[index]['imageUrl'] != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: CachedNetworkImage(
                                            imageUrl: data[index]['imageUrl'],
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover),
                                      )
                                    : const Text('No Image'),
                              ),
                              title: Text(data[index]['title']),
                              subtitle: Text(data[index]['description']),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    data[index]['price'].toString(),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Get.dialog(AlertDialog(
                                        content: Text(
                                            'Are you sure you want  to delete this product?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Get.back(),
                                            child: const Text(
                                              'No',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.green),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              ref
                                                  .read(
                                                      productControllerProvider)
                                                  .deleteProduct(
                                                      data[index]['productID']);
                                              setState(() {});
                                              Get.back();
                                            },
                                            child: const Text(
                                              'Yes',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: mainColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ));
                                    },
                                    icon: Icon(
                                      Icons.delete_outline,
                                      color: mainColor,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
          }
        },
      ),
    );
  }
}
