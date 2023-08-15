import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/favorite_model.dart';
import '../../viewmodels/authe_viewmodel.dart';
import '../../viewmodels/global_ui_viewmodel.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late GlobalUIViewModel _ui;
  late AuthViewModel _authViewModel;
  String? recipeId;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      _ui = Provider.of<GlobalUIViewModel>(context, listen: false);
    });
    super.initState();
  }

  Future<void> getInit() async {
    _ui.loadState(true);
    try{
      await _authViewModel.getFavoritesUser();
    }catch(e){

    }
    _ui.loadState(false);
  }

  Future<void> removeFavorite(
      FavoriteModel isFavorite, String recipeId) async {
    _ui.loadState(true);
    try {
      await _authViewModel.favoriteAction(isFavorite, recipeId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Favorite updated.")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Something went wrong. Please try again.")));
      print(e);
    }
    _ui.loadState(false);
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(builder: (context, authVM, child) {
      return Container(
        child: RefreshIndicator(
          onRefresh: getInit,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child:
            authVM.favoriterecipe == null ?
            Column(
              children: [
                Center(child: Text("Something went wrong")),
              ],
            ) :
            authVM.favoriterecipe!.length == 0
                ? Column(
                    children: [
                      Center(child: Text("Please add to favorite")),
                    ],
                  )
                : Column(children: [
                  SizedBox(height: 10,),
                    ...authVM.favoriterecipe!.map(
                      (e) => InkWell(
                        onTap: (){
                          Navigator.of(context).pushNamed("/single-recipe", arguments: e.id!);
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Card(
                            child: ListTile(
                              trailing: IconButton(
                                iconSize: 25,
                                onPressed: (){
                                    removeFavorite(_authViewModel.favorites.firstWhere((element) => element.recipeId == e.id), e.id!);
                                },
                                  icon: Icon(Icons.delete_outlined, color: Colors.red,),
                              ),
                              leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.network(
                                    e.imageUrl.toString(),
                                    width: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (BuildContext context,
                                        Object exception, StackTrace? stackTrace) {
                                      return Image.asset(
                                        'assets/images/logo.png',
                                        width: 100,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  )),
                              title: Text(e.recipeName.toString()),
                              subtitle: Text(e.recipePrice.toString()),
                            ),
                          ),
                        ),
                      ),
                    )
                  ]),
          ),
        ),
      );
    });
  }
}
