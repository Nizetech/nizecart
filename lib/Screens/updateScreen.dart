import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
// import 'package:firebase_storage/firebase_storage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nizecart/Models/image_input.dart';
import 'package:nizecart/Models/productService.dart';
// import 'package:nizecart/Models/product_overview_screen.dart';
import '../Widget/component.dart';

class UpdateScreen extends StatefulWidget {
  final List data;
  const UpdateScreen({Key key, this.data}) : super(key: key);

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  TextEditingController newTitle = TextEditingController();

  TextEditingController newDescription = TextEditingController();

  TextEditingController newPrice = TextEditingController();
  // CollectionReference products = Firestore.instance.collection('products');
//
  @override
  void initState() {
    super.initState();
  }
  // CollectionReference products = firestore.collection('products');

  String url;

  // void removeProduct() {
  //   // Create a CollectionReference called products that references the firestore collection
  //   CollectionReference products =
  //       FirebaseFirestore.instance.collection('products');
  //   // to remove a product
  //   products.doc('${title.text}').delete().catchError(
  //       (error) => showErrorToast("Failed to delete product: $error"));
  // }

  // void initValue() {
  //   title.text = "";
  //   description.text = "";
  //   price.text = "";
  //   updateImage = null;
  // }

  File updateImage;

  CollectionReference imageRef;
  // Map data = {};

  storage.Reference ref;

  FirebaseAuth auth = FirebaseAuth.instance;
  User getUser() => auth.currentUser;

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
      body:
          // FutureBuilder(
          // future: Future.wait([
          //   ProductService().getProducts().then((value) {
          //     return value.firstWhere(
          //         (element) => element.prodId == 'foX2BEtBSQfKUOStDPxeEiHUCWD2');
          //   }),
          // ]),
          // foX2BEtBSQfKUOStDPxeEiHUCWD2
          // future: ProductService().getProduct(widget.data[0]['ProductId']),
          // builder: (context, AsyncSnapshot<Map<dynamic, dynamic>> snapshot) {
          //   // print(snapshot.data[0]);
          //   print(widget.data[0]['ProductId']);
          //   if (!snapshot.hasData) {
          //     return loader();
          //   } else {
          // print(snapshot.data[0]);
          // Map data =  snapshot.data[0];
          // print(snapshot.data[0]);
          // return
          Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            SizedBox(height: 20),
            SizedBox(
              height: 45,
              child: TextFormField(
                  // initialValue: widget.data[0]['title'],
                  controller:
                      TextEditingController(text: widget.data[0]['title']),
                  // controller: newTitle,
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
              child: TextFormField(
                  // initialValue: widget.data[0]['description'],
                  controller: newDescription,
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
                  controller: newPrice,
                  // initialValue: widget.data[0]['price'],
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
            // Container(
            //   height: 200,
            //   width: 200,
            //   alignment: Alignment.center,
            //   decoration: BoxDecoration(
            //     border: Border.all(width: 1, color: Colors.grey),
            //   ),
            //   child: (updateImage == null && data['imageUrl'] == null)
            //       ? const Text(
            //           'No Image',
            //           textAlign: TextAlign.center,
            //           style: TextStyle(
            //               fontWeight: FontWeight.bold, fontSize: 20),
            //         )
            //       : Image.file(
            //           snapshot.data[0].isEmpty
            //               ? storedImage
            //               : File(data['imageUrl']),
            //           height: 200,
            //           width: 200,
            //           fit: BoxFit.cover,
            //         ),
            // ),
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
                                    updateImage = File(croppedFile.path);
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
                                    updateImage = File(croppedFile.path);
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
              text: "Update",
              onPressed: () async {
                // loading('Updating Product...');
                print(updateImage);
                // String imageUrl =
                //     await ProductService().uploadFile(updateImage);
                // ProductService().updateProduct(
                //   imageUrl,
                //   title.text,
                //   description.text,
                //   price.text,
                // );
                // print(title.text);
                // initValue();
                // showToast('Product Updated');
                // Get.back();
                // print(snapshot.data[0][0]['id']);
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
