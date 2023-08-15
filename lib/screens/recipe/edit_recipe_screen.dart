import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../model/recipe_model.dart';
import '../../services/file_upload.dart';
import '../../viewmodels/authe_viewmodel.dart';
import '../../viewmodels/category_viewmodel.dart';
import '../../viewmodels/global_ui_viewmodel.dart';
import '../../viewmodels/single_product_viewmodel.dart';


class EditrecipeScreen extends StatefulWidget {
  const EditrecipeScreen({Key? key}) : super(key: key);

  @override
  State<EditrecipeScreen> createState() => _EditrecipeScreenState();
}

class _EditrecipeScreenState extends State<EditrecipeScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SinglerecipeViewModel>(create: (_) => SinglerecipeViewModel(), child: EditrecipeBody());
  }
}

class EditrecipeBody extends StatefulWidget {
  const EditrecipeBody({Key? key}) : super(key: key);

  @override
  State<EditrecipeBody> createState() => _EditrecipeBodyState();
}

class _EditrecipeBodyState extends State<EditrecipeBody> {
  TextEditingController _recipeNameController = TextEditingController();
  TextEditingController _recipePriceController = TextEditingController();
  TextEditingController _recipeDescriptionController = TextEditingController();
  String recipeCategory = "";

  late GlobalUIViewModel _ui;
  late AuthViewModel _authViewModel;
  late CategoryViewModel _categoryViewModel;
  late SinglerecipeViewModel _singlerecipeViewModel;
  String? recipeId;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ui = Provider.of<GlobalUIViewModel>(context, listen: false);
      _authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      _categoryViewModel = Provider.of<CategoryViewModel>(context, listen: false);
      _singlerecipeViewModel = Provider.of<SinglerecipeViewModel>(context, listen: false);
      final args = ModalRoute.of(context)!.settings.arguments.toString();
      setState(() {
        recipeId = args;
      });
      print(args);
      getData(args);
    });
    super.initState();
  }

  void editrecipe() async {
    _ui.loadState(true);
    try{
      final RecipeModel data= RecipeModel(
        imagePath: imagePath,
        imageUrl: imageUrl,
        categoryId: selectedCategory,
        recipeDescription: _recipeDescriptionController.text,
        recipeName: _recipeNameController.text,
        recipePrice: num.parse(_recipePriceController.text.toString()),
        userId: _authViewModel.loggedInUser!.userId,
      );
      await _authViewModel.editMyrecipe(data, recipeId!);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Success")));
      Navigator.of(context).pop();
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error")));
    }
    _ui.loadState(false);
  }

  getData(String args) async {
    _ui.loadState(true);
    try {
      await _categoryViewModel.getCategories();

      await _singlerecipeViewModel.getrecipes(args);
      RecipeModel? recipe = _singlerecipeViewModel.recipe;

      if (recipe != null) {
        _recipeNameController.text = recipe.recipeName ?? "";
        _recipePriceController.text = recipe.recipePrice==null ? "" : recipe.recipePrice.toString();
        _recipeDescriptionController.text = recipe.recipeDescription ?? "";
        setState(() {
          selectedCategory = recipe.categoryId;
          imageUrl = recipe.imageUrl;
          imagePath = recipe.imagePath;
        });
      }
    } catch (e) {
      print(e);
    }
    _ui.loadState(false);
  }

  String? selectedCategory;

  // image uploader
  String? imageUrl;
  String? imagePath;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    var selected = await _picker.pickImage(source: source, imageQuality: 100);
    if (selected != null) {
      setState(() {
        imageUrl = null;
        imagePath = null;
      });

      _ui.loadState(true);
      try {
        ImagePath? image = await FileUpload().uploadImage(selectedPath: selected.path);
        if (image != null) {
          setState(() {
            imageUrl = image.imageUrl;
            imagePath = image.imagePath;
          });
        }
      } catch (e) {
        print(e);
      }

      _ui.loadState(false);
    }
  }

  void deleteImage() async {
    _ui.loadState(true);
    try {
      await FileUpload().deleteImage(deletePath: imagePath.toString()).then((value) {
        setState(() {
          imagePath = null;
          imageUrl = null;
        });
      });
    } catch (e) {}

    _ui.loadState(false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SinglerecipeViewModel>(
      builder: (context, singlerecipeVM, child) {
        if(_singlerecipeViewModel.recipe== null)
          return Text("Error");
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black54,
            title: Text("Edit a recipe"),
          ),
          body: Consumer<CategoryViewModel>(builder: (context, categoryVM, child) {
            return SafeArea(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _recipeNameController,
                        // validator: Validaterecipe.username,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                          border: InputBorder.none,
                          label: Text("recipe Name"),
                          hintText: 'Enter recipe name',
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _recipePriceController,
                        // validator: Validaterecipe.username,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                          border: InputBorder.none,
                          label: Text("recipe Price"),
                          hintText: 'Enter recipe price',
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _recipeDescriptionController,
                        // validator: Validaterecipe.username,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                          border: InputBorder.none,
                          label: Text("recipe Description"),
                          hintText: 'Enter recipe description',
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Category",
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      DropdownButtonFormField(
                        borderRadius: BorderRadius.circular(10),
                        isExpanded: true,
                        value: selectedCategory,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                        ),
                        icon: const Icon(Icons.arrow_drop_down_outlined),
                        items: categoryVM.categories.map((pt) {
                          return DropdownMenuItem(
                            value: pt.id.toString(),
                            child: Text(
                              pt.categoryName.toString(),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (newVal) {
                          setState(() {
                            selectedCategory = newVal.toString();
                          });
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Add Image"),
                            SizedBox(
                              width: 10,
                            ),
                            IconButton(
                                onPressed: () {
                                  _pickImage(ImageSource.camera);
                                },
                                icon: Icon(Icons.camera)),
                            SizedBox(
                              width: 5,
                            ),
                            IconButton(
                                onPressed: () {
                                  _pickImage(ImageSource.gallery);
                                },
                                icon: Icon(Icons.photo))
                          ],
                        ),
                      ),
                      imageUrl != null
                          ? Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Image.network(
                                  imageUrl!,
                                  height: 50,
                                  width: 50,
                                ),
                                Text(imagePath.toString()),
                                IconButton(
                                    onPressed: () {
                                      deleteImage();
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    )),
                              ],
                            )
                          : Container(),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: Colors.blue))),
                              padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(vertical: 10)),
                            ),
                            onPressed: () {
                              editrecipe();
                            },
                            child: Text(
                              "Save",
                              style: TextStyle(fontSize: 20),
                            )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: Colors.orange))),
                              padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(vertical: 10)),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Back",
                              style: TextStyle(fontSize: 20),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      }
    );
  }
}
