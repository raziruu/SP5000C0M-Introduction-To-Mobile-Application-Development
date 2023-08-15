import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/category_model.dart';
import '../services/firebase_service.dart';

class CategoryRepository{
  CollectionReference<CategoryModel> categoryRef = FirebaseService.db.collection("categories")
      .withConverter<CategoryModel>(
    fromFirestore: (snapshot, _) {
      return CategoryModel.fromFirebaseSnapshot(snapshot);
    },
    toFirestore: (model, _) => model.toJson(),
  );
    Future<List<QueryDocumentSnapshot<CategoryModel>>> getCategories() async {
    try {
      var data = await categoryRef.get();
      bool hasData = data.docs.isNotEmpty;
      if(!hasData){
        makeCategory().forEach((element) async {
          await categoryRef.add(element);
        });
      }
      final response = await categoryRef.get();
      var category = response.docs;
      return category;
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future<DocumentSnapshot<CategoryModel>>  getCategory(String categoryId) async {
      try{
        print(categoryId);
        final response = await categoryRef.doc(categoryId).get();
        return response;
      }catch(e){
        rethrow;
      }
  }

  List<CategoryModel> makeCategory(){
      return [
        CategoryModel(categoryName: "Breakfast", status: "active", imageUrl: "https://w0.peakpx.com/wallpaper/332/146/HD-wallpaper-food-breakfast-coffee.jpg"),
        CategoryModel(categoryName: "Lunch", status: "active", imageUrl: "https://w0.peakpx.com/wallpaper/780/28/HD-wallpaper-delicious-meal-meal-lunch-delicious-food-meat-salad.jpg"),
        CategoryModel(categoryName: "Brunch", status: "active", imageUrl: "https://w0.peakpx.com/wallpaper/760/294/HD-wallpaper-republic-day-brunching-chennai-chefs-roll-out-dishes-from-every-indian-state-and-tri-coloured-dess-north-indian-food.jpg"),
        CategoryModel(categoryName: "Snacks", status: "active", imageUrl: "https://img.taste.com.au/kMIpM7sp/taste/2018/03/vegie-loaded-pumpkin-and-cheese-muffins-136248-1.jpg"),
        CategoryModel(categoryName: "Dinner", status: "active", imageUrl: "https://w0.peakpx.com/wallpaper/363/405/HD-wallpaper-dinner-meal-meat-food.jpg"),
      ];
  }



}