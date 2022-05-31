// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart' as storage;
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart' as path;
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';

// class ImageInput3 extends StatelessWidget {
//   ImageInput3({Key key}) : super(key: key);

//   CollectionReference imageRef;
//   storage.Reference ref;


// class _ImageInput3State extends State<ImageInput3> {
//   // String storedImages;

//   // void uploadImage() async {
//   //   final _firebaseStorage = FirebaseStorage.instance;
//   //   final _imagePicker = ImagePicker();
//   //   PickedFile image;
//   //   //Check Permissions
//   //   // await Permission.photos.request();

//   //   // var permissionStatus = await Permission.photos.status;

//   //   // if (permissionStatus.isGranted) {
//   //   //Select Image
//   //   image = (await _imagePicker.pickImage(source: ImageSource.gallery))
//   //       as PickedFile;
//   //   var file = File(image.path);

//   //   if (image != null) {
//   //     //Upload to Firebase
//   //     var snapshot =
//   //         await _firebaseStorage.ref().child('images/imageName').putFile(file);
//   //     await snapshot.ref.getDownloadURL().then((value) {
//   //       setState(() {
//   //         imageUrl = value;
//   //       });
//   //     });
//   //   } else {
//   //     print('No Image Path Received');
//   //   }
//   // }

//   File storedImage;
//   String imageUrl;
//   uploadImage() async {
//     final ImagePicker picker = ImagePicker();
//     PickedFile image;
//     final storage = FirebaseStorage.instance;

//     // Check for permissiom
//     await Permission.photos.request();
//     var permissionStatus = await Permission.photos.status;
//     if (permissionStatus.isGranted) {
//       // Select Image
//       image = await picker.pickImage(source: ImageSource.gallery) as PickedFile;
//       var file = File(image.path);
//       setState(() {
//         storedImage = file;
//       });
//       if (image != null) {
//         // Upload to Firebase
//         var snapshot =
//             await storage.ref().child('images/imageName').putFile(file);
//         var downloadUrl = await snapshot.ref.getDownloadURL();
//         setState(() {
//           imageUrl = downloadUrl;
//         });
//       } else {
//         print('No Image Path Received');
//       }
//     } else {
//       print('Permission Denied');
//     }
//   }
    ///
    //   final ImageFile = await picker.pickImage(
    //       source: ImageSource.gallery,
    //       // imageQuality: 50,
    //       maxWidth: 150,
    //       maxHeight: 150);

    //   if (ImageFile == null) {
    //     return;
    //   }

    //   File file = File(ImageFile.path);
    //   setState(() {
    //     storedImage = file;
    //   });

    //   final appDir = await getApplicationDocumentsDirectory();
    //   final fileName = path.basename(file.path);
    //   final savedImage = await file.copy('${appDir.absolute}/$fileName');
    //   widget.onSelectImage(savedImage);
    // }

//     @override
//     Widget build(BuildContext context) {
//       return Column(
//         children: [
//           // Container(
//           //   height: 200,
//           //   width: 200,
//           //   alignment: Alignment.center,
//           //   decoration: BoxDecoration(
//           //     border: Border.all(width: 1, color: Colors.grey),
//           //   ),
//           //   child: (imageUrl == null)
//           //       ? const Text(
//           //           'No Image',
//           //           textAlign: TextAlign.center,
//           //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//           //         )
//           //       : Image.network(
//           //           imageUrl,
//           //           height: 200,
//           //           width: 200,
//           //           fit: BoxFit.cover,
//           //         ),
//           // ),
//           SizedBox(height: 5),
//           Row(
//             children: [
//               IconButton(
//                   icon: Icon(Icons.camera_alt), onPressed: uploadImage()),
//               TextButton(
//                 onPressed: uploadImage(),
//                 child: const Text(
//                   'Upload Picture',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ],
//           )
//         ],
//       );
//     }
//   }}

