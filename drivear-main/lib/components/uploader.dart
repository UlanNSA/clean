import 'dart:io';

import 'package:car_wash/provider/auth_provider.dart';
import 'package:car_wash/serviceLocator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Uploader extends StatefulWidget {
  final File file;

  const Uploader({Key? key, required this.file}) : super(key: key);
  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final AuthProvider _authProvider = serviceLocator<AuthProvider>();

  UploadTask? _uploadTask;

  void _startUpload() {
    String filePath = 'images/${_authProvider.currentUser!.id}.png';
    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      return StreamBuilder<TaskSnapshot>(
        stream: _uploadTask!.snapshotEvents,
        builder: (context, snapshot) {
          var event = snapshot.data;

          double progressPercent =
              event != null ? event.bytesTransferred / event.totalBytes : 0;

          return Column(
            children: [
              if (snapshot.data != null &&
                  snapshot.data!.state == TaskState.success)
                Text("Successfully Uploaded"),
              if (snapshot.data != null &&
                  snapshot.data!.state == TaskState.paused)
                FlatButton(
                    child: Icon(Icons.play_arrow),
                    onPressed: () {
                      _uploadTask!.resume();
                    }),
              if (snapshot.data != null &&
                  snapshot.data!.state == TaskState.running)
                FlatButton(
                    onPressed: () {
                      _uploadTask!.pause();
                    },
                    child: Icon(Icons.pause)),
              LinearProgressIndicator(
                value: progressPercent,
              ),
              Text('${(progressPercent * 100).toStringAsFixed(2)} %'),
            ],
          );
        },
      );
    } else {
      return FlatButton.icon(
          onPressed: _startUpload,
          icon: Icon(Icons.cloud_upload),
          label: Text('Upload'));
    }
  }
}
