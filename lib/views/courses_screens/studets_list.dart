// ignore_for_file: prefer_const_constructors, must_be_immutable, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:food_saver/models/course_model.dart';
import 'package:food_saver/models/user_model.dart';
import 'package:food_saver/res/colors.dart';
import 'package:food_saver/res/components/my_textfield.dart';

class StudentsList extends StatefulWidget {
  StudentsList({
    super.key,
    required this.studentsData,
    required this.course,
    required this.isViewing,
  });

  List<StudentModel> studentsData;
  CourseModel course;
  final bool isViewing;

  @override
  State<StudentsList> createState() => _StudentsListState();
}

class _StudentsListState extends State<StudentsList> {
  List<StudentModel> studentsToAdd = [];

  Future<void> fetchStudents() async {
    await CourseModel.fetchTeacherCourses().then((value) {
      setState(() {});
    });
  }

  Future<void> deleteStudentFromCourse(String rollNumber) async {
    EasyLoading.show(status: "Deleting");
    try {
      DocumentReference courseRef = FirebaseFirestore.instance
          .collection('courses')
          .doc(widget.course.courseId);
      DocumentSnapshot courseSnapshot = await courseRef.get();

      if (courseSnapshot.exists) {
        List<dynamic> students = courseSnapshot.get('students');
        students.removeWhere((student) => student['rollNumber'] == rollNumber);

        await courseRef.update({'students': students});
        setState(() {
          widget.studentsData
              .removeWhere((student) => student.rollNo == rollNumber);
        });
        print(
            'Student with roll number $rollNumber deleted successfully from course ${widget.course.courseId}.');
      } else {
        print('Course with ID ${widget.course.courseId} does not exist.');
      }
    } catch (e) {
      print('Error deleting student: $e');
    }
    EasyLoading.dismiss();
  }

  List<StudentModel> studentsData = [];

