import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';
import 'package:get/get.dart';

import '../initial/initial_app.dart';
import 'start_exam.dart';

class UpComingExam extends StatelessWidget {
  final InitialApp intApp = Get.find();
  final Key linkKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            'MCQ Exam List',
            style: TextStyle(fontSize: 18.sp),
          ),
          Obx(
            () => IconButton(
              icon: Icon(Icons.refresh),
              onPressed: intApp.eventReload.value
                  ? () {
                      intApp.getEvents();
                    }
                  : null,
            ),
          ),
        ]),
      ),
      backgroundColor: Color(0xff14112e),
      body: Obx(() {
        if (intApp.events.isNotEmpty && intApp.events[0].isNotEmpty) {
          return ListView.builder(
            // reverse: true,
            itemCount: intApp.events.length,
            itemBuilder: (context, index) {
              var exItem = intApp.events[index];
              DateTime cDate = DateTime.now();
              DateTime eStartDate = DateTime.parse(exItem['event_start']);
              DateTime eEndDate = DateTime.parse(exItem['event_end']);
              String btnSt = exItem['event_start'];

              if (cDate.isAfter(eStartDate) && cDate.isBefore(eEndDate)) {
                btnSt = "Start Now";
              }

              if (exItem['event_type'] == 'paid' && exItem['payst'] == false && !cDate.isAfter(eEndDate)) {
                btnSt = "Registration";
              }
              // print(exItem);
              // print(btnSt);
              return Container(
                margin: EdgeInsets.only(left: 20.sp, right: 20.sp, bottom: 10.sp),
                padding: EdgeInsets.all(10.sp),
                decoration: BoxDecoration(
                  color: Color(0xff282449).withOpacity(0.8),
                  border: Border.all(
                    color: Colors.yellow,
                  ),
                  borderRadius: BorderRadius.circular(10.sp),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.yellow,
                  //     blurRadius: 3,
                  //     spreadRadius: 2,
                  //     offset: Offset(3, 2),
                  //   )
                  // ],
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
                            exItem['event_name'],
                            style: TextStyle(
                              color: Color(0xFFCDF009),
                              fontSize: 18.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      exItem['note'] ?? "",
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
                            primary: Colors.transparent,
                          ),
                          onPressed: btnSt == "Start Now"
                              ? () async {
                                  Get.to(
                                    () => StartExam(),
                                    binding: ExamBinding(exam: exItem),
                                    transition: Transition.zoom,
                                  );
                                }
                              : btnSt == "Registration"
                                  ? () {
                                      intApp.regPage(context, exItem);
                                    }
                                  : null,
                          child: Text(
                            btnSt,
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
          return intApp.noEvent.value
              ? Center(
                  child: Card(
                    color: Colors.yellow,
                    child: Padding(
                      padding: EdgeInsets.all(10.sp),
                      child: Text("No Exam"),
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
