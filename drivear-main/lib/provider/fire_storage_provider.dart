import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class FireStorageProvider with ChangeNotifier {

  FireStorageProvider();

  Future<dynamic> loadImage(BuildContext context, String path, String filename) async {
    return  await FirebaseStorage.instance.ref().child('$path$filename').getDownloadURL();
  }

  Future<dynamic> loadImageByFullpath(BuildContext context, String fullpath) async {
    return await FirebaseStorage.instance.ref().child('$fullpath').getDownloadURL();
  }
}