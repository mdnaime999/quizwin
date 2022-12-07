import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart';

import '../../initial/app_const.dart';
import '../../initial/initial_app.dart';
import '../start_exam.dart';

class ContestPage extends StatelessWidget {
  ContestPage({Key? key}) : super(key: key);
  final InitialApp intApp = Get.find();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (intApp.events.isNotEmpty && intApp.events[0].isNotEmpty) {
        return RefreshIndicator(
          onRefresh: () => intApp.getEvents(),
          backgroundColor: Color(0x05000000),
          color: AppConst.tabText,
          child: ListView.builder(
            // reverse: true,
            padding: EdgeInsets.symmetric(vertical: 20.sp, horizontal: 10.sp),
            itemCount: intApp.events.length,
            itemBuilder: (context, index) {
              var exItem = intApp.events[index];
              DateTime cDate = DateTime.now();
              DateTime eStartDate = DateTime.parse(exItem['event_start']);
              DateTime eEndDate = DateTime.parse(exItem['event_end']);
              var upComming = DateFormat('dd MMM, hh:mm a').format(eStartDate);
              String btnSt = upComming;

              if (cDate.isAfter(eStartDate) && cDate.isBefore(eEndDate)) {
                btnSt = "Start Now";
              }

              // if (Get.find<LoginCont>().auth2[1]['school_name'] == null ||
              //     Get.find<LoginCont>().auth2[1]['registration_no'] == null ||
              //     Get.find<LoginCont>().auth2[1]['registration_card_photo_path'] == null) {
              //   btnSt = "Update Profile";
              // }

              if (exItem['event_type'] == 'paid' &&
                  exItem['payst'] == false &&
                  !cDate.isAfter(eEndDate)) {
                btnSt = "Registration";
              }
              // print(exItem);
              // print(btnSt);
              return Container(
                margin: EdgeInsets.only(bottom: 10.sp),
                padding: EdgeInsets.all(10.sp),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.white30,
                  ),
                  borderRadius: BorderRadius.circular(5.sp),
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
                          height: 4.5.h,
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
                              color: Colors.black,
                              fontSize: 15.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    ReadMoreText(
                      exItem['note'] ?? "",
                      trimLines: 4,
                      colorClickableText: Colors.blue,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: ' Show more',
                      trimExpandedText: ' Show less',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10.sp,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                          ),
                          onPressed: btnSt == "Start Now"
                              ? () {
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
                          // onPressed: btnSt == "Update Profile"
                          //     ? () {
                          //         Get.to(Profile());
                          //       }
                          //     : btnSt == "Start Now"
                          //         ? () {
                          //             Get.to(
                          //               () => StartExam(),
                          //               binding: ExamBinding(exam: exItem),
                          //               transition: Transition.zoom,
                          //             );
                          //           }
                          //         : btnSt == "Registration"
                          //             ? () {
                          //                 intApp.regPage(context, exItem);
                          //               }
                          //             : null,
                          child: Text(
                            btnSt,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      } else {
        return intApp.noEvent.value
            ? Center(
                child: Card(
                  color: Colors.white70,
                  child: Padding(
                    padding: EdgeInsets.all(10.sp),
                    child: SizedBox(
                      width: 100.w,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("No Contest"),
                          SizedBox(height: 2.h),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.orange,
                            ),
                            onPressed: () => intApp.getEvents(),
                            icon: Icon(Icons.refresh),
                            label: Text("Refresh"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      }
    });
  }
}
