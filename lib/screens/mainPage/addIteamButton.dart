import 'package:flutter/material.dart';
import 'package:food_saver/screens/mainPage/iteamlist.dart';
class ITeamButton extends StatelessWidget {
  final Color? color;
const ITeamButton({super.key, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: (){
      Navigator.pushNamed(context, MyIteamList.routename);
      
    }, child: Text("Add Iteam",style: TextStyle( color: Colors.white,fontWeight: FontWeight.bold),),
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