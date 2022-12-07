import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../controllers/expired_cont.dart';
import '../../initial/app_const.dart';
import '../pages/google_add.dart';
import '../start_exam.dart';

class ExpiredPage extends StatelessWidget {
  ExpiredPage({Key? key}) : super(key: key);
  final ExpiredCont expiredCont = Get.put(ExpiredCont());
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Obx(() {
            if (expiredCont.expiredevent.isNotEmpty && expiredCont.expiredevent[0].isNotEmpty) {
              return RefreshIndicator(
                onRefresh: () => expiredCont.getEvents(),
                backgroundColor: Color(0x05000000),
                color: AppConst.tabText,
                child: ListView.builder(
                  // reverse: true,
                  padding: EdgeInsets.symmetric(vertical: 20.sp, horizontal: 10.sp),
                  itemCount: expiredCont.expiredevent.length,
                  itemBuilder: (context, index) {
                    var exItem = expiredCont.expiredevent[index];
                    DateTime cDate = DateTime.now();
                    // DateTime eStartDate = DateTime.parse(exItem['event_start']);
                    DateTime eEndDate = DateTime.parse(exItem['event_end']);
                    String btnSt = exItem['event_start'];

                    // if (cDate.isAfter(eStartDate) && cDate.isBefore(eEndDate)) {
                    //   btnSt = "Start";
                    // } else if (cDate.isAfter(eEndDate)) {
                    //   btnSt = "End Exam";
                    // }
                    if (cDate.isAfter(eEndDate)) {
                      btnSt = "Expired";
                    }

                    return Container(
                      margin: EdgeInsets.only(bottom: 10.sp),
                      padding: EdgeInsets.all(10.sp),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.white,
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
                                    color: Colors.black,
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
                              color: Colors.black,
                              fontSize: 10.sp,
                            ),
                            maxLines: 3,
                          ),
                          SizedBox(height: 1.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // if (exItem['event_type'] != 'free')
                              //   ElevatedButton(
                              //     style: ElevatedButton.styleFrom(
                              //       primary: Colors.transparent,
                              //     ),
                              //     onPressed: () {},
                              //     child: Text(
                              //       "Registration Now",
                              //       style: TextStyle(
                              //         color: Colors.yellow,
                              //       ),
                              //     ),
                              //   ),
                              // SizedBox(width: 2.w),

                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                ),
                                onPressed: btnSt == "Start"
                                    ? () {
                                        Get.to(
                                          () => StartExam(),
                                          binding: ExamBinding(exam: exItem),
                                          transition: Transition.zoom,
                                        );
                                      }
                                    : null,
                                child: Text(
                                  btnSt,
                                  style: TextStyle(
                                    color: Colors.grey,
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
              return expiredCont.noExpiredEvent.value
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
                                Text("No Expried Contest"),
                                SizedBox(height: 2.h),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                  ),
                                  onPressed: () => expiredCont.getEvents(),
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
          }),
        ),
        BannerAdmob(),
      ],
    );
  }
}
