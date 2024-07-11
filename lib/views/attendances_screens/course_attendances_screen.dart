// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:food_saver/models/attendance_model.dart';
import 'package:food_saver/models/course_model.dart';
import 'package:food_saver/models/user_model.dart';
import 'package:food_saver/res/enums.dart';
import 'package:food_saver/views/attendances_screens/attendance_location_screen.dart';

class CourseAttendancesScreen extends StatefulWidget {
  const CourseAttendancesScreen({super.key, required this.courseModel});

  final CourseModel courseModel;

  @override
  State<CourseAttendancesScreen> createState() =>
      _CourseAttendancesScreenState();
}

class _CourseAttendancesScreenState extends State<CourseAttendancesScreen> {
  List<AttendanceModel> attendancesList = [];

  PageController pageController = PageController();

  Future<void> getAttendances() async {
    EasyLoading.show(status: 'Loading');
    try {
      if (UserModel.currentUser.userType == UserRoles.Student.name) {
        List<AttendanceModel> allAttendances = [];

        for (var lecture in widget.courseModel.lectures!) {
          final lectureId = lecture['lectureId'];

          final querySnapshot = await FirebaseFirestore.instance
              .collection('attendances')
              .doc(widget.courseModel.courseId)
              .collection('lectures')
              .doc(lectureId)
              .collection('attendances')
              .where('rollNo', isEqualTo: UserModel.currentUser.rollNo)
              .get();

          final lectureAttendances = querySnapshot.docs
              .map((doc) => AttendanceModel.fromJson(doc.data()))
              .toList();

          allAttendances.addAll(lectureAttendances);
        }

        setState(() {
          attendancesList = allAttendances;
        });
      } else if (UserModel.currentUser.userType == UserRoles.Teacher.name) {
        List<AttendanceModel> allAttendances = [];

        for (var lecture in widget.courseModel.lectures!) {
          final lectureId = lecture['lectureId'];

          final querySnapshot = await FirebaseFirestore.instance
              .collection('attendances')
              .doc(widget.courseModel.courseId)
              .collection('lectures')
              .doc(lectureId)
              .collection('attendances')
              .get();

          final lectureAttendances = querySnapshot.docs
              .map((doc) => AttendanceModel.fromJson(doc.data()))
              .toList();

          allAttendances.addAll(lectureAttendances);
        }

        setState(() {
          attendancesList = allAttendances;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    EasyLoading.dismiss();
  }

  @override
  void initState() {
    fetchAttendances();
    super.initState();
  }

  void fetchAttendances() async {
    await getAttendances();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.courseModel.lectures?.length ?? 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Attendances List',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: TabBar(
            onTap: (index) {
              pageController.jumpToPage(index);
            },
            tabs: widget.courseModel.lectures?.map((e) {
                  return Tab(
                    text: e['lectureId'].toString(),
                  );
                }).toList() ??
                [],
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: widget.courseModel.lectures == null
              ? Center(child: Text('No Lectures Found'))
              : PageView(
                  controller: pageController,
                  physics: NeverScrollableScrollPhysics(),
                  children: widget.courseModel.lectures!.map((lecture) {
                    List<AttendanceModel> filteredAttendances = attendancesList
                        .where((element) =>
                            element.lectureId == lecture['lectureId'])
                        .toList();
                    return filteredAttendances.isNotEmpty
                        ? ListView.builder(
                            itemCount: filteredAttendances.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              filteredAttendances[index]
                                                  .locationLat
                                                  .toString())));
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              LocationAttendanceScreen(
                                                lat: filteredAttendances[index]
                                                        .locationLat ??
                                                    0,
                                                lng: filteredAttendances[index]
                                                        .locationLng ??
                                                    0,
                                              )));
                                },
                                child: ListTile(
                                  title: UserModel.currentUser.userType ==
                                          UserRoles.Student.name
                                      ? Text(filteredAttendances[index]
                                          .day
                                          .toString())
                                      : Text(filteredAttendances[index]
                                          .studenName
                                          .toString()),
                                  subtitle: Text(
                                      'Date: ${filteredAttendances[index].date ?? 'time'} - Time: ${filteredAttendances[index].time ?? 'time'}\nClick to view attendance Location'),
                                  trailing: Chip(
                                    backgroundColor:
                                        filteredAttendances[index].status ==
                                                AttendanceStatuses.Present.name
                                            ? Colors.green
                                            : Colors.red,
                                    label: Text(
                                        filteredAttendances[index].status ??
                                            'Status'),
                                  ),
                                ),
                              );
                            })
                        : Center(
                            child: Text('No Attendances Yet'),
                          );
                  }).toList(),
                ),
        ),
      ),
    );
  }
}
