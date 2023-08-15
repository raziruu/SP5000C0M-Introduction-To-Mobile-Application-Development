

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

FavoriteModel favoriteModelFromJson(String str) => FavoriteModel.fromJson(json.decode(str));

String favoriteModelToJson(FavoriteModel data) => json.encode(data.toJson());

class FavoriteModel {
  FavoriteModel({
    required this.userId,
    this.id,
    required this.recipeId,
  });

  String? id;
  String userId;
  String recipeId;

  factory FavoriteModel.fromJson(Map<String, dynamic> json) => FavoriteModel(
    id: json["id"],
    userId: json["user_id"],
    recipeId: json["recipe_id"],
  );
  factory FavoriteModel.fromFirebaseSnapshot(DocumentSnapshot<Map<String, dynamic>> json) => FavoriteModel(
    id: json.id,
    userId: json["user_id"],
    recipeId: json["recipe_id"],
  );


  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "id": id,
    "recipe_id": recipeId,
  };
}
