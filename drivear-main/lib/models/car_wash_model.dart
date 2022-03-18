import 'dart:io';

import 'package:car_wash/models/car_wash_service_model.dart';
import 'package:car_wash/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CarWash {
  String? id;
  String? name;
  String? imageUrl;
  String? phone;
  List<CarWashService>? services;
  LatLng? location;
  String? legalAddress;
  double? rating;
  int? avgPrice;
  List<String>? additionalServices;

  CarWash({
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

  static CarWash fromJson(Map<String, dynamic>? json) => CarWash(
    id: json!['id'],
    name: json['name'],
    imageUrl: json['imageUrl'],
      phone: json['phone'],
      legalAddress: json['legalAddress'],
    services: json['services'] != null ? (json['services'] as List<dynamic>).map((e) => CarWashService.fromJson(e)).toList() : [],
    additionalServices: json['additionalServices'] != null ? (json['additionalServices'] as List<dynamic>).map((e) => e.toString()).toList() : [],
    location: LatLng((json['location'] as List<dynamic>).first, (json['location'] as List<dynamic>).last),
    avgPrice: json['services'] != null ? (json['services'] as List<dynamic>).map((e) => CarWashService.fromJson(e)).fold(0, ((value, element) => (value as int) + element.price!) ) : 0
  );

  static CarWash fromSnapshot(DocumentSnapshot snapshot) =>
      snapshot.data() != null
          ? CarWash.fromJson(snapshot.data()!)
          : CarWash();


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