import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../controllers/written_expried_cont.dart';
import '../initial/app_const.dart';

class WrittenExpried extends StatelessWidget {
  WrittenExpried({Key? key}) : super(key: key);
  final WrittenExpriedCont writtenExpriedCont = Get.put(WrittenExpriedCont());
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
              child: Icon(Icons.arrow_back_ios_new_sharp),
            ),
          ),
          Text(
            'Written Expried Event',
            style: TextStyle(fontSize: 18.sp),
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => writtenExpriedCont.getExpWrittenEvent(),
          ),
        ]),
      ),
      body: Obx(() {
        if (writtenExpriedCont.allExpWrEvent.isNotEmpty) {
          return ListView.builder(
            // reverse: true,
            physics: BouncingScrollPhysics(),
            itemCount: writtenExpriedCont.allExpWrEvent.length,
            itemBuilder: (context, index) {
              var exWrittenItem = writtenExpriedCont.allExpWrEvent[index];
              DateTime cDate = DateTime.now();
              DateTime eEndDate = DateTime.parse(exWrittenItem['we_end']);
              var duTimeH = cDate.difference(eEndDate).inHours;
              return Container(
                margin: EdgeInsets.only(left: 20.sp, right: 20.sp, bottom: 10.sp),
                padding: EdgeInsets.all(10.sp),
                decoration: BoxDecoration(
                  color: Color(0xff282449).withOpacity(0.8),
                  border: Border.all(
                    color: Colors.yellow,
                  ),
                  borderRadius: BorderRadius.circular(10.sp),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: 5.h,
                          child: Image.asset(
                            'assets/images/exam_icon.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(
                          width: 3.w,
                        ),
                        Flexible(
                          child: Text(
                            exWrittenItem['written_examination_name'],
                            style: TextStyle(
                              color: Color(0xFFCDF009),
                              fontSize: 18.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (exWrittenItem['we_note'] != null) SizedBox(height: 2.h),
                    if (exWrittenItem['we_note'] != null)
                      Text(
                        exWrittenItem['we_note'] ?? "",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                        ),
                        maxLines: 3,
                      ),
                    SizedBox(height: 1.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                          ),
                          onPressed: null,
                          child: Text(
                            "End $duTimeH hours ago",
                            style: TextStyle(
                              color: Colors.yellow,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          return writtenExpriedCont.noExpWrEvent.value
              ? Center(
                  child: Card(
                    color: Colors.yellow,
                    child: Padding(
                      padding: EdgeInsets.all(10.sp),
                      child: Text("No Expired Written"),
                    ),
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(),
                );
        }
      }),
    );
  }
}
