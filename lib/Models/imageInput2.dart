import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class ImageInputs extends StatefulWidget {
  // ImageInputs({Key key}) : super(key: key);
  final Function onSelectImage;
  ImageInputs(this.onSelectImage);

  @override
  State<ImageInputs> createState() => _ImageInputsState();
}

class _ImageInputsState extends State<ImageInputs> {
  CollectionReference imageRef;
  storage.Reference ref;
  // String storedImages;

  // void uploadImage() async {
  //   final _firebaseStorage = FirebaseStorage.instance;
  //   final _imagePicker = ImagePicker();
  //   PickedFile image;
  //   //Check Permissions
  //   // await Permission.photos.request();

  //   // var permissionStatus = await Permission.photos.status;

  //   // if (permissionStatus.isGranted) {
  //   //Select Image
  //   image = (await _imagePicker.pickImage(source: ImageSource.gallery))
  //       as PickedFile;
  //   var file = File(image.path);

  //   if (image != null) {
  //     //Upload to Firebase
  //     var snapshot =
  //         await _firebaseStorage.ref().child('images/imageName').putFile(file);
  //     await snapshot.ref.getDownloadURL().then((value) {
  //       setState(() {
  //         imageUrl = value;
  //       });
  //     });
  //   } else {
  //     print('No Image Path Received');
  //   }
  // }

  File storedImage;
  Future<void> takePicture() async {
    final ImagePicker picker = ImagePicker();
    final ImageFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxWidth: 150,
        maxHeight: 150);

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
          child: storedImage == null
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
            IconButton(icon: Icon(Icons.camera_alt), onPressed: takePicture),
            TextButton(
                onPressed: takePicture,
                child: Text(
                  'Upload Picture',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
          ],
        )
      ],
    );
  }
}
