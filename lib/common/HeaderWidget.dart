import 'package:firebase_mezgeb_bet/common/AppColor.dart';
import 'package:flutter/material.dart';


class HeaderPage extends StatelessWidget {
  const HeaderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: AppColor.yellow,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            )),
        child: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(onPressed: (){}, icon: Icon(Icons.person),),
                          SizedBox(width: 5.0,),
                          Text("New User Registered", style: TextStyle(color: AppColor.black, fontWeight: FontWeight.bold),)
                        ],
                      )
                    ],
                  ),
                  Text(
                      "4 new persons"
                  )
                ],
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(onPressed: (){}, icon: Icon(Icons.calendar_month),),
                          SizedBox(width: 5.0,),
                          Text("New User Registered", style: TextStyle(color: AppColor.black, fontWeight: FontWeight.bold),)
                        ],
                      )
                    ],
                  ),
                  Text(
                      "5 appointment"
                  )
                ],
              ),
            ],
          ),

        )

    );
  }
}
