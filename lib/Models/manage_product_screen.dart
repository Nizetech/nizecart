import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nizecart/Models/imageInput3.dart';
import 'package:nizecart/Models/productService.dart';
import 'package:nizecart/Models/product_overview_screen.dart';
import '../Widget/component.dart';

class ManageProducts extends StatefulWidget {
  ManageProducts({Key key}) : super(key: key);

  @override
  State<ManageProducts> createState() => _ManageProductsState();
}

class _ManageProductsState extends State<ManageProducts> {
  TextEditingController title = TextEditingController();

  TextEditingController description = TextEditingController();

  TextEditingController price = TextEditingController();

  // var box = Hive.box('name');
  void selectImage(File image) {
    this.image = image;
  }

  String url;
  // box: Hive.box('products'),
  void addProduct(String imageUrl) {
    // Create a CollectionReference called products that references the firestore collection
    CollectionReference products =
        FirebaseFirestore.instance.collection('products');
    // Call the products CollectionReference to add a new product
    products.add({
      'title': title.text, // Apple
      'description': description.text, // A fruit
      'price': price.text, // 1.99
      'image': imageUrl,
    })

        // box
        //     .put(products, 'products')
        //     .then((value) => print('product added')
        //  Get.to(ProductsOverviewScreen())
        //  )
        .catchError((error) => print("Failed to add product: $error"));
  }

  void initValue() {
    title.text = "";
    description.text = "";
    price.text = "";
    image = (image == null) as File;
  }

  File image;

  CollectionReference imageRef;

  storage.Reference ref;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Products"),
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Get.to(ProductsOverviewScreen());
          },
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            SizedBox(height: 20),
            SizedBox(
              height: 45,
              child: TextField(
                  controller: title,
                  cursorColor: mainColor,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    // labelStyle: TextStyle(fontSize: 18),
                    filled: true,
                    isDense: true,

                    iconColor: mainColor,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: mainColor)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: mainColor)),
                  )),
            ),
            SizedBox(height: 15),
            SizedBox(
              height: 45,
              child: TextField(
                  controller: description,
                  cursorColor: mainColor,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    // labelStyle: TextStyle(fontSize: 18),
                    filled: true,
                    isDense: true,

                    iconColor: mainColor,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: mainColor)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: mainColor),
                    ),
                  )),
            ),
            SizedBox(height: 15),
            SizedBox(
              height: 45,
              width: 150,
              child: TextField(
                  controller: price,
                  cursorColor: mainColor,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Price',
                    // labelStyle: TextStyle(fontSize: 18),
                    filled: true,
                    isDense: true,
                    prefixIcon: Icon(Iconsax.dollar_circle),
                    prefixIconColor: mainColor,
                    iconColor: mainColor,

                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: mainColor)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: mainColor)),
                  )),
            ),
            SizedBox(height: 15),
            ImageInput3(selectImage),
            const TextButton(
                // onPressed: takePicture,
                child: Text(
              'Upload Picture',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            SizedBox(height: 15),
            CustomButton(
              text: "Add Product",
              onPressed: () async {
                String imageUrl = await ProductService().uploadFile(image);
                addProduct(imageUrl);
                initValue();
              },
            ),
          ],
        ),
      ),
    );
  }
}
