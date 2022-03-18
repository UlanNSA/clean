import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String? id;
  String? firstName;
  String? displayName;
  String? lastName;
  String? email;
  String? phone;
  String? profileImageUrl;

  UserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.displayName,
    this.email,
    this.phone,
    this.profileImageUrl,
  });

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'],
      firstName: json['firstName'] ?? "",
      lastName: json['lastName'] ?? "",
      displayName: json['displayName'] ?? "",
      email: json['email'],
      phone: json['phone'] ?? "",
      profileImageUrl: json['profileImageUrl'],

  );

  static UserModel fromJson2(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    firstName: json['firstName'] ?? "",
    lastName: json['lastName'] ?? "",
    displayName: json['displayName'] ?? "",
    email: json['email'],
    phone: json['phone'] ?? "",
    profileImageUrl: json['profileImageUrl'],

  );

  static UserModel fromSnapshot(DocumentSnapshot snapshot) => snapshot.data() != null
      ? UserModel.fromJson(snapshot.data()!)
      : UserModel();

  static UserModel fromCredentials(User _user) => UserModel(
    id: _user.uid,
    displayName: _user.displayName,
    profileImageUrl: _user.photoURL,
    email: _user.email,
    phone: _user.phoneNumber,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'displayName': displayName,
    'email': email,
    'phone': phone,
    'profileImageUrl': profileImageUrl,
  };

  @override
  String toString() =>
          "id: $id\n"
          "firstName: $firstName\n"
          "lastName: $lastName\n"
          "displayName: $displayName\n"
          "email: $email\n"
          "phone: $phone\n"
          "profileImageUrl: $profileImageUrl\n";

}