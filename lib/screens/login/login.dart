import 'package:flutter/material.dart';
import 'package:food_saver/screens/dashboard/dashboard.dart';
import 'package:food_saver/screens/forget/forgetpassword.dart';
import 'package:food_saver/screens/login/loginbutton.dart';
import 'package:food_saver/screens/login/loginimage.dart';
import 'package:food_saver/screens/login/textfom.dart';
import 'package:food_saver/screens/mainPage/mainpage.dart';
import 'package:food_saver/screens/registertaion/register.dart';
import 'package:food_saver/services/authentication/authentication_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyLogin extends StatelessWidget {
  MyLogin({super.key});
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void saveDataToSharedPreferences(String email, String password) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("email", email);
    sharedPreferences.setString("password", password);
  }

  static String routename = "/login";
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
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 60),
                    child: Text("Welcome Back,Good to see you!",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.grey.shade700)),
                  ),
                  const SizedBox(
                    height: 50,
                  ),

                  // Email side filled
                  MyTextform(
                    hintText: 'Email',
                    obscureText: false,
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
                    height: 30,
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

                  // forget password
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, MyForget.routename);
                          },
                          child: Text(
                            "Forget Password",
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // LoginButton for Login
                  const SizedBox(
                    height: 40,
                  ),

                  LoginButton(
                    color: Colors.black,
                    onPress: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        AuthenticationServices.signInWithEmail(
                                emailController.text, passwordController.text)
                            .then((value) {
                          if (value) {
                            saveDataToSharedPreferences(emailController.text, passwordController.text);
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Logged in Successfully')));
                            Navigator.pushReplacementNamed(
                                context, Dashboard.routename);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Error Signing in')));
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
                        )),
                        Text(
                          " or Login with",
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
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // google button image
                        InkWell(onTap: (){
                          AuthenticationServices.signInWithGoogle().then((value){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Logged in with Gmail")));
                            Navigator.pushReplacementNamed(context, Dashboard.routename);
                          });
                        },child: MyImage(imagePath: "assets/icons/google.jpg")),
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
                        "Not a Member",
                        style: TextStyle(color: Colors.grey.shade800),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, MyRegister.routename);
                          },
                          child: const Text(
                            "Register Now",
                            style: TextStyle(color: Colors.black),
                          ))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
