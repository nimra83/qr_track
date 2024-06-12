import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_saver/models/food_model.dart';
import 'package:food_saver/screens/dashboard/dashboard.dart';
import 'package:food_saver/screens/dashboard/location_screen.dart';
import 'package:food_saver/screens/food_details_screen.dart';
import 'package:food_saver/screens/forget/changepassword.dart';
import 'package:food_saver/screens/forget/forgetpassword.dart';
import 'package:food_saver/screens/login/login.dart';
import 'package:food_saver/screens/mainPage/iteamlist.dart';
import 'package:food_saver/screens/mainPage/mainpage.dart';
import 'package:food_saver/screens/profile_screen.dart';
import 'package:food_saver/screens/registertaion/register.dart';
import 'package:food_saver/screens/splash_screen.dart';

final Map<String, WidgetBuilder> routes = {
  MySplash.routename: (context) => const MySplash(),
  MyLogin.routename: (context) => MyLogin(),
  MyRegister.routename: (context) => MyRegister(),
  MyForget.routename: (context) => MyForget(),
  MychangePass.routename: (context) => MychangePass(),
  MyMainpage.routename: (context) => MyMainpage(),
  MyIteamList.routename: (context) => MyIteamList(),
  Dashboard.routename: (context) => Dashboard(),
  ProfileScreen.routename: (context) => ProfileScreen(),
  LocationScreen.routename: (context) => ProfileScreen(),
  FoodDetailsScreen.routename: (context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final foodModel = FoodModel.fromJson(args['foodItem']);
    return FoodDetailsScreen(foodModel: foodModel);
  },
};
