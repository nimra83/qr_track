// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:food_saver/models/course_model.dart';
import 'package:food_saver/res/colors.dart';
import 'package:food_saver/views/attendances_screens/course_attendances_screen.dart';

class AttendancesScreen extends StatefulWidget {
  const AttendancesScreen({super.key});

  @override
  State<AttendancesScreen> createState() => _AttendancesScreenState();
}

class _AttendancesScreenState extends State<AttendancesScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: CourseModel.coursesList.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CourseAttendancesScreen(
                      courseModel: CourseModel.coursesList[index],
                    ),
                  ),
                );
              },
              child: Card(
                color: AppColors.primaryColor,
                child: ListTile(
                  leading: Icon(
                    Icons.library_books,
                    color: Colors.white,
                  ),
                  title: Text(
                    CourseModel.coursesList[index].courseTitle.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    'Course Code: ${CourseModel.coursesList[index].courseCode.toString()}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          }),
    ));
  }
}
