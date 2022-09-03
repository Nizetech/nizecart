import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nizecart/Auth/controller/auth_controller.dart';
// import 'package:nizecart/Screens/image_input.dart';
import 'package:nizecart/Screens/product_overview_screen.dart';
import 'package:nizecart/products/product_controller.dart';
import '../Widget/component.dart';

class ManageProducts extends ConsumerStatefulWidget {
  const ManageProducts({Key key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ManageProductsState();
}

class _ManageProductsState extends ConsumerState<ManageProducts> {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();

  String url;

  void initValue() {
    title.text = "";
    description.text = "";
    price.text = "";
    storedImage = null;
  }

  File storedImage;

  CollectionReference imageRef;
  // storage.Reference ref;

  void pickImage(
    ImageSource source,
  ) async {
    XFile pickedFile =
        await ImagePicker().pickImage(source: source, imageQuality: 40);
    if (pickedFile != null) {
      CroppedFile croppedFile = await ImageCropper().cropImage(
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
  }

  void addProduct() async {
    loading('Adding Product...');
    print(storedImage);
    String imageUrl =
        await ref.read(authtControllerProvider).uploadFile(storedImage);
    //  ref.read(productControllerProvider).addProduct(
    //       ;

    ref.read(productControllerProvider).addProduct(
          imageUrl,
          title.text.trim(),
          description.text.trim(),
          int.parse(price.text),
        );
    print('title ${title.text}');
    print(price.text);
    initValue();
    showToast('Product Added');
    Get.back();
  }

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
                ),
              ),
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
                            onTap: () {
                              pickImage(ImageSource.camera);
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
                              pickImage(ImageSource.gallery);
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
                onPressed: () {
                  addProduct();
                }),
          ],
        ),
      ),
    );
  }
}
