import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:sizer/sizer.dart';

import '../../controllers/login_cont.dart';
import '../../initial/app_const.dart';

// ignore: must_be_immutable
class OtpVerify extends StatelessWidget {
  OtpVerify({Key? key, required this.action, required this.pageType, required this.instInfo}) : super(key: key);
  String pageType;
  dynamic instInfo;
  Function() action;
  final LoginCont loginCont = Get.find();
  final length = 4;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: AppConst.backgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              loginCont.otpCoundown.value = 0;
              loginCont.focusNode = FocusNode();
              loginCont.pinCont.text = "";
              Get.back();
            },
            icon: Padding(
              padding: EdgeInsets.all(5.sp),
              child: Icon(
                Icons.arrow_back_ios_new_sharp,
                size: 20,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // title
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 60.sp),
                  child: Container(
                    //width: 50.w,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 10.sp),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1.sp,
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(10.sp),
                    ),
                    child: Text(
                      "Otp Verify".toUpperCase(),
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                // pin field
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.sp),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Pinput(
                    length: length,
                    controller: loginCont.pinCont,
                    focusNode: loginCont.focusNode,
                    defaultPinTheme: loginCont.defaultPinTheme,
                    focusedPinTheme: loginCont.defaultPinTheme.copyWith(
                      height: 68,
                      width: 64,
                      decoration: loginCont.defaultPinTheme.decoration!.copyWith(
                        border: Border.all(color: loginCont.borderColor),
                      ),
                    ),
                    errorPinTheme: loginCont.defaultPinTheme.copyWith(
                      decoration: BoxDecoration(
                        color: loginCont.errorColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                // resend otp
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Obx(
                    () => loginCont.otpCoundown.value <= 0
                        ? TextButton(
                            onPressed: () {
                              loginCont.reSendOtp(pageType, instInfo);
                            },
                            child: Text(
                              "Resend Otp".toUpperCase(),
                              style: TextStyle(
                                color: Color(0xFF07013F),
                              ),
                            ))
                        : Text(
                            "Wait for resend ${loginCont.otpCoundown.value}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF07013F),
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 3.h),
                // send to number
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30.sp),
                  padding: EdgeInsets.symmetric(vertical: 10.sp),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Enter the code sent to ",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        WidgetSpan(
                          child: Icon(
                            Icons.mail_outline,
                            color: Colors.white,
                            size: 12.sp,
                          ),
                        ),
                        TextSpan(
                          text: " +88${loginCont.phoneCont.text}",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // button
                SizedBox(height: 3.h),
                Container(
                  width: 100.w,
                  margin: EdgeInsets.symmetric(horizontal: 50.sp),
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
                    onPressed: action,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 10.sp),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.sp),
                      ),
                    ),
                    child: Text(
                      "verify otp".toUpperCase(),
                      style: TextStyle(
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
