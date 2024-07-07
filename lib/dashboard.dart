import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:resume_parser/login.dart';
import 'package:resume_parser/database/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'JobsPage.dart';

class dashboard extends StatefulWidget {
  User user;
  dashboard({super.key, required this.user});

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  final TextEditingController updateUsernameController = TextEditingController();
  final TextEditingController confirmUsernameController = TextEditingController();
  final TextEditingController confirmMailController = TextEditingController();
  final TextEditingController updateMailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "------------- PROFILE -----------",
        ),
        backgroundColor: Colors.cyan,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (ctx1) {
                    return AlertDialog(
                      title: Text("Do you want to logout"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("NO")),
                        TextButton(
                            onPressed: () async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              await prefs.clear();
                              Navigator.of(ctx1).pop();
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => login()),
                                    (Route<dynamic> route) => false,
                              );
                            },
                            child: Text("YES")),
                      ],
                    );
                  });
            },
            icon: Icon(Icons.close_rounded),
            color: Colors.white,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.cyan,
          child: Column(
            children: [
              Container(
                color: Colors.cyan,
                height: 300,
                width: double.infinity,
                child: Column(
                  children: [
                    Image.asset("assets/images/logo.png", height: 150,),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextButton(
                              onPressed: () {
                                userButtonSheet(context);
                              },
                              child: Text("${widget.user.username}", style: TextStyle(color: Colors.white, fontSize: 30,),)),
                          TextButton(
                              onPressed: () {
                                mailButtonSheet(context);
                              },
                              child: Text("${widget.user.mail}", style: TextStyle(color: Colors.white, fontSize: 20),)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 405,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60))),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => JobsPage(user: widget.user)),                        );
                      },
                      child: const Text("View Jobs",style: TextStyle(color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan,
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Add more profile information or buttons here
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> userButtonSheet(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(60))),
      builder: (context) {
        return Container(
          height: 405,
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/logo.png"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.05), BlendMode.dstATop),
              ),
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60), topRight: Radius.circular(60))),
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              children: [
                SizedBox(height: 40),
                TextField(
                  controller: updateUsernameController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.cyan),
                    ),
                    labelText: "Update Username",
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    hintText: 'Enter Username',
                  ),
                ),
                SizedBox(height: 30),
                TextField(
                  controller: confirmUsernameController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.cyan),
                    ),
                    labelText: "Confirm Username",
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    hintText: 'Renter Username',
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    if (updateUsernameController.text == confirmUsernameController.text &&
                        updateUsernameController.text.isNotEmpty) {
                      final UserDB = await Hive.openBox<User>("UserDB");
                      User user = widget.user;
                      user.username = updateUsernameController.text;
                      await UserDB.put(user.key, user);
                      setState(() {
                        widget.user.username = updateUsernameController.text;
                      });
                      Navigator.pop(context);
                      Fluttertoast.showToast(msg: ("Update Successful"));
                    }
                  },
                  child: Text('Update'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> mailButtonSheet(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(60))),
      builder: (context) {
        return Container(
          height: 405,
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/logo.png"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.05), BlendMode.dstATop),
              ),
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60), topRight: Radius.circular(60))),
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              children: [
                SizedBox(height: 40),
                TextField(
                  controller: updateMailController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.cyan),
                    ),
                    labelText: "Update Mail",
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    hintText: 'Enter Mail Id',
                  ),
                ),
                SizedBox(height: 30),
                TextField(
                  controller: confirmMailController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.cyan),
                    ),
                    labelText: "Confirm Mail",
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    hintText: 'Renter Mail Id',
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    if (updateMailController.text == confirmMailController.text &&
                        updateMailController.text.isNotEmpty) {
                      final UserDB = await Hive.openBox<User>("UserDB");
                      User user = widget.user;
                      user.mail = updateMailController.text;
                      await UserDB.put(user.key, user);
                      setState(() {
                        widget.user.mail = updateMailController.text;
                      });
                      Navigator.pop(context);
                      Fluttertoast.showToast(msg: ("Update Successful"));
                    }
                  },
                  child: Text('Update'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

