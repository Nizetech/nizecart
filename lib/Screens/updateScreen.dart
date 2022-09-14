import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../Auth/controller/auth_controller.dart';
import '../Widget/component.dart';
import '../products/product_controller.dart';

class UpdateScreen extends ConsumerStatefulWidget {
  final Map data;
  const UpdateScreen({Key key, this.data}) : super(key: key);

  @override
  ConsumerState<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends ConsumerState<UpdateScreen> {
  TextEditingController newTitle = TextEditingController();
  String title;

  TextEditingController newDescription = TextEditingController();
  String description;

  TextEditingController newPrice = TextEditingController();
  TextEditingController price = TextEditingController();
//
  @override
  void initState() {
    // ProductService().getProduct().then((value) {
    // print(widget.data);
    setState(() {
      newTitle.text = widget.data['title'];
      newDescription.text = widget.data['description'];
      price.text = widget.data['price'].toString();
    });
    // });
    super.initState();
  }

  void initValue() {
    newTitle.text = "";
    newDescription.text = "";
    price.text = "";
    updateImage = null;
  }

  File updateImage;

  void updateImages(
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
          updateImage = File(croppedFile.path);
        });
      } else {
        return null;
      }
    }
    Get.back();
  }

  void UpdateProduct() async {
    loading('Updating Product...');
    // print(storedImage);
    String imageUrl =
        await ref.read(productControllerProvider).uploadFile(updateImage);

    ref.read(productControllerProvider).updateProduct(
          imageUrl,
          newTitle.text.trim(),
          newDescription.text.trim(),
          int.parse(price.text.trim()),
        );

    initValue();
    showToast('Product Updated');
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.data);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Products"),
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
                  controller: newTitle,
                  cursorColor: mainColor,
                  decoration: InputDecoration(
                    labelText: 'Title',
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
                  controller:
                      TextEditingController(text: widget.data['description']),
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
            const SizedBox(height: 15),
            SizedBox(
              height: 45,
              width: 150,
              child: TextFormField(
                  cursorColor: mainColor,
                  keyboardType: TextInputType.number,
                  controller: price,
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
              child: Image.network(
                widget.data['imageUrl'],
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
                              updateImages(ImageSource.camera);
                              // Get.back();
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
                            onTap: () {
                              updateImages(ImageSource.gallery);

                              // Get.back();
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
              text: "Update",
              onPressed: () async {
                UpdateProduct();
              },
            ),
          ],
        ),
      ),
    );
  }
  //   },
  // ),
  //);
  // }
}
