import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../initial/app_const.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConst.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
            "Notification",
            style: GoogleFonts.alata(
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          )
        ]),
      ),
      body: Column(
        children: [
          SizedBox(height: 2.8.h),
          Expanded(
            child: Container(
              width: 100.w,
              margin: EdgeInsets.all(10.sp),
              child: Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.sp),
                ),
                // child: ListTile(
                //   title: Text("notification"),
                //   subtitle: Text("This Is frist notification"),
                // ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
