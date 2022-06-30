import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

CollectionReference imageRef;
storage.Reference ref;
File storedImage;
File storedImage2;
String imageUrl;
XFile image;

bool isCamera = false;

class ImageInput {
  // Future<File> pickImage({ImageSource imageSource}) async {
  //   try {
  //     // pick image from gallery
  //     XFile pickedFile = await ImagePicker()
  //         .pickImage(source: ImageSource.gallery, imageQuality: 40);

  //     if (pickedFile != null) {
  //       CroppedFile croppedFile = await ImageCropper().cropImage(
  //           sourcePath: pickedFile.path,
  //           compressQuality: 50,
  //           uiSettings: [
  //             AndroidUiSettings(
  //               lockAspectRatio: false,
  //             ),
  //           ]);
  //       if (croppedFile != null) {
  //         return File(croppedFile.path);
  //       } else {
  //         return null;
  //       }
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     print(e);
  //     return null;
  //   }
  // }
  Future<void> takePicture2({ImageSource imageSource}) async {
    final ImagePicker picker = ImagePicker();
    var imageFile = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 40);

    if (imageFile == null) {
      return;
    }
    if (imageFile != null) {
      CroppedFile croppedFile = await ImageCropper().cropImage(
          sourcePath: imageFile.path,
          compressQuality: 50,
          uiSettings: [
            AndroidUiSettings(
              lockAspectRatio: true,
            ),
          ]);
      if (croppedFile != null) {
        File(croppedFile.path);
        imageFile = croppedFile as XFile;
      } else {
        return;
      }
    }

    // File file = File(imageFile.path);
    // storedImage2 = file;

    // final appDir = await getApplicationDocumentsDirectory();
    // final fileName = path.basename(imageFile.path);
    // final savedImage = await file.copy('${appDir.path}/$fileName');
    // widget.onSelectImage(savedImage);
  }

  // final appDir = await getApplicationDocumentsDirectory();
  // final fileName = path.basename(imageFile.path);
  // final savedImage =
  //     await File(imageFile.path).copy('${appDir.path}/$fileName');
  // widget.onSelectImage(savedImage);

  Future takePicture(ImageSource imageSource) async {
    // final storage = FirebaseStorage.instance;
    final ImagePicker picker = ImagePicker();

    // Check for permissiom
    // await Permission.photos.request();
    // var permissionStatus = await Permission.photos.status;
    // if (permissionStatus.isGranted) {
    // Select Image
    image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 40);

    if (image == null) return;
    //   if (image != null) {
    //     CroppedFile croppedFile = await ImageCropper().cropImage(
    //         sourcePath: image.path,
    //         compressQuality: 50,
    //         uiSettings: [
    //           AndroidUiSettings(
    //             lockAspectRatio: true,
    //           ),
    //         ]);
    //     if (croppedFile != null) {
    //       return File(croppedFile.path);
    //     } else {
    //       return null;
    //     }
    //   }

    File file = File(image.path);

    // storedImage = file;
  }
}
