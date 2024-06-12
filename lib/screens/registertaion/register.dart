import 'package:flutter/material.dart';
import 'package:food_saver/models/user_model.dart';
import 'package:food_saver/screens/dashboard/dashboard.dart';
import 'package:food_saver/screens/login/login.dart';
import 'package:food_saver/screens/login/loginimage.dart';
import 'package:food_saver/screens/login/textfom.dart';
import 'package:food_saver/screens/mainPage/mainpage.dart';
import 'package:food_saver/screens/registertaion/regeiterbutton.dart';
import 'package:food_saver/services/authentication/authentication_services.dart';

class MyRegister extends StatelessWidget {
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  MyRegister({super.key});
  static String routename = "/Register";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade300,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 60),
                      child: Text("Hello! Register to get started",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.grey.shade700)),
                    ),
                    const SizedBox(
                      height: 40,
                    ),

                    // Username  side filled
                    MyTextform(
                      hintText: 'Username',
                      obscureText: false,
                      controller: userNameController,
                      validator: (value) {
                        if (value.toString().isEmpty) {
                          return "Username can't be empty.";
                        } else {
                          return null;
                        }
                      },
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    // Email side filled

                    MyTextform(
                      obscureText: false,
                      hintText: 'Email',
                      controller: emailController,
                      validator: (value) {
                        if (value.toString().isEmpty) {
                          return "Email can't be empty.";
                        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                            .hasMatch(value.toString())) {
                          return "Email is not valid";
                        } else {
                          return null;
                        }
                      },
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    MyTextform(
                      obscureText: false,
                      hintText: 'Phone',
                      controller: phoneController,
                      validator: (value) {
                        if (value.toString().isEmpty) {
                          return "Phone can't be empty.";
                        } else if (value.toString().length < 11) {
                          return "Phone is not valid";
                        } else {
                          return null;
                        }
                      },
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    // password side filled
                    MyTextform(
                      obscureText: true,
                      hintText: 'Password',
                      controller: passwordController,
                      validator: (value) {
                        if (value.toString().isEmpty) {
                          return "Password can't be empty!";
                        } else if (value.toString().length < 6) {
                          return "Week Password!";
                        } else {
                          return null;
                        }
                      },
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    // conform password side filled

                    MyTextform(
                      obscureText: true,
                      hintText: 'Conform Password',
                      controller: confirmPasswordController,
                      validator: (value) {
                        if (value.toString().isEmpty) {
                          return "Password can't be empty!";
                        } else if (value.toString() !=
                            passwordController.text) {
                          return "Password don't match!";
                        } else if (value.toString().length < 6) {
                          return "Week Password!";
                        } else {
                          return null;
                        }
                      },
                    ),

                    // LoginButton for Login
                    const SizedBox(
                      height: 50,
                    ),

                    RegisterButton(
                      color: Colors.black,
                      onPress: () {
                        print('HELLO');
                        if (_formKey.currentState?.validate() ?? false) {
                          UserModel userData = UserModel(
                            username: userNameController.text,
                            email: emailController.text,
                            password: passwordController.text,
                            phone: phoneController.text,
                          );
                          AuthenticationServices.signUpWithEmail(userData)
                              .then((value) {
                            if (value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Signed up Successfully')));
                              Navigator.pushNamed(
                                  context, Dashboard.routename);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Sign up Failed')));
                            }
                          });
                        }
                      },
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    // continue with
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            " or Register with",
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 15),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    // google or facebook button images
                    const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // google button image
                          MyImage(imagePath: "assets/icons/google.jpg"),
                          SizedBox(width: 15),
                          // facebook button image
                          MyImage(imagePath: "assets/icons/facebook.jpg"),
                        ]),
                    // if not login than Register
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(color: Colors.grey.shade800),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, MyLogin.routename);
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(color: Colors.black),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
