// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:food_saver/res/colors.dart';
import 'package:food_saver/res/components/my_textfield.dart';
import 'package:food_saver/res/components/role_widget.dart';
import 'package:food_saver/res/components/rounded_rectangular_button.dart';
import 'package:food_saver/res/enums.dart';
import 'package:food_saver/services/registration_services.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  UserRoles selectedRole = UserRoles.Teacher;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      extendBodyBehindAppBar: true,
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
              height: screenHeight * 0.5,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Forgot Password',
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
                      SizedBox(
                        height: 8,
                      ),
                      RoundedRectangularButton(
                        label: 'Forgot',
                        onPress: () {
                          RegistrationServices.resetPassword(
                                  email: emailController.text)
                              .then((value) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                // icon: Icon(Icons.email),
                                title: Text(
                                  'Email Sent',
                                  textAlign: TextAlign.center,
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      textAlign: TextAlign.center,
                                      'A password reset link has been sent to your email. Follow the link to Reset your password.',
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      textAlign: TextAlign.center,
                                      'Check your spam if email is not in inbox!',
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        width: 80,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: AppColors.secondaryColor,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Center(child: Text('Ok')),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                        },
                      ),
                    ],
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
