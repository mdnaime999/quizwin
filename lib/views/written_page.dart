import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../controllers/written_cont.dart';
import '../initial/app_const.dart';
import 'written_event.dart';
import 'written_expried.dart';
import 'written_result.dart';

class WrittenExam extends StatelessWidget {
  WrittenExam({Key? key}) : super(key: key);
  final WrittenCont writtenCont = Get.put(WrittenCont());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConst.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          IconButton(
            onPressed: () {
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
          Text(
            'Written Exam',
            style: TextStyle(fontSize: 18.sp),
          ),
          SizedBox().marginZero,
        ]),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 2.h),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100.w,
                margin: EdgeInsets.symmetric(horizontal: 15.sp),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.yellow,
                  ),
                  borderRadius: BorderRadius.circular(10.sp),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 20.sp),
                  onTap: () => Get.to(WrittenEvent(), transition: Transition.rightToLeft),
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      writtenCont.lathi,
                      SizedBox(width: 3.w),
                      writtenCont.lathi,
                    ],
                  ),
                  title: Text(
                    "Written Exam List",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Container(
                width: 100.w,
                margin: EdgeInsets.symmetric(horizontal: 15.sp),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.yellow,
                  ),
                  borderRadius: BorderRadius.circular(10.sp),
                ),
                child: ListTile(
                  onTap: () {
                    Get.to(WrittenExpried(), transition: Transition.rightToLeft);
                  },
                  contentPadding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 20.sp),
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      writtenCont.lathi,
                      SizedBox(width: 3.w),
                      writtenCont.lathi,
                    ],
                  ),
                  title: Text(
                    "Expried Written Exam",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Container(
                width: 100.w,
                margin: EdgeInsets.symmetric(horizontal: 15.sp),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.yellow,
                  ),
                  borderRadius: BorderRadius.circular(10.sp),
                ),
                child: ListTile(
                  onTap: () {
                    Get.to(
                      WrittenResult(),
                      transition: Transition.rightToLeft,
                    );
                  },
                  contentPadding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 20.sp),
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      writtenCont.lathi,
                      SizedBox(width: 3.w),
                      writtenCont.lathi,
                    ],
                  ),
                  title: Text(
                    "Written Exam Result",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
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
}
