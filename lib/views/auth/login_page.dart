import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../classs/fields.dart';
import '../../controllers/login_cont.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  final LoginCont loginCont = Get.put(LoginCont());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Color(0xD1656074),
        body: SafeArea(
          child: Container(
            height: 100.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.indigo.shade900,
                  Colors.purple.shade100,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 100.h / 20),
                    width: 50.w,
                    child: AvatarGlow(
                      endRadius: 90.0,
                      glowColor: Colors.white,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(5.sp),
                          child: Image.asset(
                            'assets/images/logo.png',
                            height: 9.5.h,
                          ),
                        ),
                        radius: 50.0,
                      ),
                    ),
                  ),
                  // SizedBox(height: 3.h),
                  Container(
                    margin: EdgeInsets.all(10.sp),
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    decoration: BoxDecoration(
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Color(0xDC486B62),
                      //     offset: Offset(5.0, 5.0),
                      //     blurRadius: 10.0,
                      //     spreadRadius: 2.0,
                      //   ), //BoxShadow
                      //   BoxShadow(
                      //     color: Color(0xFFBEA3A3),
                      //     offset: Offset(0.0, 0.0),
                      //     blurRadius: 0.0,
                      //     spreadRadius: 0.0,
                      //   ), //BoxShadow
                      // ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.sp),
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.sp),
                          padding: EdgeInsets.symmetric(vertical: 5.sp),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Sign in".toUpperCase(),
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.sp),
                          padding: EdgeInsets.symmetric(vertical: 5.sp),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Type Your Mobile Number",
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.indigo[900],
                            ),
                          ),
                        ),
                        // Number field
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.sp),
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.sp, vertical: 1.sp),
                          decoration: BoxDecoration(
                            color: Color(0xFFEAEAEA),
                            // border: Border.all(color: Colors.orange),
                            borderRadius: BorderRadius.circular(10.sp),
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Colors.indigo.shade300,
                            //     spreadRadius: 3,
                            //     blurRadius: 3,
                            //     offset: Offset(0, 0),
                            //   ),
                            // ],
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.sp),
                                child: Icon(
                                  Icons.phone,
                                  color: Colors.indigo.shade900,
                                ),
                              ),
                              Text(
                                "+88",
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 13.5.sp,
                                ),
                              ),
                              Expanded(
                                child: InputInConteiner(
                                  cont: loginCont.phoneCont,
                                  keybord: TextInputType.phone,
                                  title: "01XXXXXXXXX",
                                  color: Colors.indigo.shade900,
                                  length: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 3.h),
                        // continue
                        Container(
                          width: 100.w,
                          margin: EdgeInsets.symmetric(horizontal: 20.sp),
                          decoration: BoxDecoration(
                            color: Color(0xFFEAEAEA),
                            // border: Border.all(),
                            borderRadius: BorderRadius.circular(10.sp),
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Colors.indigo.shade300,
                            //     spreadRadius: 2,
                            //     blurRadius: 2,
                            //     offset: Offset(0, 0),
                            //   ),
                            // ],
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green.shade800,
                              // elevation: 5,
                              shadowColor: Colors.blue,
                              padding: EdgeInsets.symmetric(vertical: 10.sp),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.sp),
                              ),
                            ),
                            child: Text(
                              "sign in".toUpperCase(),
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onPressed: () {
                              loginCont.login(context);
                            },
                          ),
                        ),
                        // or
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 3.h),
                          child: Text(
                            "or".toUpperCase(),
                            style: TextStyle(
                              color: Color(0xFF868585),
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                        // Registration
                        Container(
                          width: 100.w,
                          margin: EdgeInsets.symmetric(horizontal: 20.sp),
                          // decoration: BoxDecoration(
                          //   color: Color(0xFFEAEAEA),
                          //   // border: Border.all(),
                          //   borderRadius: BorderRadius.circular(10.sp),
                          //   // boxShadow: [
                          //   //   BoxShadow(
                          //   //     color: Colors.indigo.shade300,
                          //   //     spreadRadius: 2,
                          //   //     blurRadius: 2,
                          //   //     offset: Offset(0, 0),
                          //   //   ),
                          //   // ],
                          // ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFF07013F),
                              shadowColor: Colors.blue,
                              padding: EdgeInsets.symmetric(vertical: 10.sp),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.sp),
                              ),
                            ),
                            child: Text(
                              "REGISTRATION".toUpperCase(),
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onPressed: () => loginCont.searchChange(context),
                            // onPressed: () => Get.to(
                            //   () => FirstOpening(),
                            //   binding: FirstOpeningBinding(),
                            // ),
                            // onPressed: () => customDialog(
                            //   context,
                            //   "Find Institute",
                            //   loginCont.searchInst(),
                            //   "Finding",
                            //   () {
                            //     // print(loginCont.searchtext.text);
                            //     loginCont.searchChange(context);
                            //   },
                            //   () => Get.back(),
                            //   true,
                            // ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
