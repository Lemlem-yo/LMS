import 'package:firebase_mezgeb_bet/autheticationSetUP/AdminLogInPage.dart';
import 'package:firebase_mezgeb_bet/common/AppColor.dart';
import 'package:firebase_mezgeb_bet/common/Cards.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminMainPage extends StatefulWidget {
  const AdminMainPage({Key? key}) : super(key: key);

  @override
  State<AdminMainPage> createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> {
  int notificationCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 2,
        actions: [

      Container(
      margin: const EdgeInsets.only(right: 10),
      child: Stack(
        children: [
          IconButton(
            icon: const Icon(Icons.notifications),
            color: AppColor.black,
            onPressed: () {},
          ),
          Positioned(
            top:
            12.0, // Adjust this value to position the badge vertically
            right:
            12.0, // Adjust this value to position the badge horizontally
            child: Badge(
              label: Text(
                notificationCount.toString(),
                style: TextStyle(color: Colors.white),
              ),
              child: Container(),
            ),
          ),
        ],
      ),
    ),
        ]
      ),
      drawer: Drawer(
        backgroundColor:  AppColor.white,
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: AppColor.yellow,
              ),
              padding: const EdgeInsets.only(bottom: 0, top: 30),
              child: Column(
                children:  [
                  CircleAvatar(
                    foregroundImage: AssetImage("assets/logo.jpg"),
                    maxRadius: 50,
                  ),
                  Center(
                    child: Text(
                      "Admin Dashboard",
                      style: TextStyle(
                          color: AppColor.black,
                          fontWeight: FontWeight.w800, fontSize: 20),
                    ),
                  )
                ],
              ),
            ),
            Column(
              children:  [
                ListTile(
                  leading: Icon(Icons.file_copy_sharp),
                  title: Text(
                    "Files",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                ListTile(
                  leading: Icon(FontAwesomeIcons.inbox),
                  title: Text(
                    "Incoming letter",
                    style: TextStyle(fontWeight: FontWeight.w700,),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.outbox),
                  title: Text(
                    "Outgoing letter",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.chat),
                  title: Text(
                    "Chat",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text(
                    "Logout",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  onTap: () {
                    _handleLogout(context);
                  },
                ),
              ],
            ),
          ],
        ),
        // Your drawer widget code
      ),
      backgroundColor: AppColor.white,
      body: Column(
        children: [
          Expanded(
            child: Cards(),
          ),
        ],
      ),
    );
  }

  void _handleLogout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminLogInPage()),
      );
    } catch (e) {
      print('Error during logout: $e');
    }
  }

}
