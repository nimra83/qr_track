import 'package:flutter/material.dart';
import 'package:food_saver/screens/forget/changepassword.dart';
import 'package:food_saver/screens/login/textfom.dart';

class MyForget extends StatelessWidget {
  final ForEmailcontroler = TextEditingController();
  final Color? color;
  MyForget({super.key, this.color = Colors.white});
  static String routename = "/Forget";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
          child: Column(
        children: [
          SizedBox(
            height: 60,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 60),
            child: Text("Wellcome Back,Good to see you!",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.grey.shade700)),
          ),
          SizedBox(
            height: 10,
          ),

          const Column(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 150),
                child: Text(
                  "If you dont know your password",
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 200),
                child: Text("change your password"),
              ),
            ],
          ),
          const SizedBox(
            height: 60,
          ),

          // Email side filled
          MyTextform(
            hintText: 'Email',
            obscureText: false,
            controller: ForEmailcontroler,
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
            height: 50,
          ),

          // continue button
          ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, MychangePass.routename);
              },
              style: ButtonStyle(
                side: MaterialStatePropertyAll(BorderSide(color: Colors.black)),
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
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ))
        ],
      )),
    );
  }
}
