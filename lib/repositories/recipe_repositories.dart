import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/recipe_model.dart';
import '../services/firebase_service.dart';

class RecipeRepository {
  CollectionReference<RecipeModel> recipeRef = FirebaseService.db.collection("recipes").withConverter<RecipeModel>(
        fromFirestore: (snapshot, _) {
          return RecipeModel.fromFirebaseSnapshot(snapshot);
        },
        toFirestore: (model, _) => model.toJson(),
      );

  Future<List<QueryDocumentSnapshot<RecipeModel>>> getAllRecipes() async {
    try {
      final response = await recipeRef.get();
      var recipes = response.docs;
      return recipes;
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future<List<QueryDocumentSnapshot<RecipeModel>>> getrecipeByCategory(String id) async {
    try {
      final response = await recipeRef.where("category_id", isEqualTo: id.toString()).get();
      var recipes = response.docs;
      return recipes;
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future<List<QueryDocumentSnapshot<RecipeModel>>> getrecipeFromList(List<String> recipeIds) async {
    try {
      final response = await recipeRef.where(FieldPath.documentId, whereIn: recipeIds).get();
      var recipes = response.docs;
      return recipes;
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future<List<QueryDocumentSnapshot<RecipeModel>>> getMyrecipes(String userId) async {
    try {
      final response = await recipeRef.where("user_id", isEqualTo: userId).get();
      var recipes = response.docs;
      return recipes;
    } catch (err) {
      print(err);
      rethrow;
    }
  }


  Future<bool> removerecipe(String recipeId, String userId) async {
    try {
      final response = await recipeRef.doc(recipeId).get();
      if(response.data()!.userId !=  userId){
        return false;
      }
      await recipeRef.doc(recipeId).delete();
      return true;
    } catch (err) {
      print(err);
      rethrow;
    }
  }



  Future<DocumentSnapshot<RecipeModel>> getOnerecipe(String id) async {
    try {
      final response = await recipeRef.doc(id).get();
      if (!response.exists) {
        throw Exception("recipe doesnot exists");
      }
      return response;
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future<bool?> addrecipes({required RecipeModel recipe}) async {
    try {
      final response = await recipeRef.add(recipe);
      return true;
    } catch (err) {
      return false;
    }
  }

  Future<bool?> editrecipe({required RecipeModel recipe, required String recipeId}) async {
    try {
      final response = await recipeRef.doc(recipeId).set(recipe);
      return true;
    } catch (err) {
      return false;
    }
  }

  Future<bool?> favorites({required RecipeModel recipe}) async {
    try {
      final response = await recipeRef.add(recipe);
      return true;
    } catch (err) {
      return false;
      rethrow;
    }
  }
}
