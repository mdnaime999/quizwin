import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../classs/fields.dart';
import '../controllers/login_cont.dart';
import '../initial/app_const.dart';

class FirstOpening extends StatelessWidget {
  FirstOpening({Key? key}) : super(key: key);
  final LoginCont loginCont = Get.find();
  final FirstOpenCont firstOpenCont = Get.find();

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
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80.w,
                padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 10.sp),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(10.sp),
                ),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Welcome to ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                        ),
                      ),
                      WidgetSpan(
                        child: Image(
                          image: AssetImage("assets/images/logo.png"),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                width: 80.w,
                // margin: EdgeInsets.symmetric(horizontal: 30.sp),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(
                  color: Color(0xFFEAEAEA),
                  // border: Border.all(),
                  borderRadius: BorderRadius.circular(10.sp),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.indigo.shade600,
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: InputInConteiner(
                  cont: loginCont.searchtext,
                  icon: Icons.search,
                  title: "Search Name / Code",
                  color: Colors.indigo.shade900,
                  focus: true,
                ),
              ),
              SizedBox(height: 3.h),
              Container(
                width: 80.w,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Color(0xFFEAEAEA),
                  // border: Border.all(),
                  borderRadius: BorderRadius.circular(10.sp),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.indigo.shade600,
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(10.sp),
                      backgroundColor: Colors.indigo[800],
                      textStyle: TextStyle(
                        fontSize: 15.sp,
                      )),
                  child: Text("Find Institute"),
                  onPressed: () {
                    loginCont.searchChange(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FirstOpeningBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FirstOpenCont>(() => FirstOpenCont());
  }
}

class FirstOpenCont extends GetxController {
  @override
  void onInit() {
    super.onInit();
    FlutterNativeSplash.remove();
  }
}
