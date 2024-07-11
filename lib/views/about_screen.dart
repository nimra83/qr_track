// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  bool isIntroductionExpanded = true;
  bool isFeaturesExpanded = false;
  bool isWhyChooseExpanded = false;
  bool isGetStartedExpanded = false;
  bool isContactUsExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About QrTrack'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    if (index == 0) {
                      isIntroductionExpanded = !isIntroductionExpanded;
                    } else if (index == 1) {
                      isFeaturesExpanded = !isFeaturesExpanded;
                    } else if (index == 2) {
                      isWhyChooseExpanded = !isWhyChooseExpanded;
                    } else if (index == 3) {
                      isGetStartedExpanded = !isGetStartedExpanded;
                    } else if (index == 4) {
                      isContactUsExpanded = !isContactUsExpanded;
                    }
                  });
                },
                children: [
                  ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: Text('Introduction'),
                      );
                    },
                    body: ListTile(
                      title: Text(
                          'Welcome to QrTrack, the ultimate solution for effortlessly managing student attendance through QR code scanning. Our app is designed to make attendance tracking efficient, accurate, and secure, ensuring a seamless experience for educators and students alike.'),
                    ),
                    isExpanded: isIntroductionExpanded,
                  ),
                  ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: Text('Key Features'),
                      );
                    },
                    body: ListTile(
                      title: Text(
                          '1. Effortless QR Code Scanning: Instantly mark attendance by scanning a dynamic QR code. Save time and eliminate manual entry errors.\n'
                          '2. Secure and Dynamic: QrTrack ensures security by generating unique QR codes that change periodically, protecting against misuse and unauthorized attendance marking.\n'
                          '3. Real-time Updates: Attendance records are updated in real-time, providing instant access to attendance data for both teachers and students.\n'
                          '4. Comprehensive Reports: Generate detailed attendance reports with just a few clicks. Track attendance trends and identify patterns for better classroom management.\n'
                          '5. User-Friendly Interface: Easy-to-navigate design that makes attendance tracking a breeze. Intuitive controls for both teachers and students.\n'
                          '6. Multi-platform Support: Access QrTrack on various devices, including smartphones, tablets, and desktops. Synchronize data across all your devices for seamless tracking.'),
                    ),
                    isExpanded: isFeaturesExpanded,
                  ),
                  ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: Text('Why Choose QrTrack?'),
                      );
                    },
                    body: ListTile(
                      title: Text(
                          'Enhanced Security: Our dynamic QR code system ensures that each code is unique and time-sensitive, providing an extra layer of security against fraudulent entries.\n'
                          'Accuracy and Reliability: Say goodbye to the inaccuracies of manual attendance. QrTrack guarantees precise and dependable attendance records.\n'
                          'Efficiency: Simplify your attendance process with quick QR code scans, freeing up more time for teaching and learning.\n'
                          'User-Centric Design: We prioritize your experience by offering an app that is both powerful and easy to use, designed with the needs of educators and students in mind.'),
                    ),
                    isExpanded: isWhyChooseExpanded,
                  ),
                  ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: Text('Get Started'),
                      );
                    },
                    body: ListTile(
                      title: Text(
                          'Ready to revolutionize your attendance tracking? Download QrTrack today and experience the future of attendance management. Join the growing community of educators who trust QrTrack to keep their classrooms running smoothly and securely.'),
                    ),
                    isExpanded: isGetStartedExpanded,
                  ),
                  ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: Text('Contact Us'),
                      );
                    },
                    body: ListTile(
                      title: Text(
                          'Have questions or need assistance? Our support team is here to help!\n'
                          'Email: qrtrack84@gmail.com\n'
                          'Phone: +123-456-7890\n'
                          'Website: www.qrtrack.com\n'
                          'Thank you for choosing QrTrack – where technology meets education to create a more efficient and secure learning environment.'),
                    ),
                    isExpanded: isContactUsExpanded,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
