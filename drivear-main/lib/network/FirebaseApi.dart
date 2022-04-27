
import 'dart:async';

import 'package:car_wash/models/message_model.dart';
import 'package:car_wash/models/car_wash_model.dart';
import 'package:car_wash/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseApi {
  static Future<String> createCarWash(Wash carWash) async {
    final docCarWash = FirebaseFirestore.instance.collection('car_wash').doc();

    carWash.id = docCarWash.id;
    await docCarWash.set(carWash.toJson());

    return docCarWash.id;
  }

  static Stream<List<Wash>> readCarWashs() =>
      FirebaseFirestore.instance
          .collection('car_wash').snapshots()
          .transform(
            Utils.transformer(Wash.fromJson) as StreamTransformer<QuerySnapshot, List<Wash>>
          );

  static Future<void> signUp() async {

  }
}