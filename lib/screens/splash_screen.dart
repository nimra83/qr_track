import 'dart:async';

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
          Navigator.pushNamed(context, Dashboard.routename);
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
          Navigator.pushNamed(context, MyLogin.routename);
        }
      } else {
        if (!mounted) return;
        Navigator.pushNamed(context, MyLogin.routename);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              "assets/images/img.jpg",
            ),
          ),
        ),
        child: const Center(
          child: Text(
            'SPLASH',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
