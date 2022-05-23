import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class ImageInput extends StatefulWidget {
  final Function onSelectImage;
  ImageInput(this.onSelectImage);

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  XFile imageFile;
  Future<void> takePicture() async {
    final ImagePicker picker = ImagePicker();
    final ImageFile = await picker.pickImage(
        source: ImageSource.gallery, maxWidth: 500, maxHeight: 500);

    if (ImageFile == null) {
      return;
    }

    XFile file = XFile(ImageFile.path);
    setState(() {
      imageFile = file;
    });

    final appDir = await getApplicationDocumentsDirectory();
    final fileName = path.basename(file.path);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
