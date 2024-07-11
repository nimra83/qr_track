import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:food_saver/models/user_model.dart';
import 'package:food_saver/res/enums.dart';
import 'package:food_saver/res/utility_functions.dart';
import 'package:food_saver/services/session_management_services.dart';

class RegistrationServices {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<bool> userExists(String email, String collection) async {
    final QuerySnapshot result = await _firestore
        .collection(collection)
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    return result.docs.isNotEmpty;
  }

  static Future<bool> signInWithEmailPassword(
      {required String email,
      required String password,
      required UserRoles userRole}) async {
    if (await userExists(
        email, UtilityFunctions.getCollectionName(userRole.name))) {
      try {
        EasyLoading.show(status: 'Signing in');
        final UserCredential userCredential =
            await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
            .collection(UtilityFunctions.getCollectionName(userRole.name))
            .where('email', isEqualTo: email)
            .limit(1)
            .get();

        if (userRole == UserRoles.Student) {
          UserModel.currentUser =
              StudentModel.fromJson(querySnapshot.docs.first.data());
        } else {
          UserModel.currentUser =
              TeacherModel.fromJson(querySnapshot.docs.first.data());
        }
        EasyLoading.dismiss();
        return true;
      } catch (e) {
        print('Error signing in: $e');
        EasyLoading.dismiss();
        return false;
      }
    } else {
      return false;
    }
  }

  static Future<bool> signUpWithEmailPassword({
    required String email,
    required String password,
    required String fullName,
    required String rollNo,
    required String teacherId,
    required UserRoles userRole,
  }) async {
    try {
      EasyLoading.show(status: 'Registering');
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userRole == UserRoles.Teacher) {
        TeacherModel teacherModel = TeacherModel(
          email: email,
          fullName: fullName,
          teacherId: teacherId,
          userType: userRole.name,
        );
        await _firestore
            .collection(UtilityFunctions.getCollectionName(userRole.name))
            .add(teacherModel.toJson())
            .then((value) {
          UserModel.currentUser = teacherModel;
        });
      } else {
        StudentModel studentModel = StudentModel(
          email: email,
          fullName: fullName,
          rollNo: rollNo,
          userType: userRole.name,
        );
        await _firestore
            .collection(UtilityFunctions.getCollectionName(userRole.name))
            .add(studentModel.toJson())
            .then((value) {
          UserModel.currentUser = studentModel;
        });
      }

      EasyLoading.dismiss();
      return true;
    } catch (e) {
      print('Error signing up: $e');
      EasyLoading.dismiss();
      return false;
    }
  }

  static Future<void> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Error resetting password: $e');
    }
  }

  static Future<void> logoutUser() async {
    try {
      SessionManagementService.destroySession();
      await _auth.signOut();
    } catch (e) {}
  }
}
