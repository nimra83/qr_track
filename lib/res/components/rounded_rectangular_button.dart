// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:food_saver/res/colors.dart';

class RoundedRectangularButton extends StatelessWidget {
  const RoundedRectangularButton({
    super.key,
    required this.label,
    this.backgroundColor = AppColors.primaryColor,
    this.labelColor = Colors.white,
    required this.onPress,
  });

  final String? label;
  final Color? backgroundColor;
  final Color? labelColor;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
        backgroundColor: backgroundColor,
      ),
      onPressed: () => onPress(),
      child: Text(
        label.toString(),
        style: TextStyle(
          color: labelColor,
          fontSize: 20,
        ),
      ),
    );
  }
}
