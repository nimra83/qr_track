import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_saver/models/course_model.dart';
import 'package:food_saver/res/enums.dart';
import 'package:food_saver/res/utility_functions.dart';

class UserModel {
  String? fullName;
  String? email;
  String? profileImage;
  String? phone;
  String? userType;

  UserModel(
      {this.fullName,
      this.email,
      this.profileImage,
      this.phone,
      this.userType});

  UserModel.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    email = json['email'];
    profileImage = json['profileImage'];
    phone = json['phone'];
    userType = json['userType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fullName'] = fullName;
    data['email'] = email;
    data['profileImage'] = profileImage;
    data['phone'] = phone;
    data['userType'] = userType;
    return data;
  }

  static dynamic currentUser;

  static Future<void> getUserData(String userRole, String email) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection(UtilityFunctions.getCollectionName(userRole))
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (userRole == UserRoles.Student.name) {
      UserModel.currentUser =
          StudentModel.fromJson(querySnapshot.docs.first.data());
    } else {
      UserModel.currentUser =
          TeacherModel.fromJson(querySnapshot.docs.first.data());
    }
  }
}

class StudentModel extends UserModel {
  String? rollNo;
  String? department;
  String? section;
  String? batch;
  String? program;
  List<CourseModel>? courses;

  StudentModel({
    super.fullName,
    super.email,
    super.profileImage,
    super.phone,
    super.userType,
    this.rollNo,
    this.department,
    this.section,
    this.batch,
    this.program,
    this.courses,
  });

  StudentModel.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    email = json['email'];
    profileImage = json['profileImage'];
    phone = json['phone'];
    userType = json['userType'];
    rollNo = json['rollNo'];
    department = json['department'];
    section = json['section'];
    batch = json['batch'];
    program = json['program'];

    if (json['courses'] != null) {
      courses = <CourseModel>[];
      json['courses'].forEach((v) {
        courses!.add(CourseModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fullName'] = fullName;
    data['email'] = email;
    data['profileImage'] = profileImage;
    data['userType'] = userType;
    data['rollNo'] = rollNo;
    data['department'] = department;
    data['section'] = section;
    data['batch'] = batch;
    data['program'] = program;
    if (courses != null) {
      data['courses'] = courses!.map((v) => v.toJson()).toList();
    }
    return data;
  }

   void updateField(String field, dynamic value) {
    switch (field) {
      case 'fullName':
        fullName = value;
        break;
      case 'email':
        email = value;
        break;
      case 'profileImage':
        profileImage = value;
        break;
      case 'phone':
        phone = value;
        break;
      case 'userType':
        userType = value;
        break;
      case 'rollNo':
        rollNo = value;
        break;
      case 'department':
        department = value;
        break;
      case 'section':
        section = value;
        break;
      case 'batch':
        batch = value;
        break;
      case 'program':
        program = value;
        break;
      case 'courses':
        if (value is List) {
          courses = value.map((v) => CourseModel.fromJson(v)).toList();
        }
        break;
      default:
        throw ArgumentError('Unknown field: $field');
    }
  }
}

class TeacherModel extends UserModel {
  String? teacherId;
  List<CourseModel>? courses;

  TeacherModel({
    super.fullName,
    super.email,
    super.profileImage,
    super.phone,
    super.userType,
    this.teacherId,
    this.courses,
  });

  TeacherModel.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    email = json['email'];
    profileImage = json['profileImage'];
    phone = json['phone'];
    userType = json['userType'];
    teacherId = json['teacherId'];

    if (json['courses'] != null) {
      courses = <CourseModel>[];
      json['courses'].forEach((v) {
        courses!.add(CourseModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fullName'] = fullName;
    data['email'] = email;
    data['profileImage'] = profileImage;
    data['phone'] = phone;
    data['userType'] = userType;
    data['teacherId'] = teacherId;
    if (courses != null) {
      data['courses'] = courses!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  void updateField(String field, dynamic value) {
    switch (field) {
      case 'fullName':
        fullName = value;
        break;
      case 'email':
        email = value;
        break;
      case 'profileImage':
        profileImage = value;
        break;
      case 'phone':
        phone = value;
        break;
      case 'userType':
        userType = value;
        break;
      case 'teacherId':
        teacherId = value;
        break;
      case 'courses':
        if (value is List) {
          courses = value.map((v) => CourseModel.fromJson(v)).toList();
        }
        break;
      default:
        throw ArgumentError('Unknown field: $field');
    }
  }
}
