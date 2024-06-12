import 'package:flutter/material.dart';
class MyImage extends StatelessWidget {
  final String imagePath;
  const MyImage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Image.asset(imagePath, 
      height: 45,),
      decoration: BoxDecoration(border: Border.all(color: Colors.white),
      borderRadius: BorderRadius.circular(10),
      color: Colors.grey.shade200),
      

    );
  }
}