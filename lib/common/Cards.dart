import 'package:firebase_mezgeb_bet/adminPage/LetterManagementPage.dart';
import 'package:firebase_mezgeb_bet/common/AppColor.dart';
import 'package:firebase_mezgeb_bet/common/CalenderWidget.dart';
import 'package:firebase_mezgeb_bet/common/HeaderWidget.dart';
import 'package:flutter/material.dart';


class Cards extends StatelessWidget {
  const Cards({super.key});

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),

            child: Center(
              child: Wrap(
                spacing: 20.0,
                runSpacing: 20.0,
                children: [
                  HeaderPage(),
                  CalendarWidget(),
                  InkWell(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  LetterManagementPage(),));
                    },
                    child: SizedBox(
                      width: 160.0,
                      height: 160.0,
                      child: Card(
                        color: AppColor.yellow,
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)
                        ),
                        child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons
                                        .mail_lock, // Replace with your desired icon
                                    size: 50,
                                    color: AppColor.bgSideMenu,
                                  ),
                                  // Image.asset("assets/graduates.png", width: 64,),
                                  SizedBox(height: 10.0,),
                                  Text("Incoming letter",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0
                                      )),
                                  SizedBox(height: 5.0,),
                                  Text("2 Items",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w100
                                    ),)
                                ],
                              ),
                            )
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      //Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  OutgoingLetter(),));
                    },
                    child: SizedBox(
                      width: 160.0,
                      height: 160.0,
                      child: Card(
                        color: AppColor.yellow,
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)
                        ),
                        child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.send, // Replace with your desired icon
                                    size: 50,
                                    color: AppColor.bgSideMenu,
                                  ),
                                  //Image.asset("assets/graduates.png", width: 64,),
                                  SizedBox(height: 10.0,),
                                  Text("Outgoing letter",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0
                                      )),
                                  SizedBox(height: 5.0,),
                                  Text("2 Items",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w100
                                    ),)
                                ],
                              ),
                            )
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 160.0,
                    height: 160.0,
                    child: Card(
                      color: AppColor.yellow,
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)
                      ),
                      child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.folder, // Replace with your desired icon
                                  size: 50,
                                  color: AppColor.bgSideMenu,
                                ),
                                //Image.asset("assets/graduates.png", width: 64,),
                                SizedBox(height: 10.0,),
                                Text("Internal files",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0
                                    )),
                                SizedBox(height: 5.0,),
                                Text("2 Items",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w100
                                  ),)
                              ],
                            ),
                          )
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 160.0,
                    height: 160.0,
                    child: Card(
                      color: AppColor.yellow,
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)
                      ),
                      child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.chat,
                                  size: 50,
                                  color: AppColor.black,
                                ),
                                //Image.asset("assets/graduates.png", width: 64,),
                                SizedBox(height: 10.0,),
                                Text("Chat",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0
                                    )),
                                SizedBox(height: 5.0,),
                                Text("2 Items",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w100
                                  ),)
                              ],
                            ),
                          )
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}