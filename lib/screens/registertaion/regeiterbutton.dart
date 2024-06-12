import 'package:flutter/material.dart';
import 'package:food_saver/screens/mainPage/mainpage.dart';
class RegisterButton extends StatelessWidget {
  final Color? color;
  final Function() onPress;
   RegisterButton({super.key, this.color,required this.onPress});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
              onPressed: onPress,
              style: ButtonStyle(
                  side: const MaterialStatePropertyAll(
                      BorderSide(color: Colors.black)),
                  shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  fixedSize: const MaterialStatePropertyAll(
                      Size.fromWidth(370)),
                  padding: const MaterialStatePropertyAll(
                    EdgeInsets.symmetric(vertical: 20),
                  ),
                  backgroundColor:
                      const MaterialStatePropertyAll(Colors.black)),
              child: const Text(
                "Register",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                )
            );
  }
}

  