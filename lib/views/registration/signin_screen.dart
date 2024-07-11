// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:food_saver/res/colors.dart';
import 'package:food_saver/res/components/my_textfield.dart';
import 'package:food_saver/res/components/role_widget.dart';
import 'package:food_saver/res/components/rounded_rectangular_button.dart';
import 'package:food_saver/res/enums.dart';
import 'package:food_saver/services/registration_services.dart';
import 'package:food_saver/services/session_management_services.dart';
import 'package:food_saver/views/dashboard.dart';
import 'package:food_saver/views/registration/forgot_password_screen.dart';
import 'package:food_saver/views/registration/signup_screen.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  UserRoles selectedRole = UserRoles.Teacher;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              Container(
                width: screenWidth,
                height: screenHeight * 0.4,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(150),
                    bottomRight: Radius.circular(150),
                  ),
                ),
              )
            ],
          ),
          SingleChildScrollView(
            child: Container(
              width: screenWidth * 0.9,
              height: screenHeight * 0.62,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 20,
                    color: Colors.black26,
                  ),
                ],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sign in',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          'Continue using:',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            RoleWidget(
                              role: UserRoles.Teacher.name,
                              icon: Icons.person,
                              isSelected: selectedRole == UserRoles.Teacher,
                              onTap: () {
                                setState(() {
                                  selectedRole = UserRoles.Teacher;
                                });
                              },
                            ),
                            RoleWidget(
                              role: UserRoles.Student.name,
                              icon: Icons.person,
                              isSelected: selectedRole == UserRoles.Student,
                              onTap: () {
                                setState(() {
                                  selectedRole = UserRoles.Student;
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        MyTextField(
                          label: 'Email',
                          controller: emailController,
                          validator: (value) {
                            if (value.toString().isEmpty) {
                              return "Email can't be empty.";
                            } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value.toString())) {
                              return "Email is not valid";
                            } else {
                              return null;
                            }
                          },
                        ),
                        MyTextField(
                          label: 'Password',
                          isPassword: true,
                          showPassword: hidePassword,
                          controller: passwordController,
                          onEyetap: () {
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Password Can't be empty";
                            } else if (value.length < 6) {
                              return "Invalid Password Length";
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        RoundedRectangularButton(
                          label: 'Sign in',
                          onPress: () {
                            if (formKey.currentState!.validate()) {
                              RegistrationServices.signInWithEmailPassword(
                                      email: emailController.text,
                                      password: passwordController.text,
                                      userRole: selectedRole)
                                  .then((loggedin) {
                                SessionManagementService.createSession(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  userRole: selectedRole,
                                ).then((value) {
                                  if (loggedin) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Dashboard(),
                                      ),
                                    );
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            icon: Icon(Icons.error),
                                            title: Text('Failed to login'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Ok'),
                                              ),
                                            ],
                                          );
                                        });
                                  }
                                });
                              });
                              setState(() {});
                            }
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("Don't have an account?"),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignupScreen(),
                                  ),
                                );
                              },
                              child: Text('Sign up'),
                            ),
                          ],
                        ),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ForgotPassword(),
                                ),
                              );
                            },
                            child: Text(
                              'Forgot Password',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
