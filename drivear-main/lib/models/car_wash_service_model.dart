import 'dart:io';

class CarWashService {
  final int? id;
  final String? name;
  final String? imageUrl;
  final String? description;
  final int? price;

  CarWashService({
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

  static CarWashService fromJson(Map<String, dynamic> json) => CarWashService(
    id: json['id'],
    name: json['name'],
    imageUrl: json['imageUrl'],
    description: json['description'],
    price: json['price'],
  );
}