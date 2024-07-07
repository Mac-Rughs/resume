import 'package:flutter/material.dart';
import 'package:resume_parser/dashboard.dart';
import 'package:resume_parser/database/model.dart';
import 'package:resume_parser/discover.dart';
import 'package:resume_parser/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'UploadResumePage.dart'; // Import your User model
import 'login.dart';

class DrawerPage extends StatelessWidget {
  final User user; // Accept user as a parameter

  const DrawerPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.cyan),
            accountName: Text(
              user.username,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              user.mail ?? "No email",
            ),
            currentAccountPicture: CircleAvatar(
              child: Icon(Icons.person),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text('My Profile'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => dashboard(user: user)),
                    ); // Navigate to profile page
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Account Settings'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SettingsPage()),
                    ); // Navigate to upload resume page
                  },
                ),
                ListTile(
                  leading: Icon(Icons.upload),
                  title: Text('Upload Resume'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Discover(user: user)),
                    ); // Navigate to upload resume page
                  },
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                  onTap: () {
                    _showLogoutDialog(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Do You Wanna Exit'),
          actions: [
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () async {
                // Perform logout
                final SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear(); // Clear all shared preferences

                // Navigate to login page
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => login()),
                      (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
