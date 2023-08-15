

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

RecipeModel? recipeModelFromJson(String str) => RecipeModel.fromJson(json.decode(str));

String recipeModelToJson(RecipeModel? data) => json.encode(data!.toJson());

class RecipeModel {
  RecipeModel({
    this.id,
    this.userId,
    this.categoryId,
    this.recipeName,
    this.recipePrice,
    this.recipeDescription,
    this.imageUrl,
    this.imagePath,
  });

  String? id;
  String? userId;
  String? categoryId;
  String? recipeName;
  num? recipePrice;
  String? recipeDescription;
  String? imageUrl;
  String? imagePath;

  factory RecipeModel.fromJson(Map<String, dynamic> json) => RecipeModel(
    id: json["id"],
    userId: json["user_id"],
    categoryId: json["category_id"],
    recipeName: json["recipeName"],
    recipePrice: json["recipePrice"].toDouble(),
    recipeDescription: json["recipeDescription"],
    imageUrl: json["imageUrl"],
    imagePath: json["imagePath"],
  );



  factory RecipeModel.fromFirebaseSnapshot(DocumentSnapshot<Map<String, dynamic>> json) => RecipeModel(
    id: json.id,
    userId: json["user_id"],
    categoryId: json["category_id"],
    recipeName: json["recipeName"],
    recipePrice: json["recipePrice"].toDouble(),
    recipeDescription: json["recipeDescription"],
    imageUrl: json["imageUrl"],
    imagePath: json["imagePath"],
  );


  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "category_id": categoryId,
    "recipeName": recipeName,
    "recipePrice": recipePrice,
    "recipeDescription": recipeDescription,
    "imageUrl": imageUrl,
    "imagePath": imagePath,
  };
}
