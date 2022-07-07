import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nizecart/Models/image_input.dart';
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
  // void selectImage(File storedImage2) {
  //   image = storedImage2;
  // }

  String url;

  void removeProduct() {
    // Create a CollectionReference called products that references the firestore collection
    CollectionReference products =
        FirebaseFirestore.instance.collection('products');
    // to remove a product
    products.doc('${title.text}').delete().catchError(
        (error) => showErrorToast("Failed to delete product: $error"));
  }

  void initValue() {
    title.text = "";
    description.text = "";
    price.text = "";
    storedImage = null;
  }

  File storedImage;

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
            Get.back();
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
                        borderSide: const BorderSide(color: mainColor)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: mainColor)),
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
                    filled: true,
                    isDense: true,
                    prefixIcon: const Icon(Iconsax.dollar_circle),
                    prefixIconColor: mainColor,
                    iconColor: mainColor,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: mainColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: mainColor)),
                  )),
            ),
            SizedBox(height: 15),
            Container(
              height: 200,
              width: 200,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey),
              ),
              child: (storedImage == null)
                  ? const Text(
                      'No Image',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    )
                  : Image.file(
                      storedImage,
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
            ),
            SizedBox(height: 5),
            Center(
              child: TextButton(
                onPressed: () {
                  Get.dialog(Dialog(
                    child: Container(
                      height: 100,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              XFile pickedFile = await ImagePicker().pickImage(
                                  source: ImageSource.camera, imageQuality: 40);
                              if (pickedFile != null) {
                                CroppedFile croppedFile = await ImageCropper()
                                    .cropImage(
                                        sourcePath: pickedFile.path,
                                        compressQuality: 50,
                                        uiSettings: [
                                      AndroidUiSettings(
                                        lockAspectRatio: false,
                                      ),
                                    ]);
                                if (croppedFile != null) {
                                  setState(() {
                                    storedImage = File(croppedFile.path);
                                  });
                                } else {
                                  return null;
                                }
                              }
                              Get.back();
                            },
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Iconsax.camera5),
                                  SizedBox(height: 10),
                                  Text(
                                    'Camera',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ]),
                          ),
                          GestureDetector(
                            onTap: () async {
                              XFile pickedFile = await ImagePicker().pickImage(
                                  source: ImageSource.gallery,
                                  imageQuality: 40);
                              if (pickedFile != null) {
                                CroppedFile croppedFile = await ImageCropper()
                                    .cropImage(
                                        sourcePath: pickedFile.path,
                                        compressQuality: 50,
                                        uiSettings: [
                                      AndroidUiSettings(
                                        lockAspectRatio: false,
                                      ),
                                    ]);
                                if (croppedFile != null) {
                                  setState(() {
                                    storedImage = File(croppedFile.path);
                                  });
                                } else {
                                  return null;
                                }
                              }
                              Get.back();
                            },
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Iconsax.gallery),
                                  SizedBox(height: 10),
                                  Text(
                                    'Galley',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ]),
                          ),
                        ],
                      ),
                    ),
                  ));
                },
                child: const Text(
                  'Add Image',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ),
            SizedBox(height: 25),
            CustomButton(
              text: "Add Product",
              onPressed: () async {
                loading('Adding Product...');
                print(storedImage);
                String imageUrl =
                    await ProductService().uploadFile(storedImage);
                ProductService().addProduct(
                    imageUrl, title.text, description.text, price.text);
                initValue();
                showToast('Product Added');
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}
