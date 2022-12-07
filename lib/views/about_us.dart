import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../initial/app_const.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConst.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
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
        title: Text(
          'About Competition SSC Contest',
          style: TextStyle(fontSize: 14.sp),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 2.8.h),
          Expanded(
            child: Container(
              width: 100.w,
              margin: EdgeInsets.all(10.sp),
              child: Card(
                color: Colors.white,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.sp),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                      "The objective of the quiz contest is to promote learning of SSC or equivalent   level students all over the country.  The mobile application based automated live exam process will encourage students to acquire more knowledge for upgrading themselves. The user friendly and cost effective scheme will also enable students to become more confident in different competitive exams in upcoming days.\nThe title sponsor of  the smart and knowledge disseminating program for this season is one of a renowned educational institute  'Cambrian College'.\nMoreover, another core objective of the competition is to explore brilliant students as well as promoting them with free or discounted education cost.",
                      style: TextStyle(
                        fontSize: 11.sp,
                        letterSpacing: 1.0,
                      ),
                      textAlign: TextAlign.justify),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
