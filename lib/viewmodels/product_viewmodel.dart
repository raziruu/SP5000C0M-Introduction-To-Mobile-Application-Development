import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/recipe_model.dart';
import '../repositories/recipe_repositories.dart';

class recipeViewModel with ChangeNotifier {
  RecipeRepository _recipeRepository = RecipeRepository();
  List<RecipeModel> _recipes = [];
  List<RecipeModel> get recipes => _recipes;

  Future<void> getrecipes() async{
    _recipes=[];
    notifyListeners();
    try{
      var response = await _recipeRepository.getAllRecipes();
      for (var element in response) {
        print(element.id);
        _recipes.add(element.data());
      }
      notifyListeners();
    }catch(e){
      print(e);
      _recipes = [];
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
