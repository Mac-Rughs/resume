import 'package:flutter/material.dart';
import 'package:resume_parser/dashboard.dart';
import 'package:resume_parser/profile.dart';


class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xff1b81f1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            ListTile(
              title: const Text(
                'Account',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              leading: const Icon(Icons.person, color: Color(0xff1b81f1)),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
              onTap: () {

              },
            ),
            Divider(color: Colors.grey[300]),
            ListTile(
              title: const Text(
                'Notifications',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              leading: const Icon(Icons.notifications, color: Color(0xff1b81f1)),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
              onTap: () {
                // Implement navigation or action
              },
            ),
            Divider(color: Colors.grey[300]),
            ListTile(
              title: const Text(
                'Privacy',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              leading: const Icon(Icons.lock, color: Color(0xff1b81f1)),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
              onTap: () {
                // Implement navigation or action
              },
            ),
            Divider(color: Colors.grey[300]),
            ListTile(
              title: const Text(
                'Security',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              leading: const Icon(Icons.security, color: Color(0xff1b81f1)),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
              onTap: () {
                // Implement navigation or action
              },
            ),
            Divider(color: Colors.grey[300]),
            ListTile(
              title: const Text(
                'Help',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              leading: const Icon(Icons.help, color: Color(0xff1b81f1)),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
              onTap: () {
                // Implement navigation or action
              },
            ),
            Divider(color: Colors.grey[300]),
          ],
        ),
      ),
    );
  }
}