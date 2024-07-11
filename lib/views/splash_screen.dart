// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_saver/models/user_model.dart';
import 'package:food_saver/res/colors.dart';
import 'package:food_saver/res/enums.dart';
import 'package:food_saver/res/utility_functions.dart';
import 'package:food_saver/services/session_management_services.dart';
import 'package:food_saver/views/dashboard.dart';
import 'package:food_saver/views/registration/signin_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      SessionManagementService.checkSession().then((data) {
        if (data['email'] != null && data['password'] != null) {
          fetchLoggedInUserData(
                  {'email': data['email'], 'password': data['password']})
              .then((value) {
            UserModel.getUserData(data['userType'], data['email'])
                .then((value) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Dashboard()));
            });
          });
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => SigninScreen()));
        }
      });
    });
    super.initState();
  }

  Future<void> fetchLoggedInUserData(Map<String, dynamic> userData) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection(
                  UtilityFunctions.getCollectionName(userData['userType']))
              .where('email', isEqualTo: userData['email'])
              .limit(1)
              .get();
      if (userData['userType'] == UserRoles.Teacher.name) {
        UserModel.currentUser =
            TeacherModel.fromJson(querySnapshot.docs.first.data());
      } else {
        UserModel.currentUser =
            StudentModel.fromJson(querySnapshot.docs.first.data());
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo/app_logo.png'),
            Text(
              'QR TRACK',
              style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryColor),
            ),
          ],
        ),
      ),
    ));
  }
}
