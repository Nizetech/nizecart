import 'dart:io';

// import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
// import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nizecart/Models/imageInput2.dart';
import 'package:nizecart/Models/product_overview_screen.dart';
import 'imageInput.dart';
import '../Widget/component.dart';
// import 'product_overview_screen.dart';

class ManageProducts extends StatelessWidget {
  ManageProducts({Key key}) : super(key: key);

  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();
  // var box = Hive.box('name');

  File image;
  String downloadUrl;

  void selectImage(File image) {
    this.image = image;
  }

  // box: Hive.box('products'),
  // ignore: missing_return

  void addProduct() {
    // Create a CollectionReference called products that references the firestore collection
    CollectionReference products =
        FirebaseFirestore.instance.collection('products');

    // Call the products CollectionReference to add a new product
    products.add({
      'title': title.text, // Apple
      'description': description.text, // A fruit
      'price': price.text, // 1.99
      'image': image
          .path, // /storage/emulated/0/Android/data/com.example.nizecart/files/Pictures/image_name.jpg
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
    image == null;
  }

  Future<void> uploadFile() async {
    ref = FirebaseStorage.instance
        .ref()
        .child('images/${(DateTime.now()).millisecondsSinceEpoch}');

    await ref.putFile(image).whenComplete(() async {
      ref.getDownloadURL().then((value) {
        downloadUrl = value;
        print(downloadUrl);
      });
    });
  }

// @override
// void initState() {
//   super.initState();
//   imageRef = FirebaseFirestore.instance.collection('images');

// }
  // Storage storage = Storage();
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
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
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
            // ImageInput(selectImage),
            // Container(
            //   height: 200,
            //   width: 200,
            //   alignment: Alignment.center,
            //   decoration: BoxDecoration(
            //     border: Border.all(width: 1, color: Colors.grey),
            //   ),
            //   child: storage == null
            //       ? const Text(
            //           'No Image',
            //           textAlign: TextAlign.center,
            //           style:
            //               TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            //         )
            //       : Image.file(
            //           storage as File,
            //           fit: BoxFit.cover,
            //           width: 200,
            //           height: 200,
            //         ),
            // ),
            // Row(
            //   children: [
            //     IconButton(
            //       icon: Icon(Icons.camera_alt),
            //       onPressed: () async {
            //         final results = await FilePicker.platform.pickFiles(
            //             allowMultiple: false,
            //             type: FileType.custom,
            //             allowedExtensions: ['jpg', 'png']);
            //         if (results == null) {
            //           ScaffoldMessenger.of(context).showSnackBar(
            //             SnackBar(
            //               content: Text('No Image Selected'),
            //             ),
            //           );
            //           return;
            //         }
            //         final path = results.files.first.path;
            //         final fileName = results.files.single.name;

            //         storage.uploadFile(path, fileName).then((value) => {
            //               print('done'),
            //               selectImage(File('$path')),
            //             });
            //       },
            // ),
            ImageInputs(selectImage),
            const TextButton(
                // onPressed: takePicture,
                child: Text(
              'Upload Picture',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            SizedBox(height: 15),

            CustomButton(
              text: "Add Product",
              onPressed: () {
                // setState(() {});
                addProduct();
                uploadFile();

                initValue();
              },
            ),
          ],
        ),
      ),
    );
  }
}
