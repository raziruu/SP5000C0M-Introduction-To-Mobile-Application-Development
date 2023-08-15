import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../model/User_Model.dart';
import '../../viewmodels/authe_viewmodel.dart';
import '../../viewmodels/global_ui_viewmodel.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();

  bool _obscureTextPassword = true;
  bool _obscureTextPasswordConfirm = true;

  late GlobalUIViewModel _ui;
  late AuthViewModel _auth;

  @override
  void initState() {
    _ui = Provider.of<GlobalUIViewModel>(context, listen: false);
    _auth = Provider.of<AuthViewModel>(context, listen: false);
    super.initState();
  }

  void register() async{
    _ui.loadState(true);
    try{
      await _auth.register(
          UserModel(
              email: _emailController.text,
              password: _passwordController.text,
              phone: _phoneNumberController.text,
              username: _usernameController.text
          )).then((value) => null)
          .catchError((e){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message.toString())));
      });
    }catch(err){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err.toString())));
    }
    _ui.loadState(false);
  }
  @override
  Widget build(BuildContext context) {


    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _nameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.name,
                      style: const TextStyle(
                          fontFamily: 'WorkSansSemiBold',
                          fontSize: 16.0,
                          color: Colors.black),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(60)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(60)),
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.black,
                          size: 22.0,
                        ),
                        hintText: 'First Name',
                        hintStyle: TextStyle(
                            fontFamily: 'WorkSansSemiBold', fontSize: 17.0),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _phoneNumberController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your Number';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(
                          fontFamily: 'WorkSansSemiBold',
                          fontSize: 16.0,
                          color: Colors.black),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(60)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(60)),
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.phone,
                          color: Colors.black,
                          size: 22.0,
                        ),
                        hintText: 'Phone Number',
                        hintStyle: TextStyle(
                            fontFamily: 'WorkSansSemiBold', fontSize: 17.0),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _usernameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your UserName';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      style: const TextStyle(
                          fontFamily: 'WorkSansSemiBold',
                          fontSize: 16.0,
                          color: Colors.black),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(60)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(60)),
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.verified_user,
                          color: Colors.black,
                          size: 22.0,
                        ),
                        hintText: 'Username',
                        hintStyle: TextStyle(
                            fontFamily: 'WorkSansSemiBold', fontSize: 17.0),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _emailController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(
                          fontFamily: 'WorkSansSemiBold',
                          fontSize: 16.0,
                          color: Colors.black),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(60)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(60)),
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.black,
                          size: 22.0,
                        ),
                        hintText: 'Email Address',
                        hintStyle: TextStyle(
                            fontFamily: 'WorkSansSemiBold', fontSize: 17.0),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      obscureText: _obscureTextPassword,
                      style: const TextStyle(
                          fontFamily: 'WorkSansSemiBold',
                          fontSize: 16.0,
                          color: Colors.black),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(60)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(60)),
                        prefixIcon: const Icon(
                          Icons.lock,
                          size: 22.0,
                          color: Colors.black,
                        ),
                        hintText: 'Password',
                        hintStyle: const TextStyle(
                            fontFamily: 'WorkSansSemiBold', fontSize: 17.0),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscureTextPassword = !_obscureTextPassword;
                            });
                          },
                          child: Icon(
                            _obscureTextPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            size: 20.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _confirmPasswordController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      obscureText: _obscureTextPasswordConfirm,
                      style: const TextStyle(
                          fontFamily: 'WorkSansSemiBold',
                          fontSize: 16.0,
                          color: Colors.black),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(60)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(60)),
                        prefixIcon: const Icon(
                          Icons.lock_clock,
                          size: 22.0,
                          color: Colors.black,
                        ),
                        hintText: 'Confirm Password',
                        hintStyle: const TextStyle(
                            fontFamily: 'WorkSansSemiBold', fontSize: 17.0),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscureTextPasswordConfirm =
                                  !_obscureTextPasswordConfirm;
                            });
                          },
                          child: Icon(
                            _obscureTextPasswordConfirm
                                ? Icons.visibility
                                : Icons.visibility_off,
                            size: 20.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                          style: OutlinedButton.styleFrom(
                              backgroundColor:
                                  Color.fromARGB(255, 114, 102, 82)),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState?.save();
                              // Perform sign-up logic
                              register();
                              // // print("welcome");
                            }
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(fontSize: 20),
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: TextStyle(color: Colors.grey.shade800),
                        ),
                        InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed("/login");
                            },
                            child: Text(
                              "Sign in",
                              style: TextStyle(color: Colors.lightBlueAccent),
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
