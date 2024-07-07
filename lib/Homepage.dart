import 'package:flutter/material.dart';
import 'package:resume_parser/database/model.dart';
import 'package:resume_parser/discover.dart';

import 'DrawerPage.dart';
import 'FeedbackPage.dart';
import 'UploadResumePage.dart';
import 'dashboard.dart';
import 'faq.dart'; // Import your User model

class HomePage extends StatefulWidget {
  final User user; // Add user as a required parameter

  const HomePage({Key? key, required this.user}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: body(),
      drawer: DrawerPage(user: widget.user), // Pass user to DrawerPage
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 1.0,
            color: Colors.grey,
          ),
          BottomNavigationBar(
            backgroundColor: Colors.cyan,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_outlined),
                label: 'Account',
              ),

              BottomNavigationBarItem(
                icon: Icon(Icons.question_answer),
                label: 'F&Q',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.feedback),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.black54,
            onTap: _onItemTapped,
          ),
        ],
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Text('Resume Parser'),
    );
  }

  Widget body() {
    return Column(
      children: [
        SizedBox(height: 30,),
      Text("Welcome To",style: TextStyle(fontSize: 30)),
        Center(
          child: Image.asset('assets/images/logo.png'),
        ),
        ElevatedButton(
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Discover(user: widget.user)),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.cyan,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: const Text(
            "  DISCOVER  ",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if(index == 1 )
    {
      Navigator.push(context, MaterialPageRoute(builder: (context) => dashboard(user: widget.user)));
    }
    if(index == 2 )
    {
      Navigator.push(context, MaterialPageRoute(builder: (context) => FAQPage()));
    }
    if(index == 3 )
    {
      Navigator.push(context, MaterialPageRoute(builder: (context) => FeedbackPage()));
    }
  }
}
