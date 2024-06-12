import 'package:flutter/material.dart';
import 'package:food_saver/screens/login/login.dart';
import 'package:food_saver/screens/login/textfom.dart';

class MychangePass extends StatelessWidget {
  final ChgPasscontroler = TextEditingController();
  final chgConPasscontroler = TextEditingController();
  MychangePass({super.key});
  static String routename = "/ChangePassword";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade300,
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(
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
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.only(right: 200),
              child: Text(
                "change your password",
                style: TextStyle(fontSize: 15),
              ),
            ),
            const SizedBox(
              height: 60,
            ),

            // password  side filled

            MyTextform(
              hintText: 'Password',
              obscureText: true,
              controller: ChgPasscontroler,
              validator: (value){
                if(value.toString().isEmpty){
                  return "Password can't be empty!";
                }
                else if(value.toString().length<6){
                  return "Week Password!";
                }
                else{
                  return null;
                }
              },
            ),
            const SizedBox(
              height: 30,
            ),

            //conform password side filled

            MyTextform(
              hintText: 'Conform Password',
              obscureText: true,
              controller: chgConPasscontroler,
              validator: (value){
                if(value.toString().isEmpty){
                  return "Password can't be empty!";
                }
                else if(value.toString()!=ChgPasscontroler.text){
                  return "Password don't match!";
                }
                else if(value.toString().length<6){
                  return "Week Password!";
                }
                else{
                  return null;
                }
              },
            ),
            // continue button for changePassword
            const SizedBox(
              height: 60,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, MyLogin.routename);
                },
                style: ButtonStyle(
                  side:
                      const MaterialStatePropertyAll(BorderSide(color: Colors.black)),
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
                  fixedSize: const MaterialStatePropertyAll(Size.fromWidth(370)),
                  padding: const MaterialStatePropertyAll(
                    EdgeInsets.symmetric(vertical: 20),
                  ),
                  backgroundColor: const MaterialStatePropertyAll(Colors.black),
                ),
                child: const Text(
                  "Continue",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ))
          ]),
        )));
  }
}
