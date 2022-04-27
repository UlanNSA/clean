import 'dart:io';

import 'package:car_wash/models/car_wash_service_model.dart';
import 'package:car_wash/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Wash {
  String? id;
  String? name;
  String? imageUrl;
  String? phone;
  List<WashService>? services;
  LatLng? location;
  String? legalAddress;
  double? rating;
  int? avgPrice;
  List<String>? additionalServices;

  Wash({
      this.id,
      this.name,
      this.imageUrl,
      this.services,
      this.location,
      this.legalAddress,
      this.rating,
      this.phone,
      this.avgPrice,
      this.additionalServices
  });

  static Wash fromJson(Map<String, dynamic>? json) => Wash(
    id: json!['id'],
    name: json['name'],
    imageUrl: json['imageUrl'],
      phone: json['phone'],
      legalAddress: json['legalAddress'],
    services: json['services'] != null ? (json['services'] as List<dynamic>).map((e) => WashService.fromJson(e)).toList() : [],
    additionalServices: json['additionalServices'] != null ? (json['additionalServices'] as List<dynamic>).map((e) => e.toString()).toList() : [],
    location: LatLng((json['location'] as List<dynamic>).first, (json['location'] as List<dynamic>).last),
    avgPrice: json['services'] != null ? (json['services'] as List<dynamic>).map((e) => WashService.fromJson(e)).fold(0, ((value, element) => (value as int) + element.price!) ) : 0
  );

  static Wash fromSnapshot(DocumentSnapshot snapshot) =>
      snapshot.data() != null
          ? Wash.fromJson(snapshot.data()!)
          : Wash();


  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'imageUrl': imageUrl,
    'services': services!.map((e) => e.toJson()).toList(),
    'location': [location!.latitude, location!.longitude],
    'rating': rating,
    'legalAddress': legalAddress,
    'additionalServices': additionalServices,
    'phone': phone,
    'avgPrice': avgPrice
  };

  @override
  String toString() =>
      "id: $id\n"
      "name: $name\n"
      "imageUrl: $imageUrl\n"
      "location: $location\n"
      "rating: $rating\n"
      "legalAddress: $legalAddress\n"
      "additionalServices: $additionalServices\n"
      "phone: $phone\n"
      "avgPrice: $avgPrice";

}