import 'dart:io';

import 'package:car_wash/components/uploader.dart';
import 'package:car_wash/provider/alert_provider.dart';
import 'package:car_wash/serviceLocator.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageCapture extends StatefulWidget {
  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  File? _imageFile;
  final picker = ImagePicker();
  final AlertProvider _alertProvider = serviceLocator<AlertProvider>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            IconButton(
                icon: Icon(Icons.photo_camera),
                onPressed: () => _pickImage(ImageSource.camera)),
            IconButton(
                icon: Icon(Icons.photo_library),
                onPressed: () => _pickImage(ImageSource.gallery))
          ],
        ),
      ),
      body: ListView(
        children: [
          if (_imageFile != null) ...[
            Image.file(_imageFile!),
            Row(
              children: [
                FlatButton(onPressed: _cropImage, child: Icon(Icons.crop))
              ],
            ),
            Uploader(file: _imageFile!)
          ]
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        _alertProvider.showErrorMessage(context, "Error", "No Image Selected");
      }
    });
  }

  void clear() {
    setState(() {
      _imageFile = null;
    });
  }

  Future<void> _cropImage() async {
    File? cropped = await ImageCropper.cropImage(
      sourcePath: _imageFile!.path,
    );

    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }
}
