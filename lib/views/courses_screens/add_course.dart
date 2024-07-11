// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'dart:math';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:food_saver/models/course_model.dart';
import 'package:food_saver/models/user_model.dart';
import 'package:food_saver/res/colors.dart';
import 'package:food_saver/res/components/my_textfield.dart';
import 'package:food_saver/services/dropdown_services.dart';
import 'package:food_saver/views/courses_screens/studets_list.dart';

class AddCourseScreen extends StatefulWidget {
  const AddCourseScreen({super.key});

  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  TextEditingController courseTitleController = TextEditingController();
  TextEditingController courseCodeController = TextEditingController();
  TextEditingController courseCreditHourController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController sectionController = TextEditingController();
  TextEditingController batchController = TextEditingController();
  TextEditingController programConroller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> lecturesList = [];

  void _selectTime(
      BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        controller.text = picked.format(context);
      });
    }
  }

  List<StudentModel> studentsData = [];

  Future<void> pickAndParseExcelFile() async {
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

      setState(() {
        studentsData = data.map((e) => e).toList();
      });

      print('Parsed Data: $studentsData');
    } else {
      // User canceled the picker
      print('File selection canceled.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                MyTextField(
                    label: 'Course Title',
                    controller: courseTitleController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Course Title Can't be empty";
                      } else {
                        return null;
                      }
                    }),
                MyTextField(
                    label: 'Course Code',
                    controller: courseCodeController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Course Code Can't be empty";
                      } else {
                        return null;
                      }
                    }),
                MyTextField(
                    label: 'Credit Hours',
                    controller: courseCreditHourController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Credit Hours Can't be empty";
                      } else {
                        return null;
                      }
                    }),
                MyTextField(
                    label: 'Program',
                    controller: programConroller,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Program Can't be empty";
                      } else {
                        return null;
                      }
                    }),
                MyTextField(
                    label: 'Department',
                    controller: departmentController,
                    icon: Icons.arrow_drop_down,
                    isReadOnly: true,
                    ontap: () => showDropDownSheet(
                          'Department',
                          DropdownService.departments,
                          departmentController,
                        ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Department Can't be empty";
                      } else {
                        return null;
                      }
                    }),
                MyTextField(
                  label: 'Section',
                  controller: sectionController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Section Can't be empty";
                    } else {
                      return null;
                    }
                  },
                ),
                MyTextField(
                  label: 'Batch',
                  controller: batchController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Batch Can't be empty";
                    } else {
                      return null;
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        TextEditingController startTimeController =
                            TextEditingController();
                        TextEditingController endTimeController =
                            TextEditingController();
                        TextEditingController roomLabelController =
                            TextEditingController();
                        TextEditingController dayController =
                            TextEditingController();
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Add Lecture'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  controller: startTimeController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    hintText: 'Pick Start Time',
                                    suffixIcon: Icon(Icons.timer),
                                  ),
                                  onTap: () {
                                    _selectTime(context, startTimeController);
                                  },
                                ),
                                TextFormField(
                                  controller: endTimeController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    hintText: 'Pick End Time',
                                    suffixIcon: Icon(Icons.timer),
                                  ),
                                  onTap: () {
                                    _selectTime(context, endTimeController);
                                  },
                                ),
                                TextFormField(
                                  controller: dayController,
                                  decoration: InputDecoration(
                                    hintText: 'Day',
                                  ),
                                ),
                                TextFormField(
                                  controller: roomLabelController,
                                  decoration: InputDecoration(
                                    hintText: 'Room Label',
                                  ),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    String lectId = 'lect-';
                                    Random random = Random();
                                    int min = 1000;
                                    int max = 9999;
                                    int id =
                                        min + random.nextInt(max - min + 1);
                                    lectId = lectId + id.toString();
                                    lecturesList.add({
                                      'lectureId': lectId,
                                      'startTime': startTimeController.text,
                                      'endTime': endTimeController.text,
                                      'roomLabel': roomLabelController.text,
                                      'day': dayController.text,
                                    });
                                    CourseModel.fetchStudentCourses();
                                    CourseModel.fetchTeacherCourses();
                                    setState(() {});
                                    startTimeController.clear();
                                    endTimeController.clear();
                                    roomLabelController.clear();
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(
                                      screenWidth,
                                      50,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    backgroundColor: AppColors.primaryColor,
                                  ),
                                  child: Text(
                                    'Add',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(
                          screenWidth * 0.45,
                          50,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: AppColors.primaryColor,
                      ),
                      child: Text(
                        'Add Lecture',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text('Lectures List'),
                                  content: lecturesList.isEmpty
                                      ? Text('No Lectures Found')
                                      : SizedBox(
                                          height: 100,
                                          width: screenWidth,
                                          child: ListView.builder(
                                              itemCount: lecturesList.length,
                                              itemBuilder: (context, index) {
                                                return ListTile(
                                                  title: Text(
                                                      'Lecture ${index + 1}'),
                                                  subtitle: Text(
                                                    '${lecturesList[index]['startTime']}-${lecturesList[index]['endTime']}-${lecturesList[index]['day']}',
                                                  ),
                                                  trailing: IconButton(
                                                    icon: Icon(Icons.close),
                                                    onPressed: () {
                                                      lecturesList
                                                          .removeAt(index);
                                                      Navigator.pop(context);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(SnackBar(
                                                              content: Text(
                                                                  'Lecture Removed')));
                                                      setState(() {});
                                                    },
                                                  ),
                                                );
                                              }),
                                        ),
                                ));
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(
                          screenWidth * 0.45,
                          50,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: AppColors.secondaryColor,
                      ),
                      child: Text(
                        'View',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () => pickAndParseExcelFile(),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(
                          screenWidth * 0.45,
                          50,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: AppColors.primaryColor,
                      ),
                      child: Text(
                        'Upload Students',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StudentsList(
                                      studentsData: studentsData,
                                      course: CourseModel(),
                                      isViewing: false,
                                    )));
                        // showDialog(
                        //     context: context,
                        //     builder: (context) => AlertDialog(
                        //           title: Text('Students List'),
                        //           content: studentsData.isEmpty
                        //               ? Text('No Students Found')
                        //               : SizedBox(
                        //                   height: 100,
                        //                   width: screenWidth,
                        //                   child: ListView.builder(
                        //                       itemCount: lecturesList.length,
                        //                       itemBuilder: (context, index) {
                        //                         print(studentsData[index]
                        //                             ['fullName']);
                        //                         return ListTile(
                        //                           title: Text(
                        //                               '${studentsData[index]['fullName']}'),
                        //                           subtitle: Text(
                        //                             '${studentsData[index]['rollNo'].toString()}}',
                        //                           ),
                        //                           trailing: IconButton(
                        //                             icon: Icon(Icons.close),
                        //                             onPressed: () {
                        //                               lecturesList
                        //                                   .removeAt(index);
                        //                               setState(() {});
                        //                             },
                        //                           ),
                        //                         );
                        //                       }),
                        //                 ),
                        //         ));
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(
                          screenWidth * 0.45,
                          50,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: AppColors.secondaryColor,
                      ),
                      child: Text(
                        'View',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      EasyLoading.show(status: 'Adding');

                      CourseModel.addCourseToFirestore(
                        courseTitleController.text,
                        courseCodeController.text,
                        courseCreditHourController.text,
                        UserModel.currentUser.fullName,
                        UserModel.currentUser.email,
                        departmentController.text,
                        sectionController.text,
                        batchController.text,
                        programConroller.text,
                        studentsData,
                        lecturesList,
                      ).then((isAdded) {
                        EasyLoading
                            .dismiss(); // Ensure dismiss is called only once
                        if (isAdded) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Course Added Successfully'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: Text('Ok'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Failed to add Course'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Ok'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(
                      screenWidth,
                      50,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: AppColors.primaryColor,
                  ),
                  child: Text(
                    'Add Course',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  showDropDownSheet(String placeholder, List<String> dropdownsList,
      TextEditingController textEditingController) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Select $placeholder',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: dropdownsList.length,
                  itemBuilder: (context, index) => ListTile(
                    onTap: () {
                      textEditingController.text = dropdownsList[index];
                      setState(() {});
                      Navigator.pop(context);
                    },
                    title: Text(dropdownsList[index]),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
