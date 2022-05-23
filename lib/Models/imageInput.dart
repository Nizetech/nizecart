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
  File storedImage;
  Future<void> takePicture() async {
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
              ? const Text('No Image', textAlign: TextAlign.center)
              : Image.file(storedImage),
        ),
        SizedBox(height: 5),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: takePicture,
            ),
            TextButton(
                onPressed: takePicture,
                child: Text(
                  'Take Picture',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
          ],
        )
      ],
    );
  }
}
