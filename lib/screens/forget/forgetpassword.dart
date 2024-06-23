// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_saver/screens/forget/changepassword.dart';
import 'package:food_saver/screens/login/textfom.dart';

class MyForget extends StatelessWidget {
  final emailController = TextEditingController();
  final Color? color;

  final formKey = GlobalKey<FormState>();

  MyForget({super.key, this.color = Colors.white});
  static String routename = "/Forget";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text(
          'Forgot Password',
        ),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Forgot Password',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Enter your email to \nforgot your password.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 12,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      20,
                    ),
                  ),
                ),
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
              SizedBox(
                height: 12,
              ),
              // continue button
              ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      FirebaseAuth.instance
                          .sendPasswordResetEmail(email: emailController.text)
                          .then((value) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(
                              "A Password Reset Email Has been send to:\n${emailController.text}",
                            ),
                            content: Text(
                                "Check spam in case you can't find the mail!"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: Text('Ok'),
                              ),
                            ],
                          ),
                        );
                      });
                    }
                  },
                  style: ButtonStyle(
                    side: MaterialStatePropertyAll(
                        BorderSide(color: Colors.black)),
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                    fixedSize: MaterialStatePropertyAll(Size.fromWidth(370)),
                    padding: MaterialStatePropertyAll(
                      EdgeInsets.symmetric(vertical: 20),
                    ),
                    backgroundColor: MaterialStatePropertyAll(Colors.black),
                  ),
                  child: Text(
                    "Continue",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ))
            ],
          ),
        ),
      )),
    );
  }
}
