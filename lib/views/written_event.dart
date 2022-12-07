import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../controllers/written_event_cont.dart';
import '../initial/app_const.dart';
import 'start_written.dart';

class WrittenEvent extends StatelessWidget {
  WrittenEvent({Key? key}) : super(key: key);
  final WrittenEventCont writtenEventCont = Get.put(WrittenEventCont());

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
            'Written Exam List',
            style: TextStyle(fontSize: 18.sp),
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              writtenEventCont.getUpWrittenEvent();
            },
          ),
        ]),
      ),
      body: Obx(() {
        if (writtenEventCont.allUpWrEvent.isNotEmpty) {
          return ListView.builder(
            itemCount: writtenEventCont.allUpWrEvent.length,
            itemBuilder: (context, index) {
              var wrEvent = writtenEventCont.allUpWrEvent[index];
              DateTime cDate = DateTime.now();
              DateTime eStartDate = DateTime.parse(wrEvent['we_start']);
              DateTime eEndDate = DateTime.parse(wrEvent['we_end']);
              String btnSt = wrEvent['we_start'];

              if (cDate.isAfter(eStartDate) && cDate.isBefore(eEndDate)) {
                btnSt = "Start Now";
              }

              if (wrEvent['we_type'] == 'paid' && !cDate.isAfter(eEndDate)) {
                btnSt = "Registration";
              }

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
                  //     blurRadius: 5,
                  //     spreadRadius: 0.5,
                  //     offset: Offset(0, 0),
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
                            "${wrEvent['written_examination_name']}",
                            style: TextStyle(
                              color: Color(0xFFCDF009),
                              fontSize: 18.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (wrEvent['we_note'] != null) SizedBox(height: 2.h),
                    if (wrEvent['we_note'] != null)
                      Text(
                        wrEvent['we_note'] ?? "",
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
                                    () => StartWritten(),
                                    binding: StartWrittenBinding(currentWrittnExam: wrEvent),
                                    transition: Transition.zoom,
                                  );
                                }
                              : btnSt == "Registration"
                                  ? () {
                                      // intApp.regPage(context, exItem);
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
          return writtenEventCont.noUpWrEvent.value
              ? Center(
                  child: Card(
                    color: Colors.yellow,
                    child: Padding(
                      padding: EdgeInsets.all(10.sp),
                      child: Text("No Written Exam"),
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