  Future<void> pickFileaAndUpload() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      var bytes = file.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);

      List<StudentModel> data = [];

      for (var table in excel.tables.keys) {
        var sheet = excel.tables[table]!;
        for (int rowIndex = 1; rowIndex < sheet.maxRows; rowIndex++) {
          var row = sheet.row(rowIndex);
          if (row.length >= 7) {
            StudentModel student = StudentModel(
                fullName: row[0]?.value.toString() ?? '',
                rollNo: row[1]?.value.toString() ?? '',
                email: row[2]?.value.toString() ?? '',
                program: row[3]?.value.toString() ?? '',
                department: row[4]?.value.toString() ?? '',
                batch: row[5]?.value.toString() ?? '',
                section: row[6]?.value.toString() ?? '');
            data.add(student);
          }
        }
      }
      EasyLoading.show(status: 'Loading');
      try {
        QuerySnapshot<Map<String, dynamic>> querySnapshot =
            await FirebaseFirestore.instance
                .collection('courses')
                .where('courseId', isEqualTo: widget.course.courseId)
                .limit(1)
                .get();
        List<Map<String, dynamic>> studentsJson =
            data.map((e) => e.toJson()).toList();

        await FirebaseFirestore.instance
            .collection('courses')
            .doc(querySnapshot.docs.first.id)
            .update({'students': studentsJson});
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
      EasyLoading.dismiss();

      studentsToAdd.clear();
      setState(() {
        widget.studentsData = [...widget.studentsData, ...data];
      });

      print('Parsed Data: $studentsData');
    } else {
      // User canceled the picker
      print('File selection canceled.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Students List',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: widget.studentsData.isEmpty
            ? Center(
                child: Text('No Student Found'),
              )
            : ListView.builder(
                itemCount: widget.studentsData.length,
                itemBuilder: (context, index) {
                  StudentModel student = widget.studentsData[index];
                  return ListTile(
                    title: Text(student.fullName.toString()),
                    subtitle: Text(student.rollNo.toString()),
                    trailing: InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                    "Do you want to delete (${student.fullName.toString()})?"),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      deleteStudentFromCourse(widget
                                              .studentsData[index].rollNo
                                              .toString())
                                          .then((value) {
                                        Navigator.pop(context);
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.errorColor),
                                    child: Text(
                                      'Yes',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'No',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            AppColors.primaryColor),
                                  ),
                                ],
                              );
                            });
                      },
                      child: CircleAvatar(
                        child: Icon(Icons.delete),
                      ),
                    ),
                  );
                },
              ),
        floatingActionButton: widget.isViewing
            ? FloatingActionButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Add Student(s)'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () {
                                  TextEditingController nameController =
                                      TextEditingController();
                                  TextEditingController rollNoController =
                                      TextEditingController();
                                  TextEditingController emailController =
                                      TextEditingController();
                                  TextEditingController departmentController =
                                      TextEditingController();
                                  TextEditingController programController =
                                      TextEditingController();
                                  TextEditingController batchController =
                                      TextEditingController();
                                  TextEditingController sectionController =
                                      TextEditingController();
                                  showModalBottomSheet(
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (context) {
                                        return Container(
                                          // color: Colors.white,
                                          // height: MediaQuery.of(context).size.height *
                                          //     0.7,
                                          // width: MediaQuery.of(context).size.width,
                                          child: Form(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    'Add Student',
                                                    style: TextStyle(
                                                      fontSize: 24,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  MyTextField(
                                                    label: 'Name',
                                                    controller: nameController,
                                                    validator: (value) {
                                                      return null;
                                                    },
                                                  ),
                                                  MyTextField(
                                                    label: 'Roll No',
                                                    controller:
                                                        rollNoController,
                                                    validator: (value) {
                                                      return null;
                                                    },
                                                  ),
                                                  MyTextField(
                                                    label: 'Email',
                                                    controller: emailController,
                                                    validator: (value) {
                                                      return null;
                                                    },
                                                  ),
                                                  MyTextField(
                                                    label: 'Department',
                                                    controller:
                                                        departmentController,
                                                    validator: (value) {
                                                      return null;
                                                    },
                                                  ),
                                                  MyTextField(
                                                    label: 'Section',
                                                    controller:
                                                        sectionController,
                                                    validator: (value) {
                                                      return null;
                                                    },
                                                  ),
                                                  MyTextField(
                                                    label: 'Program',
                                                    controller:
                                                        programController,
                                                    validator: (value) {
                                                      return null;
                                                    },
                                                  ),
                                                  MyTextField(
                                                    label: 'Batch',
                                                    controller: batchController,
                                                    validator: (value) {
                                                      return null;
                                                    },
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      StudentModel
                                                          studentModel =
                                                          StudentModel(
                                                        fullName:
                                                            nameController.text,
                                                        rollNo: rollNoController
                                                            .text,
                                                        email: emailController
                                                            .text,
                                                        department:
                                                            departmentController
                                                                .text,
                                                        section:
                                                            sectionController
                                                                .text,
                                                        program:
                                                            programController
                                                                .text,
                                                        batch: batchController
                                                            .text,
                                                      );
                                                      studentsToAdd.clear();
                                                      studentsToAdd
                                                          .add(studentModel);
                                                      addStudents()
                                                          .then((value) {
                                                        fetchStudents()
                                                            .then((value) {
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      });
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor: AppColors
                                                          .primaryColor,
                                                      minimumSize: Size(
                                                        double.infinity,
                                                        50,
                                                      ),
                                                    ),
                                                    child: Text(
                                                      'Add Student',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                },
                                child: ListTile(
                                  leading: Icon(Icons.person),
                                  title: Text('Add Student'),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  pickFileaAndUpload().then((value) {
                                    Navigator.pop(context);
                                  });
                                },
                                child: ListTile(
                                  leading: Icon(Icons.group),
                                  title: Text('Add Students File'),
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                },
                child: Icon(
                  Icons.person_add,
                  color: Colors.white,
                ),
                backgroundColor: AppColors.primaryColor,
              )
            : SizedBox(),
      ),
    );
  }

  Future<void> addStudents() async {
    EasyLoading.show(status: 'Adding');
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('courses')
              .where('courseId', isEqualTo: widget.course.courseId)
              .limit(1)
              .get();

      List<StudentModel> students = [...widget.studentsData, ...studentsToAdd];

      List<Map<String, dynamic>> studentsJson =
          students.map((e) => e.toJson()).toList();

      await FirebaseFirestore.instance
          .collection('courses')
          .doc(querySnapshot.docs.first.id)
          .update({'students': studentsJson});

      setState(() {
        widget.studentsData = students;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    EasyLoading.dismiss();
  }
}
