// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:food_saver/res/colors.dart';

class RoleWidget extends StatelessWidget {
  const RoleWidget({
    super.key,
    required this.role,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String? role;
  final IconData? icon;
  final bool isSelected;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        width: screenWidth * 0.35,
        height: screenHeight * 0.08,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(
            20,
          ),
          border: isSelected
              ? null
              : Border.all(
                  color: AppColors.primaryColor,
                ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: isSelected ? Colors.white : AppColors.primaryColor,
            ),
            Text(
              role.toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : AppColors.primaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
