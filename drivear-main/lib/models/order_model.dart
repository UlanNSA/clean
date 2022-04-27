import 'package:car_wash/models/car_wash_model.dart';
import 'package:car_wash/models/car_wash_service_model.dart';
import 'package:flutter/material.dart';

class Order {
  String? id;
  List<WashService>? services;
  DateTime? date;
  TimeOfDay? time;
  int? price;
  Wash? carWashName;
  String? carType;
  String? serviceType;
  String? status;
  String? userid;

  Order(
      {this.id,
      this.services,
      this.date,
      this.time,
      this.price,
      this.status,
      this.carType,
      this.serviceType,
      this.userid,
      this.carWashName});

  Map<String, dynamic> toJson() => {
        'id': id,
        'services': services!.map((e) => e.toJson()).toList(),
        'date': date.toString(),
        'time': '${time!.hour}:${time!.minute}',
        'price': price,
        'carWashName': carWashName!.toJson(),
        'carType': carType,
        'serviceType': serviceType,
        'status': status,
        'userid': userid
      };

  static Order fromJson(Map<String, dynamic> json) => Order(
        id: json['id'],
        services: (json['services'] as List<dynamic>)
            .map((e) => WashService.fromJson(e))
            .toList(),
        date: DateTime.parse(json['date']),
        time: TimeOfDay(
            hour: int.parse(json['time'].toString().split(':')[0]),
            minute: int.parse(json['time'].toString().split(':')[1])),
        price: json['price'],
        carType: json['carType'],
        serviceType: json['serviceType'],
        status: json['status'],
        userid: json['userid'],
        carWashName: Wash.fromJson(json['carWashName']),
      );
}
