// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:food_saver/models/course_model.dart';
import 'package:food_saver/models/user_model.dart';
import 'package:food_saver/res/colors.dart';
import 'package:food_saver/res/enums.dart';
import 'package:food_saver/views/courses_screens/add_course.dart';
import 'package:food_saver/views/courses_screens/course_details_screen.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  @override
  void initState() {
    super.initState();
    // fetchCourses();
  }

  Future<void> fetchCourses() async {
    try {
      if (UserModel.currentUser.userType == UserRoles.Teacher.name) {
        await CourseModel.fetchTeacherCourses();
        setState(() {});
      } else if (UserModel.currentUser.userType == UserRoles.Student.name) {
        await CourseModel.fetchStudentCourses();
        setState(() {});
      }
    } catch (e) {
      print('Error fetching courses: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    print(
        'Building CoursesScreen, coursesList length: ${CourseModel.coursesList.length}');
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Courses',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: CourseModel.coursesList.isEmpty
              ? Center(
                  child: Text('No Courses Found'),
                )
              : ListView.builder(
                  itemCount: CourseModel.coursesList.length,
                  itemBuilder: (context, index) {
                    CourseModel courseModel = CourseModel.coursesList[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CourseDetails(
                              courseModel: courseModel,
                              isOnGoing: false,
                              onGoingLectureId: 'noLecture',
                            ),
                          ),
                        );
                      },
                      child: Card(
                        color: AppColors.primaryColor,
                        child: ListTile(
                          title: Text(
                            '${courseModel.courseTitle.toString()}\nCourse Code:${courseModel.courseCode.toString()}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          subtitle: Text(
                            '${courseModel.program.toString()} ${courseModel.department.toString()} ${courseModel.batch.toString()} ${courseModel.section.toString()}',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
        floatingActionButton:
            UserModel.currentUser.userType == UserRoles.Teacher.name
                ? FloatingActionButton(
                    backgroundColor: AppColors.primaryColor,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddCourseScreen(),
                        ),
                      ).then((_) {
                        fetchCourses();
                      });
                    },
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  )
                : SizedBox(),
      ),
    );
  }
}
