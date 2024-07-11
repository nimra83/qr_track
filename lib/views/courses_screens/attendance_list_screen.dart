// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_saver/models/attendance_model.dart';
import 'package:food_saver/models/course_model.dart';
import 'package:food_saver/res/colors.dart';
import 'package:food_saver/res/enums.dart';


class AttendanceListScreen extends StatefulWidget {
  const AttendanceListScreen({
    super.key,
    required this.courseModel,
    required this.lectureId,
  });

  final CourseModel courseModel;
  final String lectureId;

  @override
  State<AttendanceListScreen> createState() => _AttendanceListScreenState();
}

class _AttendanceListScreenState extends State<AttendanceListScreen> {
  List<AttendanceModel>? attendancesList;

  Future<void> getAttendances() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('attendances')
        .doc(widget.courseModel.courseId)
        .collection('lectures')
        .doc(widget.lectureId)
        .collection('attendances')
        .get();

    attendancesList = querySnapshot.docs
        .map((e) => AttendanceModel.fromJson(e.data()))
        .toList();
    setState(() {});
  }

  @override
  void initState() {
    fetchAttendances();
    super.initState();
  }

  fetchAttendances() async {
    await getAttendances();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Attendances'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(8),
              color: AppColors.primaryColor,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Text(
                      widget.courseModel.courseTitle.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      widget.courseModel.courseCode.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      widget.courseModel.lectures!.firstWhere(
                        (element) => element['lectureId'] == widget.lectureId,
                        orElse: () => {'day': 'Not Found'},
                      )['day'],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Row(
                      children: [
                        Text(
                          widget.courseModel.lectures!.firstWhere(
                            (element) =>
                                element['lectureId'] == widget.lectureId,
                            orElse: () => {'startTime': 'Not Found'},
                          )['startTime'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          ' - ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          widget.courseModel.lectures!.firstWhere(
                            (element) =>
                                element['lectureId'] == widget.lectureId,
                            orElse: () => {'endTime': 'Not Found'},
                          )['endTime'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            (attendancesList == null || attendancesList!.isEmpty)
                ? Center(
                    child: Text('No Attendances Yet'),
                  )
                : Expanded(
                    child: ListView.builder(
                        itemCount: attendancesList!.length,
                        itemBuilder: (context, index) {
                          AttendanceModel attendanceModel =
                              attendancesList![index];
                          return ListTile(
                            title: Text(
                                '${attendanceModel.studenName.toString()}(${attendanceModel.rollNo.toString()})'),
                            subtitle: Text(attendanceModel.time
                                .toString()
                                .split('y')
                                .last),
                            trailing: Chip(
                              backgroundColor: attendanceModel.status ==
                                      AttendanceStatuses.Present.name
                                  ? Colors.green
                                  : AppColors.errorColor,
                              label: Text(
                                attendanceModel.status.toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        }),
                  ),
          ],
        ),
      ),
    ));
  }
}
