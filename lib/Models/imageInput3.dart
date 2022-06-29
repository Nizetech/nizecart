// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart' as storage;
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart' as syspaths;
// import 'package:path/path.dart' as path;
// import 'package:path_provider/path_provider.dart';

// class ImageInput3 extends StatefulWidget {
//   // ImageInput3({Key key}) : super(key: key);
//   final Function onSelectImage;
//   ImageInput3(this.onSelectImage);

//   @override
//   State<ImageInput3> createState() => _ImageInput3State();
// }

// class _ImageInput3State extends State<ImageInput3> {
//   CollectionReference imageRef;
//   storage.Reference ref;
//   File storedImage;
//   File storedImage2;
//   String imageUrl;
//   XFile image;

//   bool isCamera = false;

//   // if (imageFile != null) {
//   //   CroppedFile croppedFile = await ImageCropper().cropImage(
//   //       sourcePath: imageFile.path,
//   //       compressQuality: 50,
//   //       uiSettings: [
//   //         AndroidUiSettings(
//   //           lockAspectRatio: true,
//   //         ),
//   //       ]);
//   //   if (croppedFile != null) {
//   //     return File(croppedFile.path);
//   //   } else {
//   //     return;
//   //   }
//   // }

//   Future<void> takePicture2() async {
//     final ImagePicker picker = ImagePicker();
//     final imageFile = await picker.pickImage(
//         source: ImageSource.camera,
//         maxWidth: 500,
//         maxHeight: 500,
//         imageQuality: 40);

//     if (imageFile == null) {
//       return;
//     }
//     // if (imageFile != null) {
//     //   CroppedFile croppedFile = await ImageCropper().cropImage(
//     //       sourcePath: imageFile.path,
//     //       compressQuality: 50,
//     //       uiSettings: [
//     //         AndroidUiSettings(
//     //           lockAspectRatio: true,
//     //         ),
//     //       ]);
//     //   if (croppedFile != null) {
//     //      File(croppedFile.path);
//     //     // imageFile = croppedFile;
//     //   } else {
//     //     return;
//     //   }
//     // }

//     File file = File(imageFile.path);
//     setState(() {
//       storedImage2 = file;
//     });
//     final appDir = await getApplicationDocumentsDirectory();
//     final fileName = path.basename(imageFile.path);
//     final savedImage = await file.copy('${appDir.path}/$fileName');
//     widget.onSelectImage(savedImage);
//   }

//   // final appDir = await getApplicationDocumentsDirectory();
//   // final fileName = path.basename(imageFile.path);
//   // final savedImage =
//   //     await File(imageFile.path).copy('${appDir.path}/$fileName');
//   // widget.onSelectImage(savedImage);

//   Future takepicture() async {
//     // final storage = FirebaseStorage.instance;
//     final ImagePicker picker = ImagePicker();

//     // Check for permissiom
//     // await Permission.photos.request();
//     // var permissionStatus = await Permission.photos.status;
//     // if (permissionStatus.isGranted) {
//     // Select Image
//     image =
//         await picker.pickImage(source: ImageSource.gallery, imageQuality: 40);

//     if (image == null) return;
//     //   if (image != null) {
//     //     CroppedFile croppedFile = await ImageCropper().cropImage(
//     //         sourcePath: image.path,
//     //         compressQuality: 50,
//     //         uiSettings: [
//     //           AndroidUiSettings(
//     //             lockAspectRatio: true,
//     //           ),
//     //         ]);
//     //     if (croppedFile != null) {
//     //       return File(croppedFile.path);
//     //     } else {
//     //       return null;
//     //     }
//     //   }

//     File file = File(image.path);

//     setState(() {
//       storedImage = file;
//     });

//     final appDir = await getApplicationDocumentsDirectory();
//     final fileName = path.basename(image.path);
//     final savedImage = await file.copy('${appDir.path}/$fileName');
//     widget.onSelectImage(savedImage);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
        // Container(
        //   height: 200,
        //   width: 200,
        //   alignment: Alignment.center,
        //   decoration: BoxDecoration(
        //     border: Border.all(width: 1, color: Colors.grey),
        //   ),
        //   child: (storedImage == null && storedImage2 == null)
        //       ? const Text(
        //           'No Image',
        //           textAlign: TextAlign.center,
        //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        //         )
        //       : Image.file(
        //           // isCamera ?
        //           // storedImage,
        //           //  :
        //           storedImage2,
        //           height: 200,
        //           width: 200,
        //           fit: BoxFit.cover,
        //         ),
        // ),
        // SizedBox(height: 5),
        // Center(
        //   child: TextButton(
        //     onPressed: () {
        //       Get.dialog(Dialog(
        //         child: Container(
        //           height: 100,
        //           child: Row(
        //             mainAxisSize: MainAxisSize.min,
        //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //             children: [
        //               GestureDetector(
        //                 onTap: () async {
                          // takePicture2();
                          // final ImagePicker picker = ImagePicker();
                          // final imageFile = await picker.pickImage(
                          //     source: ImageSource.camera,
                          //     maxWidth: 500,
                          //     maxHeight: 500,
                          //     imageQuality: 40);
                          // setState(() {
                          //   isCamera = !isCamera;
                          // });
                          // Get.back();

                          // XFile pickedFile = await ImagePicker().pickImage(
                          //     source: ImageSource.camera, imageQuality: 40);
                          // if (pickedFile != null) {
                          //   setState(() {
                          //     storedImage = File(pickedFile.path);
                          //   });
                          // }
        //                 },
        //                 child: Column(
        //                     mainAxisSize: MainAxisSize.min,
        //                     children: const [
        //                       Icon(Iconsax.camera5),
        //                       SizedBox(height: 10),
        //                       Text(
        //                         'Camera',
        //                         style: TextStyle(
        //                           fontSize: 16,
        //                           fontWeight: FontWeight.bold,
        //                         ),
        //                       )
        //                     ]),
        //               ),
        //               GestureDetector(
        //                 onTap: () async {
        //                   // takepicture();
        //                   // setState(() {
        //                   //   isCamera = !isCamera;
        //                   // });
        //                   XFile pickedFile = await ImagePicker().pickImage(
        //                       source: ImageSource.gallery, imageQuality: 40);
        //                   if (pickedFile != null) {
        //                     setState(() {
        //                       storedImage2 = File(pickedFile.path);
        //                     });
        //                   }
        //                   Get.back();
        //                 },
        //                 child: Column(
        //                     mainAxisSize: MainAxisSize.min,
        //                     children: const [
        //                       Icon(Iconsax.gallery),
        //                       SizedBox(height: 10),
        //                       Text('Galley',
        //                           style: TextStyle(
        //                             fontSize: 16,
        //                             fontWeight: FontWeight.bold,
        //                           ))
        //                     ]),
        //               ),
        //             ],
        //           ),
        //         ),
        //       ));
        //     },
        //     child: const Text(
        //       'Add Image',
        //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        //     ),
        //   ),
        // )
//       ],
//     );
//   }
// }
