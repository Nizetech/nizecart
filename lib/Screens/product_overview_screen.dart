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
  ConsumerState<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends ConsumerState<ProductsOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    // products = Hive.box('name')
    return Scaffold(
      appBar: AppBar(
          title: Text('Products'),
          leading: IconButton(
            onPressed: (() => Get.back()),
            icon: Icon(Icons.arrow_back),
          )),
      body: FutureBuilder(
        future: ref.read(productControllerProvider).getProduct(),
        builder: (context, snapshot) {
          // print(snapshot.data);
          if (!snapshot.hasData) {
            return loader();
          } else {
            List data = snapshot.data[0];
            print(data);
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
                    itemBuilder: (context, index) {
                      print(data[index]);
                      Map item = data[index];
                      // Map item = {
                      //   'title': data[index]['title'],
                      //   'description': data[index]['description'],
                      //   'price': data[index]['price'],
                      //   'imageUrl': data[index]['imageUrl'],
                      //   'productID': data[index]['productID'],
                      // };
                      return GestureDetector(
                        onTap: () => Get.to(UpdateScreen(data: item)),
                        child: Slidable(
                          startActionPane: ActionPane(
                              extentRatio: 0.25,
                              motion: ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    // print('delete');
                                    // ProductService()
                                    //     .deleteProduct(widget.productID);
                                  },
                                  spacing: 2,
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  icon: Icons.save,
                                  label: 'Delete',
                                ),
                              ]),
                          endActionPane: const ActionPane(
                            extentRatio: 0.25,
                            motion: ScrollMotion(),
                            children: [
                              SlidableAction(
                                // An action can be bigger than the others.
                                flex: 2,
                                // onPressed: () {},
                                backgroundColor: Color(0xFF7BC043),
                                foregroundColor: Colors.white,
                                icon: Icons.archive,
                                label: 'Archive',
                              ),
                            ],
                          ),
                          child: data == null
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
                                      'No Favourite Items',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                )
                              : ListTile(
                                  leading: CircleAvatar(
                                    radius: 50,
                                    child: data[index]['imageUrl'] != null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: CachedNetworkImage(
                                                imageUrl:
                                                    // 'https://firebasestorage.googleapis.com/v0/b/nizecart-255f9.appspot.com/o/images%2FShFwoLUXSsUzIbjtwi88L59AVFc2.jpg?alt=media&token=f946ea96-31ba-47bb-a681-2845a7665ac4',
                                                    data[index]['imageUrl'],
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover),
                                          )
                                        : const Text('No Image'),
                                    // Image.network(data[index]['image']),
                                  ),
                                  title: Text(data[index]['title']),
                                  subtitle: Text(data[index]['description']),
                                  trailing:
                                      Text(data[index]['price'].toString()),
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
