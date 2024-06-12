import 'package:flutter/material.dart';
import 'package:food_saver/screens/login/textfom.dart';
import 'package:food_saver/screens/mainPage/SaveButton.dart';

class MyIteamList extends StatelessWidget {
  final RegiterUsercontroler = TextEditingController();
  final Regitercontroler = TextEditingController();
  final RegPasswordcontroler = TextEditingController();
  final RegConPasswordcontroler = TextEditingController();


  MyIteamList({super.key});
  static String routename = '/IteamList';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          title: Text("Add Details of Food"),
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 60),
                    child: Text("Hello! Add Food Details",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.grey.shade700)),
                  ),
                  SizedBox(
                    height: 40,
                  ),

                  // Username  side filled
                  MyTextform(
                    hintText: 'Food Name',
                    obscureText: false,
                    controller: RegiterUsercontroler,
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return "Food Name can't be empty.";
                      } else {
                        return null;
                      }
                    },
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  // Email side filled

                  MyTextform(
                    obscureText: false,
                    hintText: 'Expriy Date',
                    controller: Regitercontroler,
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return "Expiry can't be empty.";
                      } else {
                        return null;
                      }
                    },
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  // password side filled
                  MyTextform(
                    obscureText: true,
                    hintText: 'Food Details',
                    controller: RegPasswordcontroler,
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return "Food details can't be empty.";
                      } else {
                        return null;
                      }
                    },
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  // conform password side filled

                  MyTextform(
                    obscureText: true,
                    hintText: ' food Quantity',
                    controller: RegConPasswordcontroler,
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return "Food quantity can't be empty.";
                      } else {
                        return null;
                      }
                    },
                  ),

                  // LoginButton for Login
                  SizedBox(
                    height: 50,
                  ),

                  SaveButton(
                    color: Colors.black,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
