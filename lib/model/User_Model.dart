
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

UserModel? userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel? data) => json.encode(data!.toJson());

class UserModel {
  UserModel({
    this.id,
    this.name,
    this.username,
    this.phone,
    this.imageUrl,
    this.imagePath,
    this.fcm,
    this.email,
    this.password,
    this.userId,
  });

  String? id;
  String? name;
  String? username;
  String? phone;
  String? imageUrl;
  String? imagePath;
  String? fcm;
  String? email;
  String? password;
  String? userId;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    name: json["name"],
    username: json["username"],
    phone: json["phone"],
    imageUrl: json["imageUrl"],
    imagePath: json["imagePath"],
    fcm: json["fcm"],
    email: json["email"],
    password: json["password"],
    userId: json["user_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "username": username,
    "phone": phone,
    "imageUrl": imageUrl,
    "imagePath": imagePath,
    "fcm": fcm,
    "email": email,
    "password": password,
    "user_id": userId,
  };
  factory UserModel.fromFirebaseSnapshot(DocumentSnapshot<Map<String, dynamic>> json) => UserModel(
    id: json.id,
    name: json["name"],
    username: json["username"],
    phone: json["phone"],
    imageUrl: json["imageUrl"],
    imagePath: json["imagePath"],
    fcm: json["fcm"],
    email: json["email"],
    password: json["password"],
    userId: json["user_id"],
  );
}
