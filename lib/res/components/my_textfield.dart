// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    required this.label,
    required this.controller,
    this.isNumber = false,
    this.isPassword = false,
    this.showPassword = true,
    this.isReadOnly = false,
    required this.validator,
    this.ontap,
    this.onEyetap,
    this.icon,
  });

  final String? label;
  final bool isPassword;
  final bool isNumber;
  final bool showPassword;
  final bool isReadOnly;
  final IconData? icon;
  final TextEditingController controller;
  final String? Function(String? value) validator;
  final void Function()? ontap;
  final void Function()? onEyetap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        controller: controller,
        readOnly: isReadOnly,
        onTap: ontap ?? () {},
        decoration: InputDecoration(
          label: Text(label.toString()),
          hintText: 'Enter $label',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          suffix: Icon(icon),
          contentPadding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 20,
          ),
          suffixIcon: isPassword
              ? InkWell(
                  onTap: onEyetap,
                  child: Icon(
                    showPassword
                        ? Icons.remove_red_eye
                        : Icons.remove_red_eye_outlined,
                  ),
                )
              : null,
        ),
        obscureText: isPassword ? showPassword : false,
        validator: validator,
      ),
    );
  }
}
