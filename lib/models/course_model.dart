import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:food_saver/models/user_model.dart';
import 'package:intl/intl.dart';

class CourseModel {
  String? courseId;
  String? courseTitle;
  String? courseCode;
  String? creditHours;
  String? instructorEmail;
  String? instructorName;
  String? department;
  String? section;
  String? batch;
  String? program;
  List<StudentModel>? students;
  List<Map<String, dynamic>>? lectures;

  static List<CourseModel> coursesList = [];

  CourseModel(
      {this.courseId,
      this.courseTitle,
      this.courseCode,
      this.creditHours,
      this.instructorName,
      this.instructorEmail,
      this.department,
      this.section,
      this.batch,
      this.program,
      this.students,
      this.lectures});

  CourseModel.fromJson(Map<String, dynamic> json) {
    courseId = json['courseId'];
    courseTitle = json['courseTitle'];
    courseCode = json['courseCode'];
    creditHours = json['creditHours'];
    instructorName = json['instructorName'];
    instructorEmail = json['instructorEmail'];
    department = json['department'];
    section = json['section'];
    batch = json['batch'];
    program = json['program'];
    if (json['students'] != null) {
      students = <StudentModel>[];
      json['students'].forEach((v) {
        students!.add(StudentModel.fromJson(v));
      });
    }
    if (json['lectures'] != null) {
      lectures = <Map<String, dynamic>>[];
      json['lectures'].forEach((v) {
        lectures!.add(Map<String, dynamic>.from(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['courseId'] = courseId;
    data['courseTitle'] = courseTitle;
    data['courseCode'] = courseCode;
    data['creditHours'] = creditHours;
    data['instructorEmail'] = instructorEmail;
    data['instructorName'] = instructorName;
    data['department'] = department;
    data['section'] = section;
    data['batch'] = batch;
    data['program'] = program;
    if (students != null) {
      data['students'] = students!.map((v) => v.toJson()).toList();
    }
    if (lectures != null) {
      data['lectures'] = lectures!;
    }
    return data;
  }

  static Future<bool> addCourseToFirestore(
    String courseTitle,
    String courseCode,
    String creditHours,
    String instructorName,
    String instructorEmail,
    String department,
    String section,
    String batch,
    String program,
    List<StudentModel> students,
    List<Map<String, dynamic>> lectures,
  ) async {
    String courseId = generateRandomCourseId();
    CourseModel newCourse = CourseModel(
      courseId: courseId,
      courseTitle: courseTitle,
      courseCode: courseCode,
      creditHours: creditHours,
      instructorName: instructorName,
      instructorEmail: instructorEmail,
      department: department,
      section: section,
      batch: batch,
      program: program,
      students: students,
      lectures: lectures,
    );

    Map<String, dynamic> courseData = newCourse.toJson();

    await FirebaseFirestore.instance
        .collection('courses')
        .doc(courseId)
        .set(courseData)
        .then((_) {
      print("Course added successfully!");
    }).catchError((error) {
      print("Failed to add course: $error");
      return false;
    });
    return true;
  }

  static Future<void> fetchTeacherCourses() async {
    try {
      EasyLoading.show(status: 'Loading');
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('courses')
              .where(
                'instructorEmail',
                isEqualTo: UserModel.currentUser.email,
              )
              .get();
      coursesList.clear();
      querySnapshot.docs.forEach((doc) {
        coursesList.add(CourseModel.fromJson(doc.data()));
      });
      print('Courses fetched successfully: ${coursesList.length} courses');
    } catch (e) {
      print('Error fetching courses: $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  static Future<void> fetchStudentCourses() async {
    try {
      EasyLoading.show(status: 'Loading');
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('courses')
              .where(
                'department',
                isEqualTo: UserModel.currentUser.department,
              )
              .get();
      coursesList.clear();
      querySnapshot.docs.forEach((doc) {
        for (int i = 0; i < doc.data()['students'].length; i++) {
          if (doc.data()['students'][i]['rollNo'] ==
              UserModel.currentUser.rollNo) {
            coursesList.add(CourseModel.fromJson(doc.data()));
          }
        }
      });
      print('Courses fetched successfully: ${coursesList.length} courses');
    } catch (e) {
      print('Error fetching courses: $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  static Future<List<Map<String, dynamic>>>
      getCoursesWithLecturesToday() async {
    List<Map<String, dynamic>> coursesWithLectureIds = [];

    // Determine today's day of the week (e.g., Monday)
    String todayDayName = DateFormat('EEEE').format(DateTime.now());

    // Iterate through the courses list
    for (CourseModel course in CourseModel.coursesList) {
      if (course.lectures != null) {
        // Iterate through the lectures of each course
        for (Map<String, dynamic> lecture in course.lectures!) {
          String lectureDay =
              lecture['day']; // Assuming 'day' field in lecture map

          // Compare if the lecture is scheduled for today
          if (lectureDay.toLowerCase() == todayDayName.toLowerCase()) {
            // Prepare course data as JSON
            Map<String, dynamic> courseJson = course.toJson();

            // Create a map for the course and lecture ID
            Map<String, dynamic> courseWithLectureId = {
              'course': courseJson,
              'lecture': lecture, // Assuming 'lectureId' field in lecture map
            };

            // Add to the list
            coursesWithLectureIds.add(courseWithLectureId);
          }
        }
      }
    }

    // Return the list of courses with lectures today
    return coursesWithLectureIds;
  }

  static Future<Map<String, dynamic>>
      getCurrentOngoingCourseWithLecture() async {
    Map<String, dynamic> ongoingCourseWithLecture = {};

    // Get current day of the week (e.g., Monday)
    String todayDayName = DateFormat('EEEE').format(DateTime.now());

    // Get current time in HH:mm format
    String currentTime = DateFormat('HH:mm').format(DateTime.now());

    print('current time ${currentTime}');

    // Iterate through the courses list
    for (CourseModel course in CourseModel.coursesList) {
      if (course.lectures != null) {
        // Iterate through the lectures of each course
        for (Map<String, dynamic> lecture in course.lectures!) {
          String lectureDay =
              lecture['day']; // Assuming 'day' field in lecture map
          String lectureStartTime =
              lecture['startTime']; // Assuming 'startTime' field in lecture map
          String lectureEndTime =
              lecture['endTime']; // Assuming 'endTime' field in lecture map

          // Compare if the lecture is scheduled for today and ongoing
          if (lectureDay.toLowerCase() == todayDayName.toLowerCase()) {
            if (isTimeBetween(currentTime, lectureStartTime, lectureEndTime)) {
              // Prepare course data as JSON
              Map<String, dynamic> courseJson = course.toJson();

              // Create a map for the course and lecture
              ongoingCourseWithLecture = {
                'course': courseJson,
                'lecture': lecture,
              };

              // Return immediately after finding the ongoing lecture
              return ongoingCourseWithLecture;
            }
          }
        }
      }
    }

    // Return an empty map if no ongoing lecture is found
    return {};
  }

// Function to check if current time is between start and end times
  static bool isTimeBetween(
      String currentTime, String startTime, String endTime) {
    DateTime current = DateFormat('HH:mm').parse(currentTime);
    DateTime start = DateFormat('HH:mm').parse(startTime);
    DateTime end = DateFormat('HH:mm').parse(endTime);

    return current.isAfter(start) && current.isBefore(end);
  }
}

String generateRandomCourseId() {
  String courseId = 'course-';
  Random random = Random();
  int min = 1000;
  int max = 9999;
  int id = min + random.nextInt(max - min + 1);

  courseId = courseId + id.toString();

  return courseId;
}
