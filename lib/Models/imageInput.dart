// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart' as storage;
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart' as path;
// import 'package:path_provider/path_provider.dart';
// // import 'package:permission_handler/permission_handler.dart';

// class ImageInput extends StatefulWidget {
//   final Function onSelectImage;
//   ImageInput(this.onSelectImage);

//   @override
//   State<ImageInput> createState() => _ImageInputState();
// }

// class _ImageInputState extends State<ImageInput> {

//   // File storedImage;
//   // Future<void> takePicture() async {
//   //   final ImagePicker picker = ImagePicker();
//   //   final ImageFile = await picker.pickImage(
//   //       source: ImageSource.gallery,
//   //       imageQuality: 50,
//   //       maxWidth: 150,
//   //       maxHeight: 150);

//   //   if (ImageFile == null) {
//   //     return;
//   //   }

//   //   File file = File(ImageFile.path);
//   //   setState(() {
//   //     storedImage = file;
//   //   });

//   //   final appDir = await getApplicationDocumentsDirectory();
//   //   final fileName = path.basename(file.path);
//   //   final savedImage = await file.copy('${appDir.path}/$fileName');
//   //   widget.onSelectImage(savedImage);
//   // }

//   @override
//   Widget build(BuildContext context) {
//     // } else {
//     //   print('Permission not granted. Try Again with permission access');

//     CollectionReference imageRef;
//     storage.Reference ref;
//     @override
//     Widget build(BuildContext context) {
//       String imageUrl;
//       void uploadImage() async {
//         final _firebaseStorage = FirebaseStorage.instance;
//         final _imagePicker = ImagePicker();
//         PickedFile image;
//         //Check Permissions
//         // await Permission.photos.request();

//         // var permissionStatus = await Permission.photos.status;

//         // if (permissionStatus.isGranted) {
//         //Select Image
//         image = (await _imagePicker.pickImage(source: ImageSource.gallery))
//             as PickedFile;
//         var file = File(image.path);

//         if (image != null) {
//           //Upload to Firebase
//           var snapshot = await _firebaseStorage
//               .ref()
//               .child('images/imageName')
//               .putFile(file);
//                 .whenComplete(() async {
//             ref.getDownloadURL().then((value) {
//               imageRef.add({
//                 'image': value,
//               });
//             });

//           //   var downloadUrl = await snapshot.ref.getDownloadURL();
//           //   setState(() {
//           //     imageUrl = downloadUrl;
//           //   });
//           // });
//         } else {
//           print('No Image Path Received');
//         }
//       }

//       return Column(
//         children: [
//           Container(
//             height: 200,
//             width: 200,
//             alignment: Alignment.center,
//             decoration: BoxDecoration(
//               border: Border.all(width: 1, color: Colors.grey),
//             ),
//             child: (imageUrl == null)
//                 ? const Text(
//                     'No Image',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//                   )
//                 : Image.network(
//                     imageUrl,
//                     fit: BoxFit.cover,
//                     width: 200,
//                     height: 200,
//                   ),
//           ),
//           SizedBox(height: 5),
//           Row(
//             children: [
//               IconButton(
//                 icon: Icon(Icons.camera_alt),
//                 onPressed: uploadImage,
//               ),
//               TextButton(
//                   onPressed: uploadImage,
//                   child: Text(
//                     'Upload Picture',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   )),
//             ],
//           )
//         ],
//       );
//     }
//   }

// // class Storage {
// //   final storage = FirebaseStorage.instance;

// //   Future<void> uploadFile(
// //     String filePath,
// //     String fileName,
// //   ) async {
// //     File file = File(filePath);

// //     try {
// //       await storage.ref().child(fileName).putFile(file);
// //     } on Exception catch (e) {
// //       print(e);
// //     }
// //   }
// //

// import 'package:flutter/material.dart';

