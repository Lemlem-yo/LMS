import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_mezgeb_bet/adminPage/AdminMainPage.dart';
import 'package:firebase_mezgeb_bet/autheticationSetUP/AdminLogInPage.dart';
import 'package:flutter/material.dart';

class AdminMainPageWrapper extends StatelessWidget {
  const AdminMainPageWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          if (snapshot.hasData && snapshot.data!.uid != null) {
            return AdminMainPage();
          } else {
            return AdminLogInPage();
          }
        }
      },
    );
  }
}