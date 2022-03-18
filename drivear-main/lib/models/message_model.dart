import 'package:car_wash/models/car_wash_service_model.dart';
import 'package:car_wash/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageModel {
  String? id;
  UserModel? from;
  String? to;
  DateTime? date;
  String? message;
  double? rating;

  MessageModel({
    this.id,
    this.from,
    this.to,
    this.date,
    this.message,
    this.rating
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'from': from!.toJson(),
    'to;': to,
    'date': date.toString(),
    'message': message,
    'rating': rating,
  };

  static MessageModel fromJson(Map<String, dynamic> json) => MessageModel(
    id: json['id'],
    from: UserModel.fromJson(json['from']),
    to: json['to'],
    date: DateTime.parse(json['date']),
    message: json['message'],
    rating: json['rating'] as double,
  );
}

class CommentsCarwashList {
  List<MessageModel>? list = [];


  CommentsCarwashList({
    this.list,
  });

  static CommentsCarwashList fromJson(Map<String, dynamic>? json) => CommentsCarwashList(
    list: (json!['list'] as List<dynamic>).map((e) => MessageModel.fromJson(e)).toList(),
  );

  static CommentsCarwashList fromSnapshot(DocumentSnapshot snapshot) =>
      snapshot.data() != null
          ? CommentsCarwashList.fromJson(snapshot.data()!)
          : CommentsCarwashList(list: <MessageModel>[]);

  Map<String, dynamic> toJson() => {
    'list': list!.map((e) => e.toJson()).toList()
  };

  @override
  String toString() =>
      "list: $list\n";
}