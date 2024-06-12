import 'package:flutter/material.dart';
class SaveButton extends StatelessWidget {
  final Color? color;
const SaveButton({super.key, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: (){
      Navigator.pushNamed;
      
    }, child: Text("Save",style: TextStyle( color: Colors.white,fontWeight: FontWeight.bold),),
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