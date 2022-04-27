import 'dart:io';

class WashService {
  final int? id;
  final String? name;
  final String? imageUrl;
  final String? description;
  final int? price;

  WashService({
    this.id,
    this.name,
    this.imageUrl,
    this.description,
    this.price
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'imageUrl':imageUrl,
    'description': description,
    'price': price
  };

  static WashService fromJson(Map<String, dynamic> json) => WashService(
    id: json['id'],
    name: json['name'],
    imageUrl: json['imageUrl'],
    description: json['description'],
    price: json['price'],
  );
}