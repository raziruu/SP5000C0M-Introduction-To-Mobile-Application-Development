import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/recipe_model.dart';
import '../repositories/recipe_repositories.dart';

class SinglerecipeViewModel with ChangeNotifier {
  RecipeRepository _recipeRepository = RecipeRepository();
  RecipeModel? _recipe = RecipeModel();
  RecipeModel? get recipe => _recipe;

  Future<void> getrecipes(String recipeId) async{
    _recipe=RecipeModel();
    notifyListeners();
    try{
      var response = await _recipeRepository.getOnerecipe(recipeId);
      _recipe = response.data();
      notifyListeners();
    }catch(e){
      _recipe = null;
      notifyListeners();
    }
  }

  Future<void> addrecipe(RecipeModel recipe) async{
    try{
      var response = await _recipeRepository.addrecipes(recipe: recipe);
    }catch(e){
      notifyListeners();
    }
  }

}
