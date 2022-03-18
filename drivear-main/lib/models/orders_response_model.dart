import 'package:car_wash/models/car_wash_service_model.dart';
import 'package:car_wash/models/order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderResponse {
  List<Order>? orders;

  OrderResponse({
    this.orders
  });

  Map<String, dynamic> toJson() => {
    'orders': orders!.map((e) => e.toJson()).toList(),
  };

  static OrderResponse fromJson(Map<String, dynamic> json) => OrderResponse(
    orders: (json['orders'] as List<dynamic>).map((e) => Order.fromJson(e)).toList(),
  );

  static OrderResponse fromSnapshot(DocumentSnapshot snapshot) => snapshot.data() != null ? OrderResponse.fromJson(snapshot.data()!) : OrderResponse(orders: []);

}