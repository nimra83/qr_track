import 'package:flutter/material.dart';
import 'package:food_saver/screens/dashboard/location_screen.dart';
import 'package:food_saver/screens/mainPage/mainpage.dart';
import 'package:food_saver/screens/profile_screen.dart';

class Dashboard extends StatefulWidget {
  static String routename = "/dashboard";
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<Dashboard> {
  int _currentIndex = 0;
  PageController _pageController = PageController();

  List<Widget> _pages = [
    MyMainpage(),
    LocationScreen(),
    ProfileScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Location',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}