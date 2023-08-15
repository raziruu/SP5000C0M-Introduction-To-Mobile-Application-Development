// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import '../model/User_Model.dart';
// import '../repositories/user_repository.dart';
// import '../services/firebase_service.dart';
//
// class AuthViewModel with ChangeNotifier {
//   User? _user = FirebaseService.firebaseAuth.currentUser;
//
//   User? get user => _user;
//
//   Future<void> login(String email, String password) async {
//     try {
//       var response = await UserRepository().login(email, password);
//       _user = response.user;
//       notifyListeners();
//     } catch (err) {
//       rethrow;
//     }
//   }
//
//   Future<void> register(UserModel user) async {
//     try {
//       var response = await UserRepository().register(user);
//       _user = response!.user;
//       notifyListeners();
//     } catch (err) {
//       rethrow;
//     }
//   }
//
//   Future<void> logout() async{
//     try{
//       await UserRepository().logout();
//       _user = null;
//       notifyListeners();
//     }catch(e){
//       rethrow;
//     }
//   }
// }


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Services/firebase_service.dart';
import '../model/User_Model.dart';
import '../model/favorite_model.dart';
import '../model/recipe_model.dart';
import '../repositories/favorite_repositories.dart';
import '../repositories/recipe_repositories.dart';
import '../repositories/user_repository.dart';

class AuthViewModel with ChangeNotifier {
  User? _user = FirebaseService.firebaseAuth.currentUser;

  User? get user => _user;

  UserModel? _loggedInUser;

  UserModel? get loggedInUser => _loggedInUser;


  Future<void> login(String email, String password) async {
    try {
      var response = await UserRepository().login(email, password);
      _user = response.user;
      _loggedInUser = await UserRepository().getUserDetail(_user!.uid);
      notifyListeners();
    } catch (err) {
      UserRepository().logout();
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await UserRepository().resetPassword(email);
      notifyListeners();
    } catch (err) {
      rethrow;
    }
  }


  Future<void> register(UserModel user) async {
    try {
      var response = await UserRepository().register(user);
      _user = response!.user;
      _loggedInUser = await UserRepository().getUserDetail(_user!.uid);
      notifyListeners();
    } catch (err) {
      UserRepository().logout();
      rethrow;
    }
  }


  Future<void> checkLogin() async {
    try {
      _loggedInUser = await UserRepository().getUserDetail(_user!.uid);
      notifyListeners();
    } catch (err) {
      _user = null;
      UserRepository().logout();
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await UserRepository().logout();
      _user = null;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  FavoriteRepository _favoriteRepository = FavoriteRepository();
  List<FavoriteModel> _favorites = [];
  List<FavoriteModel> get favorites => _favorites;


  List<RecipeModel>? _favoriterecipe;
  List<RecipeModel>? get favoriterecipe => _favoriterecipe;

  Future<void> getFavoritesUser() async{
    try{
      var response = await _favoriteRepository.getFavoritesUser(loggedInUser!.userId!);
      _favorites=[];
      for (var element in response) {
        _favorites.add(element.data());
      }
      _favoriterecipe=[];
      if(_favorites.isNotEmpty){

        var recipeResponse = await RecipeRepository().getrecipeFromList(_favorites.map((e) => e.recipeId).toList());
        for (var element in recipeResponse) {
          _favoriterecipe!.add(element.data());
        }
      }

      notifyListeners();
    }catch(e){
      print(e);
      _favorites = [];
      _favoriterecipe=null;
      notifyListeners();
    }
  }

  Future<void> favoriteAction(FavoriteModel? isFavorite, String recipeId) async{
    try{
      await _favoriteRepository.favorite(isFavorite, recipeId, loggedInUser!.userId! );
      await getFavoritesUser();
      notifyListeners();
    }catch(e){
      _favorites = [];
      notifyListeners();
    }
  }


  List<RecipeModel>? _myrecipe;
  List<RecipeModel>? get myrecipe => _myrecipe;

  Future<void> getMyrecipes() async{
    try{
      var recipeResponse = await RecipeRepository().getMyrecipes(loggedInUser!.userId!);
      _myrecipe=[];
      for (var element in recipeResponse) {
        _myrecipe!.add(element.data());
      }
      notifyListeners();
    }catch(e){
      print(e);
      _myrecipe=null;
      notifyListeners();
    }
  }

  Future<void> addMyrecipe(RecipeModel recipe)async {
    try{
      await RecipeRepository().addrecipes(recipe: recipe);

      await getMyrecipes();
      notifyListeners();
    }catch(e){

    }
  }


  Future<void> editMyrecipe(RecipeModel recipe, String recipeId)async {
    try{
      await RecipeRepository().editrecipe(recipe: recipe, recipeId: recipeId);
      await getMyrecipes();
      notifyListeners();
    }catch(e){

    }
  }
  Future<void> deleteMyrecipe(String recipeId) async{
    try{
      await RecipeRepository().removerecipe(recipeId, loggedInUser!.userId!);
      await getMyrecipes();
      notifyListeners();
    }catch(e){
      print(e);
      _myrecipe=null;
      notifyListeners();
    }
  }

}
