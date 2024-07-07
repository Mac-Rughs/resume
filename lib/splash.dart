import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:resume_parser/login.dart';
import 'package:resume_parser/Homepage.dart'; // Import your HomePage
import 'package:shared_preferences/shared_preferences.dart';
import 'package:resume_parser/database/model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class splash extends StatefulWidget {
  const splash({super.key});

  @override
  State<splash> createState() => _splashState();
}

class _splashState extends State<splash> {
  Future<Widget> getNextScreen() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString('username');
    var password = prefs.getString('password');

    if (username != null && password != null) {
      // Retrieve the user from Hive database
      final userDB = await Hive.openBox<User>("UserDB");
      User? loggedInUser;
      for (var user in userDB.values) {
        if (user.username == username && user.password == password) {
          loggedInUser = user;
          break;
        }
      }

      if (loggedInUser != null) {
        return HomePage(user: loggedInUser);
      }
    }
    return login();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: getNextScreen(),
      builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: AnimatedSplashScreen(
              splash: 'assets/animations/splash.gif',
              splashIconSize: 2000,
              centered: true,
              nextScreen: snapshot.data ?? login(),
              backgroundColor: Colors.white,
              duration: 4800,
            ),
          );
        }
      },
    );
  }
}
