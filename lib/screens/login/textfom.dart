import 'package:flutter/material.dart';

class MyTextform extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final bool obscureText;
  final Padding? padding;
  final String? Function(String?) validator;
  const MyTextform(
      {super.key,
      this.controller,
      required this.hintText,
      required this.obscureText,required this.validator,
      this.padding
      });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.black87),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 15,horizontal: 10),
            fillColor: Colors.grey.shade200,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade500)),
      ),
    );
  }
}
