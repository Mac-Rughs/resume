import 'package:flutter/material.dart';
import 'package:resume_parser/login.dart';
import 'package:resume_parser/signup.dart';
import 'package:resume_parser/splash.dart';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _navigatorState();
}

class _navigatorState extends State<profile> {
  final screens = [
    login(),
    signup(),
    splash(),

  ];
  int _currentIndex = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white54,
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index){
            setState(() {
              _currentIndex = index;
            });

          },
          backgroundColor: Colors.cyan,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search),label: 'Search'),
            BottomNavigationBarItem(icon: Icon(Icons.settings),label: 'Settings'),


          ],
        ),
        body: screens[_currentIndex]

    );
  }
}

