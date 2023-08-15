import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/recipe_model.dart';
import '../../viewmodels/authe_viewmodel.dart';
import '../../viewmodels/global_ui_viewmodel.dart';

class MyrecipeScreen extends StatefulWidget {
  const MyrecipeScreen({Key? key}) : super(key: key);

  @override
  State<MyrecipeScreen> createState() => _MyrecipeScreenState();
}

class _MyrecipeScreenState extends State<MyrecipeScreen> {
  late GlobalUIViewModel _ui;
  late AuthViewModel _authViewModel;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ui = Provider.of<GlobalUIViewModel>(context, listen: false);
      _authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      getInit();
    });
    super.initState();
  }

  Future<void> getInit() async {
    _ui.loadState(true);
    try {
      await _authViewModel.getMyrecipes();
    } catch (e) {
      print(e);
    }
    _ui.loadState(false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(builder: (context, authVM, child) {
      return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          label: Text("Add recipe"),
          icon: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).pushNamed("/add-recipe");
          },
        ),
        appBar: AppBar(
          backgroundColor: Colors.black54,
          title: Text("My Recipes"),
        ),
        body: RefreshIndicator(
          onRefresh: getInit,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                if (_authViewModel.myrecipe != null && _authViewModel.myrecipe!.isEmpty) Center(child: Text("You can add your recipes here")),
                if (_authViewModel.myrecipe != null) ...authVM.myrecipe!.map((e) => recipeWidgetList(context, e))
              ],
            ),
          ),
        ),
      );
    });
  }

  InkWell recipeWidgetList(BuildContext context, RecipeModel e) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed("/single-recipe", arguments: e.id);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Card(
          elevation: 5,
          child: ListTile(
            leading: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  e.imageUrl.toString(),
                  height: 300,
                  width: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                    return Image.asset(
                      'assets/images/logo.png',
                      height: 300,
                      width: 100,
                      fit: BoxFit.cover,
                    );
                  },
                )),
            title: Text(e.recipeName.toString()),
            subtitle: Text(e.recipePrice.toString()),
            trailing: Wrap(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed("/edit-recipe", arguments: e.id);
                  },
                  icon: Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () {
                    deleterecipe(e.id.toString());
                  },
                  icon: Icon(Icons.delete),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> deleterecipe(String id) async{
    var response = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete recipe?'),
            content: Text('Are you sure you want to delete this recipe?'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Close')),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  deleteFunction(id);
                },
                child: Text('Delete'),
              )
            ],
          );
        });
  }
  deleteFunction(String id) async{

    _ui.loadState(true);
    try{
      await _authViewModel.deleteMyrecipe(id);
    }catch(e){
      print(e);
    }
    _ui.loadState(false);
  }
}
