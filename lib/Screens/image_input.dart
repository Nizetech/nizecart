import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

CollectionReference imageRef;
storage.Reference ref;
// File storedImage;
// File storedImage2;
String imageUrl;
XFile image;

bool isCamera = false;

class ImageInput {
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
  }

  Future takePicture(ImageSource imageSource) async {
    // final storage = FirebaseStorage.instance;
    final ImagePicker picker = ImagePicker();
    image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 40);

    if (image == null) return;

    File file = File(image.path);
  }
}
