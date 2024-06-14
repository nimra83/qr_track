import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:food_saver/models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationServices {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static Future<bool> signUpWithEmail(UserModel userData) async {
    EasyLoading.show(status: 'Registering...');
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userData.email.toString(),
        password: userData.password.toString(),
      );
      print("User signed up: ${userCredential.user?.email}");
      FirebaseFirestore.instance
          .collection('users')
          .add(userData.toJson())
          .then((value) {
        EasyLoading.dismiss();
      });

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      } else {
        print('Failed with error code: ${e.code}');
        print(e.message);
      }
      EasyLoading.dismiss();
      return false;
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
      return false;
    }
  }

  static Future<bool> signInWithEmail(String email, String password) async {
    EasyLoading.show(status: 'Signing in');
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("User signed in: ${userCredential.user?.email}");
      EasyLoading.dismiss();
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
      } else {
        print('Failed with error code: ${e.code}');
        print(e.message);
      }
      EasyLoading.dismiss();
      return false;
    } catch (e) {
      EasyLoading.dismiss();
      print(e);
      return false;
    }
  }

  static Future<void> signInWithGoogle() async {
    EasyLoading.show(status: "Logging in");
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    UserCredential user =
        await FirebaseAuth.instance.signInWithCredential(credential);

    UserModel userModel = UserModel(
      email: user.user!.email.toString(),
      username: user.user!.displayName.toString(),
      phone: user.user!.phoneNumber.toString(),
      imageUrl: user.user!.photoURL.toString(),
    );

    FirebaseFirestore.instance.collection("users").add(userModel.toJson()).then((value){
      print("User added to firebase");
    });
    EasyLoading.dismiss();
  }
}
