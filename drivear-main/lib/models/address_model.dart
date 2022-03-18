import 'dart:io';

import 'package:car_wash/models/car_wash_service_model.dart';
import 'package:car_wash/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Address {
  String? id;
  String? city;
  String? location;

  Address({
    this.id,
    this.city,
    this.location,
  });

  static Address fromJson(Map<String, dynamic>? json) => Address(
      id: json!['id'],
      city: json['city'],
      location: json['location'],
  );

  static Address fromSnapshot(DocumentSnapshot snapshot) =>
      snapshot.data() != null
          ? Address.fromJson(snapshot.data()!)
          : Address();


  Map<String, dynamic> toJson() => {
    'id': id,
    'city': city,
    'location': location,
  };

  @override
  String toString() =>
      "id: $id\n"
          "city: $city\n"
          "location: $location\n";

}