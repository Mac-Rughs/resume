import 'package:flutter/material.dart';
import 'package:resume_parser/database/function.dart';
import 'package:resume_parser/database/model.dart';
import 'login.dart';

class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}
TextEditingController confirmcontroller = TextEditingController();
TextEditingController passwordcontroller = TextEditingController();
TextEditingController usernamecontroller = TextEditingController();
TextEditingController mailcontroller = TextEditingController();
class _signupState extends State<signup> {

  String? passwordError;
  String? confirmError;
  String password = "";
  String confirm = "";

  void validate() {
    setState(() {
      if (passwordcontroller.text == confirmcontroller.text) {
        confirmError = null;
        print("Sucess");
        addUser();
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return login();
        }));
      } else {
        confirmError = "Password Doesnot Match";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.cyan,
          title: const Text("...New Here..."),
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: SafeArea(
              child: Container(
            color: Colors.cyan,
            child: Column(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 300,
                  width: 300,
                ),
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60))),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(right: 60, left: 60, top: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Container(
                          color: Colors.white54,
                          child: TextField(
                            controller: usernamecontroller,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: Colors.cyan), // Outline color
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              labelText: "User Name",
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          color: Colors.white60,
                          child: TextField(
                            controller: mailcontroller,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide:
                                    const BorderSide(color: Colors.cyan),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              labelText: "Officail Mail",
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          color: Colors.white60,
                          child: TextField(
                            controller: passwordcontroller,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: Colors.cyan, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              labelText: "Password",
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          color: Colors.white60,
                          child: TextField(
                            obscureText: true,
                            controller: confirmcontroller,
                            decoration: InputDecoration(
                              errorText: confirmError,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: Colors.cyan, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              labelText: "Confirm Password",
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton(
                            onPressed: () {
                              validate();
                            },
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(color: Colors.cyan),
                            )),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
        ));
  }
}
Future<void> addUser() async
{
  final username = usernamecontroller.text.trim();
  final mail = mailcontroller.text.trim();
  final password = passwordcontroller.text.trim();

  if (username.isEmpty || password.isEmpty)
    {
      return;
    }else
    {
      var data = User(username: username, password: password,mail: mail);
      addUserList(data);
    }
}