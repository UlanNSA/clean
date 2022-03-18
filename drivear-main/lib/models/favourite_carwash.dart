import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavouriteCarwash {
  String? id;
  bool? likeOrDislike;

  FavouriteCarwash({
    this.id,
    this.likeOrDislike,
  });

  static FavouriteCarwash fromJson(Map<String, dynamic> json) => FavouriteCarwash(
    id: json['id'],
    likeOrDislike: json['likeOrDislike'] as bool,

  );

  static FavouriteCarwash fromSnapshot(DocumentSnapshot snapshot) => snapshot.data() != null ? FavouriteCarwash.fromJson(snapshot.data()  !) : FavouriteCarwash();

  Map<String, dynamic> toJson() => {
    'id': id,
    'likeOrDislike': likeOrDislike,
  };

  @override
  String toString() =>
      "id: $id\n"
          "likeOrDislike: $likeOrDislike\n";
}

class FavouriteCarwashList {
  List<FavouriteCarwash>? list = [];


  FavouriteCarwashList({
    this.list,
  });

  static FavouriteCarwashList fromJson(Map<String, dynamic>? json) => FavouriteCarwashList(
    list: (json!['list'] as List<dynamic>).map((e) => FavouriteCarwash.fromJson(e)).toList(),
  );

  static FavouriteCarwashList fromSnapshot(DocumentSnapshot snapshot) =>
      snapshot.data() != null
          ? FavouriteCarwashList.fromJson(snapshot.data()!)
          : FavouriteCarwashList(list: <FavouriteCarwash>[]);

  Map<String, dynamic> toJson() => {
    'list': list!.map((e) => e.toJson()).toList()
  };

  @override
  String toString() =>
      "list: $list\n";
}