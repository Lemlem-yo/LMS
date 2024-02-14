import 'package:firebase_mezgeb_bet/adminPage/AdminMainPage.dart';
import 'package:firebase_mezgeb_bet/common/AppColor.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';


class AdminLogInPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.yellow,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 100),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("LogIn", style: TextStyle(color: Colors.black, fontSize: 40)),
                    Text("Welcome to this page", style: TextStyle(color: Colors.black, fontSize: 18)),
                  ],
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        SizedBox(height: 100),
                        TextField(
                          controller: usernameController,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            // Validate and handle login logic
                            login(context);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: AppColor.yellow,
                            minimumSize: Size(double.infinity, 50),
                          ),
                          child: Text('Login', style: TextStyle(color: Colors.black, fontSize: 18)),
                        ),
                        SizedBox(height: 20),
                        Spacer(),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 10, bottom: 10),
                            child: Text(
                              'Copyright © 2016 E.C',
                              style: TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> login(BuildContext context) async {
    String username = usernameController.text;
    String password = passwordController.text;

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: username,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Check user's role and redirect accordingly
        Map<String, dynamic>? userClaims = (await user.getIdTokenResult()).claims;

        if (userClaims!.containsKey('admin') && userClaims['admin'] == true) {
          // Admin user
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminMainPage()),
          );
        } else {
          // Non-admin user
          // Handle redirection or show appropriate message
        }
      } else {
        // Authentication failed
        _showErrorDialog(context, 'Invalid username or password. Please try again.');
      }
    } catch (e) {
      // Handle authentication errors
      print('Error signing in: $e');
      _showErrorDialog(context, 'An error occurred. Please try again later.');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login Failed'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
