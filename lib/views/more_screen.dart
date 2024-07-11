// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_saver/models/user_model.dart';
import 'package:food_saver/res/colors.dart';
import 'package:food_saver/res/utility_functions.dart';
import 'package:food_saver/services/registration_services.dart';
import 'package:food_saver/services/session_management_services.dart';
import 'package:food_saver/services/theme_service.dart';
import 'package:food_saver/views/about_screen.dart';
import 'package:food_saver/views/attendances_screens/atttendances_screen.dart';
import 'package:food_saver/views/profile_screen.dart';
import 'package:food_saver/views/registration/signin_screen.dart';
import 'package:provider/provider.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  Future<void> updatePassword(String newPassword) async {
    User? user = FirebaseAuth.instance.currentUser;

    try {
      await user?.updatePassword(newPassword);
    } catch (e) {
      // Handle error
      print('Password update failed: $e');
    }
  }

  Future<void> updateUserField(String field, String value) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection(UtilityFunctions.getCollectionName(
                  UserModel.currentUser.userType))
              .where('email',
                  isEqualTo: FirebaseAuth.instance.currentUser!.email)
              .limit(1)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        String userId = querySnapshot.docs.first.id;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({field: value});
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${field} updated successfully')));
        UserModel.getUserData(
            UtilityFunctions.getCollectionName(UserModel.currentUser.userType),
            UserModel.currentUser.email);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('User not found')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to update name: $e')));
    }
  }

  Future<void> reAuthenticateUser(String email, String currentPassword) async {
    User? user = FirebaseAuth.instance.currentUser;

    AuthCredential credential =
        EmailAuthProvider.credential(email: email, password: currentPassword);

    try {
      await user?.reauthenticateWithCredential(credential);
    } catch (e) {
      // Handle error
      print('ReAuthentication failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              'More',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ToffeeWidget(
                      label: "Profile",
                      iconData: Icons.person,
                      onPress: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ProfileScreen();
                        }));
                      },
                    ),
                    ThemeToffeeWidget()
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ToffeeWidget(
                      label: "Change\nPassword",
                      iconData: Icons.change_circle,
                      onPress: () {
                        final passwordFormKey = GlobalKey<FormState>();
                        final TextEditingController currentPasswordController =
                            TextEditingController();
                        final TextEditingController newPasswordController =
                            TextEditingController();
                        final TextEditingController cNewPasswordController =
                            TextEditingController();
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Change Password"),
                                content: Form(
                                  key: passwordFormKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextFormField(
                                        controller: currentPasswordController,
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.all(10),
                                            hintText: "Current Password"),
                                      ),
                                      const SizedBox(height: 10),
                                      TextFormField(
                                          controller: newPasswordController,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.all(10),
                                              hintText: "New Password"),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Field can't be empty";
                                            } else if (value ==
                                                currentPasswordController
                                                    .text) {
                                              return "Old and New Password can't be same";
                                            } else if (value !=
                                                cNewPasswordController.text) {
                                              return "Confirm New Password";
                                            } else {
                                              return null;
                                            }
                                          }),
                                      const SizedBox(height: 10),
                                      TextFormField(
                                          controller: cNewPasswordController,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.all(10),
                                              hintText: "Confirm New Password"),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Field can't be empty";
                                            } else if (value ==
                                                currentPasswordController
                                                    .text) {
                                              return "Old and New Password can't be same";
                                            } else if (value !=
                                                newPasswordController.text) {
                                              return "Confirm New Password";
                                            } else {
                                              return null;
                                            }
                                          }),
                                      const SizedBox(height: 10),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            maximumSize: Size(
                                                MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                50),
                                            minimumSize: Size(
                                                MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                50),
                                            backgroundColor: Colors.deepPurple),
                                        onPressed: () async {
                                          if (passwordFormKey.currentState!
                                              .validate()) {
                                            reAuthenticateUser(
                                                    UserModel.currentUser!.email
                                                        .toString(),
                                                    currentPasswordController
                                                        .text)
                                                .then((value) {
                                              updatePassword(
                                                  newPasswordController.text);
                                              updateUserField(
                                                      "password",
                                                      newPasswordController
                                                          .text)
                                                  .then((value) async {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            "Password Updated Successfully")));
                                                SessionManagementService
                                                        .destroySession()
                                                    .then((value) {
                                                  Navigator.pop(context);
                                                });
                                              });
                                            });
                                          }
                                        },
                                        child: const Text(
                                          'Change Password',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                    ),
                    ToffeeWidget(
                      label: "Attendances",
                      iconData: Icons.list,
                      onPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AttendancesScreen()));
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ToffeeWidget(
                      label: "About",
                      iconData: Icons.info,
                      onPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AboutPage()));
                      },
                    ),
                    ToffeeWidget(
                      label: "Logout",
                      iconData: Icons.logout,
                      color: AppColors.errorColor,
                      onPress: () {
                        RegistrationServices.logoutUser().then((value) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => SigninScreen()),
                            (Route<dynamic> route) => false,
                          );
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          )),
    );
  }
}

class ToffeeWidget extends StatelessWidget {
  const ToffeeWidget(
      {super.key,
      required this.label,
      required this.iconData,
      required this.onPress,
      this.color = AppColors.secondaryColor});

  final String? label;
  final IconData? iconData;
  final Function onPress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () => onPress(),
      child: Container(
        width: screenWidth * 0.4,
        height: screenHeight * 0.2,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                size: 80,
                color: Provider.of<ThemeService>(context).currentThemeMode ==
                        'Light Theme'
                    ? Colors.white
                    : Colors.white70,
              ),
              Text(
                label.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ThemeToffeeWidget extends StatelessWidget {
  const ThemeToffeeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () {
        Provider.of<ThemeService>(context, listen: false).toggleTheme();
      },
      child: Container(
        width: screenWidth * 0.4,
        height: screenHeight * 0.2,
        decoration: BoxDecoration(
          color: Provider.of<ThemeService>(context).currentThemeMode ==
                  'Light Theme'
              ? AppColors.secondaryColor
              : AppColors.primaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Provider.of<ThemeService>(context).currentThemeMode ==
                        'Light Theme'
                    ? Icons.light_mode
                    : Icons.dark_mode,
                size: 80,
                color: Provider.of<ThemeService>(context).currentThemeMode ==
                        'Light Theme'
                    ? Colors.white
                    : Colors.white70,
              ),
              Text(
                Provider.of<ThemeService>(context).currentThemeMode.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Provider.of<ThemeService>(context).currentThemeMode ==
                          'Light Theme'
                      ? Colors.white
                      : Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
