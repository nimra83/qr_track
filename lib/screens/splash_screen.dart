import 'dart:async';

import 'package:animate_gradient/animate_gradient.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_saver/models/user_model.dart';
import 'package:food_saver/screens/dashboard/dashboard.dart';
import 'package:food_saver/screens/login/login.dart';
import 'package:food_saver/screens/mainPage/mainpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySplash extends StatefulWidget {
  const MySplash({super.key});
  static String routename = "/splash";

  @override
  State<MySplash> createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {
  String? email;
  String? password;

  Future<void> getDataFromSharedPreferences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    email = sharedPreferences.getString("email");
    password = sharedPreferences.getString("password");
  }

  @override
  void initState() {
    super.initState();
    navigateAfterDelay();
  }

  Future<void> navigateAfterDelay() async {
    await getDataFromSharedPreferences();
    Timer(const Duration(seconds: 3), () async {
      if (email != null && password != null) {
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email!,
            password: password!,
          );
          QuerySnapshot<Map<String, dynamic>> userData = await FirebaseFirestore.instance
              .collection("users")
              .where("email", isEqualTo: email!)
              .limit(1)
              .get();
          MyMainpage.currentUser = UserModel.fromJson(userData.docs.first.data());
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, Dashboard.routename);
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
          Navigator.pushReplacementNamed(context, MyLogin.routename);
        }
      } else {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, MyLogin.routename);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: AnimateGradient(
          primaryBegin: Alignment.topLeft,
          primaryEnd: Alignment.bottomLeft,
          secondaryBegin: Alignment.bottomLeft,
          secondaryEnd: Alignment.topRight,
          primaryColors: const [
            Colors.purple,
            Colors.purpleAccent,
            Colors.deepPurple,
          ],
          secondaryColors: const [
            Colors.white,
            Colors.purpleAccent,
            Colors.deepPurple,
          ],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/Logo.png'),
              Center(
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'FOOD SAVER',
                      textStyle: const TextStyle(
                        fontSize: 48.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                      speed: const Duration(milliseconds: 200),
                    ),
                  ],

                  totalRepeatCount: 1,
                  displayFullTextOnTap: true,
                  stopPauseOnTap: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
