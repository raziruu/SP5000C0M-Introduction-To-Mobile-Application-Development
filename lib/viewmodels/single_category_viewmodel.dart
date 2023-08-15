import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/category_model.dart';
import '../model/recipe_model.dart';
import '../repositories/category_repositories.dart';
import '../repositories/recipe_repositories.dart';

class SingleCategoryViewModel with ChangeNotifier {
  CategoryRepository _categoryRepository = CategoryRepository();
  RecipeRepository _recipeRepository = RecipeRepository();
  CategoryModel? _category = CategoryModel();
  CategoryModel? get category => _category;
  List<RecipeModel> _recipes = [];
  List<RecipeModel> get recipes => _recipes;

  Future<void> getrecipeByCategory(String categoryId) async{
    _category=CategoryModel();
    _recipes=[];
    notifyListeners();
    try{
      print(categoryId);
      var response = await _categoryRepository.getCategory(categoryId);
      _category = response.data();
      var recipeResponse = await _recipeRepository.getrecipeByCategory(categoryId);
      for (var element in recipeResponse) {
        _recipes.add(element.data());
      }

      notifyListeners();
    }catch(e){
      _category = null;
      notifyListeners();
    }
  }

}
