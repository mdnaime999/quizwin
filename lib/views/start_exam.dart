import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../controllers/exam_cont.dart';
import '../initial/initial_app.dart';
import '../methords/custom_methord.dart';

class StartExam extends StatelessWidget {
  final ExamCont examCont = Get.find();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Color(0xff14112e),
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            ClipPath(
              clipper: DiagonalPathClipperTwo(),
              child: Container(
                height: 100.h / 4,
                color: Color(0x52322D3D),
              ),
            ),
            // Button Section
            Container(
              margin: EdgeInsets.only(top: 3.h),
              child: ListTile(
                trailing: TextButton(
                  child: Text("Close"),
                  onPressed: () {
                    Widget closeMsg = Text("Are you sure exit exam");
                    customDialog(
                      context,
                      "Notification",
                      closeMsg,
                      "Exit",
                      () {
                        Get.back();
                        examCont.examClose();
                      },
                      () => Get.back(),
                      true,
                    );
                  },
                ),
              ),
            ),
            // Coundown
            Positioned(
              top: 100.h / 4 - 25.w,
              left: 100.w / 2 - 30.w / 2,
              child: Align(
                child: Obx(() => examCont.startingExam.isNotEmpty
                    ? SizedBox(
                        width: 30.w,
                        height: 30.w,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CircleAvatar(
                              backgroundColor: Color(0xff14112e),
                              child: Text(
                                examCont.mcqDuration.value.toString(),
                                style: TextStyle(
                                  fontSize: 30.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            CircularProgressIndicator(
                              value: examCont.mcqDuration.value / int.parse(examCont.fullEvent['mark']['per_mcq_time_duration'].toString()),
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                              strokeWidth: 8.sp,
                              backgroundColor: Colors.red,
                            ),
                          ],
                        ),
                      )
                    : SizedBox(
                        width: 30.w,
                        height: 30.w,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                              strokeWidth: 8.sp,
                              backgroundColor: Colors.red,
                            ),
                            Center(
                              child: Text(
                                "Starting",
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      )),
              ),
            ),
            // Right ans count
            Positioned(
              top: 100.h / 4,
              left: 100.w / 10,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 5.sp),
                width: 20.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.green.withOpacity(0.4),
                    width: 1.sp,
                  ),
                  borderRadius: BorderRadius.circular(10.sp),
                ),
                child: Obx(() => examCont.fullEvent.isNotEmpty
                    ? Text(
                        "${examCont.rightAns}",
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12.sp,
                        ),
                      )
                    : Text(
                        "0",
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12.sp,
                        ),
                      )),
              ),
            ),
            // Quntity count
            Positioned(
              top: 100.h / 4,
              right: 100.w / 10,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 5.sp),
                width: 20.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.yellow.withOpacity(0.4),
                    width: 1.sp,
                  ),
                  borderRadius: BorderRadius.circular(10.sp),
                ),
                child: Obx(() => examCont.fullEvent.isNotEmpty
                    ? Text(
                        "${(examCont.mcqNumber).toString()} of ${(examCont.fullEvent['questions'].length).toString()}",
                        style: TextStyle(
                          color: Colors.yellow,
                          fontSize: 12.sp,
                        ),
                      )
                    : Text(
                        "0 of 0",
                        style: TextStyle(
                          color: Colors.yellow,
                          fontSize: 12.sp,
                        ),
                      )),
              ),
            ),
            // Question and Answer
            Container(
              width: 100.w,
              margin: EdgeInsets.only(top: 100.h / 3),
              padding: EdgeInsets.all(10.sp),
              child: Card(
                shadowColor: Color(0xFF6D6D6D),
                elevation: 5,
                color: Colors.white,
                // shape: RoundedRectangleBorder(
                //   side: BorderSide(color: Colors.yellow, width: 1.sp),
                //   borderRadius: BorderRadius.circular(10.sp),
                // ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(
                      () => examCont.startingExam.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 20.sp),
                              child: Text(
                                examCont.startingExam['question'],
                                style: TextStyle(
                                  color: Color(0xff14112e),
                                  fontSize: 14.sp,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : SizedBox(
                              height: 30.h,
                              width: 100.w,
                              child: Center(child: CircularProgressIndicator()),
                            ),
                    ),
                    // Divider(
                    //   thickness: 1.sp,
                    //   color: Colors.indigo[300],
                    // ),
                    Obx(() {
                      return examCont.startingExam.isNotEmpty
                          ? Container(
                              padding: EdgeInsets.symmetric(vertical: 10.sp),
                              height: 40.h,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  option(0, 'option_one'),
                                  option(1, 'option_two'),
                                  option(2, 'option_three'),
                                ],
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.all(20),
                              child: SizedBox(
                                height: 20.h,
                                width: 100.w,
                                child: Center(child: CircularProgressIndicator()),
                              ),
                            );
                    })
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget option(index, itemKey) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.sp),
      child: GestureDetector(
        onTap: examCont.optAnsChange.value
            ? () {
                examCont.answerMCQ(examCont.startingExam['options'][itemKey], index);
              }
            : null,
        child: Card(
          color: examCont.colors[index],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.sp),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 10.sp,
              child: Text(
                examCont.alfaNumber[index],
                style: TextStyle(
                  color: Color(0xff14112e),
                ),
              ),
            ),
            title: Text(
              examCont.startingExam['options'][itemKey],
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
              ),
            ),
            // trailing: Icon(examCont.rightAns.value == index ? Icons.check : Icons.close),
          ),
        ),
      ),
    );
  }
}

class ExamBinding implements Bindings {
  ExamBinding({this.exam});
  final exam;
  @override
  void dependencies() {
    Get.lazyPut<InitialApp>(() => InitialApp());
    Get.lazyPut<ExamCont>(() => ExamCont(data: exam));
  }
}
