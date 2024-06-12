import 'package:flutter/material.dart';
import 'package:food_saver/screens/login/login.dart';
import 'package:food_saver/screens/registertaion/register.dart';
class button extends StatelessWidget {
  final String message;
  final Color? color;
  const button({
    super.key, required this.message,  this.color = Colors.white
    
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: (){
      Navigator.pushNamed(context, MyLogin.routename);
    }, child: Text("Login",style: TextStyle( color: Colors.white,fontWeight: FontWeight.bold),),
    style: ButtonStyle(
      side: MaterialStatePropertyAll(BorderSide(color: Colors.black)),
              shape: MaterialStatePropertyAll(
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              fixedSize: const MaterialStatePropertyAll(Size.fromWidth(370)),
              padding: MaterialStatePropertyAll(
                EdgeInsets.symmetric(vertical: 20),),
                backgroundColor: MaterialStatePropertyAll(color)
                ),
    );
  }
}
class button2 extends StatelessWidget {
  final String message;
  final Color? color;
  const button2({
    super.key, required this.message, this.color = Colors.white
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context,MyRegister.routename);
              },
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
                      const MaterialStatePropertyAll(Colors.white)),
              child: const Text(
                "Register",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                )
            );
  }
}

