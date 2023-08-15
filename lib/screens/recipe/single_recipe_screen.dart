import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/favorite_model.dart';
import '../../viewmodels/authe_viewmodel.dart';
import '../../viewmodels/global_ui_viewmodel.dart';
import '../../viewmodels/single_product_viewmodel.dart';


class SinglerecipeScreen extends StatefulWidget {
  const SinglerecipeScreen({Key? key}) : super(key: key);

  @override
  State<SinglerecipeScreen> createState() => _SinglerecipeScreenState();
}

class _SinglerecipeScreenState extends State<SinglerecipeScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SinglerecipeViewModel>(
        create: (_) => SinglerecipeViewModel(), child: SinglerecipeBody());
  }
}

class SinglerecipeBody extends StatefulWidget {
  const SinglerecipeBody({Key? key}) : super(key: key);

  @override
  State<SinglerecipeBody> createState() => _SinglerecipeBodyState();
}

class _SinglerecipeBodyState extends State<SinglerecipeBody> {
  late SinglerecipeViewModel _singlerecipeViewModel;
  late GlobalUIViewModel _ui;
  late AuthViewModel _authViewModel;
  String? recipeId;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _singlerecipeViewModel =
          Provider.of<SinglerecipeViewModel>(context, listen: false);
      _authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      _ui = Provider.of<GlobalUIViewModel>(context, listen: false);
      final args = ModalRoute.of(context)!.settings.arguments.toString();
      setState(() {
        recipeId = args;
      });
      print(args);
      getData(args);
    });
    super.initState();
  }

  Future<void> getData(String recipeId) async {
    _ui.loadState(true);
    try {
      await _authViewModel.getFavoritesUser();
      await _singlerecipeViewModel.getrecipes(recipeId);
    } catch (e) {}
    _ui.loadState(false);
  }

  Future<void> favoritePressed(
      FavoriteModel? isFavorite, String recipeId) async {
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
    return Consumer2<SinglerecipeViewModel, AuthViewModel>(
        builder: (context, singlerecipeVM, authVm, child) {
      return singlerecipeVM.recipe == null
          ? Scaffold(
              body: Container(
                child: Text("Error"),
              ),
            )
          : singlerecipeVM.recipe!.id == null
              ? Scaffold(
                  body: Center(
                    child: Container(
                      child: Text("Please wait..."),
                    ),
                  ),
                )
              : Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.black54,
                    actions: [
                      Builder(builder: (context) {
                        FavoriteModel? isFavorite;
                        try {
                          isFavorite = authVm.favorites.firstWhere(
                              (element) =>
                                  element.recipeId ==
                                  singlerecipeVM.recipe!.id);
                        } catch (e) {}

                        return IconButton(
                            onPressed: () {
                              print(singlerecipeVM.recipe!.id!);
                              favoritePressed(
                                  isFavorite, singlerecipeVM.recipe!.id!);
                            },
                            icon: Icon(
                              Icons.favorite,
                              color: isFavorite != null
                                  ? Colors.red
                                  : Colors.white,
                            ));
                      })
                    ],
                  ),
                  backgroundColor: Color(0xFFf5f5f4),
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        Image.network(
                          singlerecipeVM.recipe!.imageUrl.toString(),
                          height: 400,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return Image.asset(
                              'assets/images/logo.png',
                              height: 400,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20),
                            decoration: BoxDecoration(color: Colors.white70),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Min. " +
                                      singlerecipeVM.recipe!.recipePrice
                                          .toString(),
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.green,
                                      fontWeight: FontWeight.w900),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  singlerecipeVM.recipe!.recipeName
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  singlerecipeVM.recipe!.recipeDescription
                                      .toString(),
                                  style: TextStyle(
                                    fontSize: 22,
                                  ),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                );
    });
  }
}
