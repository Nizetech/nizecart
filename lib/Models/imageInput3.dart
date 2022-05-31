import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class ImageInput3 extends StatefulWidget {
  // ImageInput3({Key key}) : super(key: key);
  final Function onSelectImage;
  ImageInput3(this.onSelectImage);

  @override
  State<ImageInput3> createState() => _ImageInput3State();
}

class _ImageInput3State extends State<ImageInput3> {
  CollectionReference imageRef;
  storage.Reference ref;
  File storedImage;
  String imageUrl;
  XFile image;
  Future<void> takePicture2() async {
    final ImagePicker picker = ImagePicker();
    final ImageFile = await picker.pickImage(
        source: ImageSource.gallery, maxWidth: 500, maxHeight: 500);

    if (ImageFile == null) {
      return;
    }

    File file = File(ImageFile.path);
    setState(() {
      storedImage = file;
    });

    final appDir = await getApplicationDocumentsDirectory();
    final fileName = path.basename(file.path);
    final savedImage = await file.copy('${appDir.path}/$fileName');
    widget.onSelectImage(savedImage);
  }

  Future takepicture() async {
    final storage = FirebaseStorage.instance;
    final ImagePicker picker = ImagePicker();

    // Check for permissiom
    // await Permission.photos.request();
    // var permissionStatus = await Permission.photos.status;
    // if (permissionStatus.isGranted) {
    // Select Image
    image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    var file = File(image.path);
    setState(() {
      storedImage = file;
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);
    final savedImage = await File(image.path).copy('${appDir.path}/$fileName');
    widget.onSelectImage(savedImage);
    // final appDir = await getApplicationDocumentsDirectory();
    // final fileName = basename(image.path);
    // final file = await image.copy('${appDir.path}/$fileName');

    // final savedImage = await file.copy('${appDir.path}/$file');
    // widget.onSelectImage(savedImage);
    // if (image != null) {
    //   // Upload to Firebase
    //   var snapshot =
    //       await storage.ref().child('images/imageName').putFile(file);
    //   var downloadUrl = await snapshot.ref.getDownloadURL();
    //   setState(() {
    //     imageUrl = downloadUrl;
    //   });
    // } else {
    //   print('No Image Path Received');
    // }

    // } else {
    //   print('Permission Denied');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                )
              : Image.file(
                  storedImage,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
        ),
        SizedBox(height: 5),
        Row(
          children: [
            IconButton(icon: Icon(Icons.camera_alt), onPressed: takepicture),
            TextButton(
              onPressed: takepicture,
              child: const Text(
                'Upload Picture',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        )
      ],
    );
  }
}
