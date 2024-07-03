// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:food_saver/models/user_model.dart';
import 'package:food_saver/screens/login/login.dart';
import 'package:food_saver/screens/mainPage/mainpage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  static String routename = "/profile";

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();

  Future<void> updateUserField(String field, String value) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
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
        MyMainpage.getCurrentUser().then((value) {
          setState(() {});
        });
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

  Future<void> updatePassword(String newPassword) async {
    User? user = FirebaseAuth.instance.currentUser;

    try {
      await user?.updatePassword(newPassword);
    } catch (e) {
      // Handle error
      print('Password update failed: $e');
    }
  }

  Future<void> uploadFileToFirebase(File image, BuildContext context) async {
    EasyLoading.show(status: 'Uploading');
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    try {
      TaskSnapshot snapshot = await firebaseStorage
          .ref("images/${image.uri.pathSegments.last}")
          .putFile(image);

      String downloadUrl = await snapshot.ref.getDownloadURL();

      updateUserField("imageUrl", downloadUrl).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Image Uploaded. Download URL: $downloadUrl")),
        );
      });
      print("Download URL: $downloadUrl");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to upload image: $e")),
      );
    }
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Profile',
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.grey[
                          200], // You can set a background color if needed
                      child: MyMainpage.currentUser != null
                          ? (MyMainpage.currentUser!.imageUrl != null &&
                                  MyMainpage.currentUser!.imageUrl!.isNotEmpty
                              ? ClipOval(
                                  child: FadeInImage(
                                    placeholder:
                                        AssetImage('assets/icons/user.png'),
                                    image: NetworkImage(
                                        MyMainpage.currentUser!.imageUrl!),
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.cover,
                                    imageErrorBuilder:
                                        (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/icons/user.png',
                                        width: 200,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                )
                              : ClipOval(
                                  child: Image.asset(
                                    'assets/icons/user.png',
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.contain,
                                  ),
                                ))
                          : const CircularProgressIndicator(),
                    ),
                    Positioned(
                      top: 20,
                      right: MediaQuery.of(context).size.width * 0.05,
                      child: InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Pick Image'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          ImagePicker imagePicker =
                                              ImagePicker();
                                          XFile? pickedImage =
                                              await imagePicker.pickImage(
                                                  source: ImageSource.camera);
                                          if (pickedImage != null) {
                                            showModalBottomSheet(
                                                context: context,
                                                builder: (context) {
                                                  return Container(
                                                    padding: EdgeInsets.all(20),
                                                    height: 500,
                                                    width: double.infinity,
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          'Image Preview',
                                                          style: TextStyle(
                                                            fontSize: 24,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        SizedBox(
                                                          height: 450,
                                                          child: Image.file(
                                                              fit: BoxFit.cover,
                                                              File(pickedImage
                                                                  .path)),
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        ElevatedButton(
                                                            onPressed: () {
                                                              uploadFileToFirebase(
                                                                      File(pickedImage
                                                                          .path),
                                                                      context)
                                                                  .then(
                                                                      (value) {
                                                                Navigator.pop(
                                                                    context);
                                                                Navigator.pop(
                                                                    context);
                                                              });
                                                            },
                                                            child:
                                                                Text('Upload'))
                                                      ],
                                                    ),
                                                  );
                                                });
                                          }
                                        },
                                        child: ListTile(
                                          title: Text('Camera'),
                                          leading: Icon(Icons.camera_alt),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          ImagePicker imagePicker =
                                              ImagePicker();
                                          XFile? pickedImage =
                                              await imagePicker.pickImage(
                                                  source: ImageSource.gallery);
                                          if (pickedImage != null) {
                                            showModalBottomSheet(
                                                context: context,
                                                builder: (context) {
                                                  return Container(
                                                    margin: EdgeInsets.all(20),
                                                    height: 500,
                                                    width: double.infinity,
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          'Image Preview',
                                                          style: TextStyle(
                                                              fontSize: 24,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        SizedBox(
                                                          height: 300,
                                                          child: Image.file(
                                                              File(pickedImage
                                                                  .path)),
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        ElevatedButton(
                                                            onPressed: () {
                                                              uploadFileToFirebase(
                                                                      File(pickedImage
                                                                          .path),
                                                                      context)
                                                                  .then(
                                                                      (value) {
                                                                Navigator.pop(
                                                                    context);
                                                                Navigator.pop(
                                                                    context);
                                                              });
                                                            },
                                                            child:
                                                                Text('Upload'))
                                                      ],
                                                    ),
                                                  );
                                                });
                                          }
                                        },
                                        child: ListTile(
                                          title: Text('Gallery'),
                                          leading: Icon(Icons.browse_gallery),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              });
                        },
                        child: const CircleAvatar(
                          backgroundColor: Colors.deepPurple,
                          child: Icon(
                            Icons.edit,
                            size: 25,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  isThreeLine: true,
                  title: const Text(
                    'Name',
                  ),
                  subtitle: Text(
                    MyMainpage.currentUser!.username.toString(),
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  trailing: InkWell(
                      onTap: () {
                        TextEditingController nameController =
                            TextEditingController();
                        final formKey = GlobalKey<FormState>();
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Change Name"),
                                content: Form(
                                  key: formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextFormField(
                                          controller: nameController,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.all(10),
                                              hintText: "New Name"),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Field can't be empty";
                                            } else if (value ==
                                                MyMainpage.currentUser!.username
                                                    .toString()) {
                                              return "Old and New Name can't be same";
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
                                            backgroundColor: Colors.black),
                                        onPressed: () {
                                          if (formKey.currentState!
                                              .validate()) {
                                            updateUserField("username",
                                                    nameController.text)
                                                .then((value) {
                                              Navigator.pop(context);
                                            });
                                          }
                                        },
                                        child: const Text("Update"),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      child: const Icon(Icons.edit)),
                ),
                ListTile(
                  title: const Text(
                    'Email',
                  ),
                  subtitle: Text(
                    MyMainpage.currentUser!.email.toString(),
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  title: const Text(
                    'Phone',
                  ),
                  subtitle: Text(
                    MyMainpage.currentUser!.phone.toString(),
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  isThreeLine: true,
                  trailing: InkWell(
                      onTap: () {
                        TextEditingController phoneNoController =
                            TextEditingController();
                        final formKey = GlobalKey<FormState>();
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Change Phone No"),
                                content: Form(
                                  key: formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextFormField(
                                          controller: phoneNoController,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.all(10),
                                              hintText: "New Phone No"),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Field can't be empty";
                                            } else if (value ==
                                                MyMainpage.currentUser!.phone
                                                    .toString()) {
                                              return "Old and New Phone can't be same";
                                            } else if (value.length < 11) {
                                              return "Invalid Phone Number";
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
                                            backgroundColor: Colors.black),
                                        onPressed: () {
                                          if (formKey.currentState!
                                              .validate()) {
                                            updateUserField("phone",
                                                    phoneNoController.text)
                                                .then((value) {
                                              Navigator.pop(context);
                                            });
                                          }
                                        },
                                        child: const Text("Update"),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      child: const Icon(Icons.edit)),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      maximumSize: Size(MediaQuery.of(context).size.width, 50),
                      minimumSize: Size(MediaQuery.of(context).size.width, 50),
                      backgroundColor: Colors.black),
                  onPressed: () {
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
                                            currentPasswordController.text) {
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
                                            currentPasswordController.text) {
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
                                            MediaQuery.of(context).size.width,
                                            50),
                                        minimumSize: Size(
                                            MediaQuery.of(context).size.width,
                                            50),
                                        backgroundColor: Colors.deepPurple),
                                    onPressed: () async {
                                      if (passwordFormKey.currentState!
                                          .validate()) {
                                        reAuthenticateUser(
                                                MyMainpage.currentUser!.email
                                                    .toString(),
                                                currentPasswordController.text)
                                            .then((value) {
                                          updatePassword(
                                              newPasswordController.text);
                                          updateUserField("password",
                                                  newPasswordController.text)
                                              .then((value) async {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        "Password Updated Successfully")));
                                            SharedPreferences
                                                sharedPreferences =
                                                await SharedPreferences
                                                    .getInstance();
                                            sharedPreferences
                                                .clear()
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
                  child: const Text(
                    'Change Password',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      maximumSize: Size(MediaQuery.of(context).size.width, 50),
                      minimumSize: Size(MediaQuery.of(context).size.width, 50),
                      backgroundColor: Colors.deepPurple),
                  onPressed: () async {
                    SharedPreferences sharedPreferences =
                        await SharedPreferences.getInstance();
                    sharedPreferences.clear();
                    FirebaseAuth.instance.signOut();
                    Navigator.pushNamedAndRemoveUntil(
                        context, MyLogin.routename, (route) => false);
                  },
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                // TextFormField(
                //   controller: nameController,
                //   decoration: InputDecoration(
                //     hintText: MyMainpage.currentUser!.username,
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(20),
                //     ),
                //     contentPadding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                //     suffixIcon: MyMainpage.currentUser != null
                //         ? Padding(
                //           padding: const EdgeInsets.only(right: 15.0),
                //           child: Icon(
                //                             Icons.check,
                //                             size: 35,
                //                             color: (nameController.text == MyMainpage.currentUser!.username || nameController.text.isEmpty)
                //             ? Colors.grey
                //             : Colors.deepPurple,
                //                           ),
                //         )
                //         : null,
                //   ),
                //   onChanged: (value){
                //     setState(() {
                //
                //     });
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
