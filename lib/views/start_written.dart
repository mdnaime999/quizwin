import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../classs/fields.dart';
import '../controllers/written_start_cont.dart';
import '../initial/app_const.dart';

class StartWritten extends StatelessWidget {
  final WrittenStartCont wrStartCont = Get.find();

  @override
  Widget build(BuildContext context) {
    final defaultText = TextStyle(color: Colors.white, fontSize: 15.sp);
    return Scaffold(
      backgroundColor: AppConst.backgroundColor,
      body: Column(
        children: [
          SizedBox(height: 3.h),
          Container(
            width: 100.w,
            padding: EdgeInsets.all(10.sp),
            alignment: Alignment.center,
            child: Text(wrStartCont.currentWrittnExam['written_examination_name'], style: defaultText),
          ),
          Expanded(
            child: Obx(() {
              // print(wrStartCont.pMin.toString() + "-" + wrStartCont.pMax.toString() + "-" + wrStartCont.pCurent.toString());
              if (wrStartCont.startedExam.isNotEmpty) {
                return SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      if (wrStartCont.startedExam['full_audio_path'] != null)
                        Container(
                          width: 100.w,
                          margin: EdgeInsets.all(10.sp),
                          padding: EdgeInsets.all(10.sp),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(10.sp),
                          ),
                          child: Row(
                            children: [
                              InkWell(
                                child: CircleAvatar(
                                  radius: 16.sp,
                                  child: Icon(
                                    wrStartCont.buttonStatus.value == true ? Icons.pause_circle : Icons.play_circle,
                                    color: Colors.white,
                                    size: 30.sp,
                                  ),
                                ),
                                onTap: () {
                                  wrStartCont.playPaush();
                                },
                              ),
                              Expanded(
                                child: Slider(
                                  min: wrStartCont.pMin.value,
                                  max: wrStartCont.pMax.value,
                                  value: wrStartCont.pCurent.value,
                                  onChanged: (cvalue) {
                                    wrStartCont.sliderChanged(cvalue);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      // LinearProgressIndicator(
                      //   minHeight: 10.h,
                      //   value: 0.6,
                      //   semanticsLabel: '40%',
                      //   semanticsValue: '60%',
                      // ),
                      Container(
                        width: 100.w,
                        margin: EdgeInsets.all(10.sp),
                        padding: EdgeInsets.all(10.sp),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(10.sp),
                        ),
                        child: Text(
                          wrStartCont.startedExam['written_examination_question_name'],
                          style: defaultText,
                        ),
                      ),
                      Container(
                        width: 100.w,
                        margin: EdgeInsets.all(10.sp),
                        padding: EdgeInsets.all(10.sp),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Color(0x7F2D2669),
                          // border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(10.sp),
                        ),
                        // child: Text(
                        //   "Duration : ${wrStartCont.startedExam['weq_duration']} sec / Left : ${wrStartCont.examDuration.value} sec",
                        //   style: defaultText,
                        // ),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Time : ${wrStartCont.startedExam['weq_duration']} sec",
                                style: TextStyle(color: Colors.green, fontSize: 17.sp),
                              ),
                              TextSpan(
                                text: " / ",
                                style: TextStyle(color: Colors.amber, fontSize: 17.sp),
                              ),
                              TextSpan(
                                text: "Left : ${wrStartCont.examDuration.value} sec",
                                style: TextStyle(color: Colors.red, fontSize: 17.sp),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.sp),
                        decoration: BoxDecoration(
                          color: wrStartCont.stopExam.value == false ? Colors.transparent : Colors.grey.withOpacity(0.2),
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(10.sp),
                        ),
                        child: InputTextField(
                          cont: wrStartCont.examResult,
                          fieldtext: "Type your answer",
                          fieldTextStyle: TextStyle(color: Colors.grey),
                          textStyle: TextStyle(color: Colors.white),
                          multi: true,
                          multiLine: 18,
                          control: false,
                          backColor: Colors.transparent,
                          readOnly: wrStartCont.stopExam.value,
                        ),
                      ),
                      Container(
                        width: 100.w,
                        margin: EdgeInsets.all(10.sp),
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 30.sp,
                              vertical: 10.sp,
                            ),
                            primary: Colors.blue[900],
                            onPrimary: Colors.white,
                            onSurface: Colors.grey,
                            textStyle: TextStyle(
                              fontSize: 15.sp,
                            ),
                          ),
                          child: Text("View & Next"),
                          onPressed: wrStartCont.examResult.text != ""
                              ? () {
                                  wrStartCont.viewNext(context);
                                }
                              : null,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
          ),
        ],
      ),
    );
  }
}

class StartWrittenBinding implements Bindings {
  StartWrittenBinding({this.currentWrittnExam});
  final currentWrittnExam;
  @override
  void dependencies() {
    Get.lazyPut<WrittenStartCont>(() => WrittenStartCont(currentWrittnExam: currentWrittnExam));
  }
}
