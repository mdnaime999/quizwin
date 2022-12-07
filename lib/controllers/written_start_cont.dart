import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

import '../initial/app_const.dart';
import '../methords/custom_methord.dart';
import 'login_cont.dart';

class WrittenStartCont extends GetxController {
  final currentWrittnExam;
  WrittenStartCont({this.currentWrittnExam});

  // Exam Variable
  RxMap startedExam = {}.obs;
  int startedExamNum = 0;
  RxInt examDuration = 0.obs;
  bool closeExam = false;
  RxBool stopExam = false.obs;
  TextEditingController examResult = TextEditingController();
  int answeredDuration = 0;

  // Qustion Player Settings
  final player = AudioPlayer();
  RxDouble pMin = 0.0.obs;
  RxDouble pMax = 0.0.obs;
  RxDouble pCurent = 0.0.obs;
  Rx buttonStatus = false.obs;

  // Coundown Player Settings
  final player2 = AudioPlayer();

  @override
  void onInit() {
    super.onInit();
    startExam();
  }

  @override
  void onClose() {
    super.onClose();
    player.stop();
  }

  void startExam() async {
    var allMcq = currentWrittnExam['written_examination_questions'];
    if (allMcq.length > 0) {
      if (allMcq.length > startedExamNum) {
        startedExam.clear();
        startedExam.addAll(allMcq[startedExamNum]);
        if (startedExam['full_audio_path'] != null) {
          await player.setUrl(startedExam['full_audio_path']).then((duration) {
            pMax.value = player.duration!.inMilliseconds.round().toDouble();
            if (buttonStatus.value == false) {
              buttonStatus.value = true;
              player.play().then((value) => player.stop().then((value) {
                    buttonStatus.value = false;
                    pCurent.value = 0.0;
                  }));
              player.positionStream.listen((duration) {
                double cDuration = duration.inMilliseconds.round().toDouble();
                if (pMax.value >= cDuration) {
                  pCurent.value = cDuration;
                }
              });
            }
          });
        }
        stopExam.value = false;
        examDuration.value = int.parse(startedExam['weq_duration'].toString());
        examCoundown();
        // print(startedExam);
      } else {
        print("End Exam");
        endExam("End This Exam");
      }
    }
  }

  void nextExam() {
    examResult.clear();
    startedExamNum = startedExamNum + 1;
    examDuration.value = 0;
    startExam();
  }

  void playPaush() async {
    if (pMax.value <= pCurent.value) {
      pCurent.value = 0.0;
    }
    if (buttonStatus.value == true) {
      // buttonStatus.value = false;
      // print(buttonStatus.value);
      player.pause().then((value) => buttonStatus.value = false);
    } else {
      buttonStatus.value = true;
      // print(buttonStatus.value);
      player.play().then((value) => player.stop().then((value) {
            buttonStatus.value = false;
            // pCurent.value = 0.0;
          }));
      player.seek(Duration(milliseconds: pCurent.round()));
    }
  }

  void sliderChanged(sliderValue) {
    player.stop().then((value) async {
      pCurent.value = sliderValue;
      buttonStatus.value = true;
      player.play().then((value) => player.stop().then((value) {
            buttonStatus.value = false;
            pCurent.value = 0.0;
          }));
      await player.seek(Duration(milliseconds: pCurent.round()));
    });
  }

  void examCoundown() {
    // player2.stop();
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (closeExam) {
        timer.cancel();
      } else if (examDuration <= 0) {
        timer.cancel();
        stopExam.value = true;
      } else {
        examDuration--;
        // player2.setAsset("assets/sounds/water.mp3").then((value) => player2.play());
      }
    });
  }

  Widget viewWidget() {
    return Column(
      children: [
        Container(
          width: 100.w,
          padding: EdgeInsets.all(10.sp),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(10.sp),
          ),
          child: Text(
            "Qustion : ${startedExam['written_examination_question_name']}",
            style: TextStyle(
              color: Colors.indigo[900],
              fontWeight: FontWeight.bold,
              fontSize: 15.sp,
            ),
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 10.sp),
          child: Text(
            "Your Answer",
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          width: 100.w,
          height: 20.h,
          padding: EdgeInsets.all(10.sp),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10.sp),
          ),
          child: SingleChildScrollView(
            child: Text(
              examResult.text,
              style: TextStyle(
                fontSize: 12.sp,
              ),
              overflow: TextOverflow.clip,
            ),
          ),
        ),
      ],
    );
  }

  void viewNext(BuildContext context) {
    player.stop();
    answeredDuration = (int.parse(startedExam['weq_duration']) - examDuration.value);
    examDuration.value = 0;
    customDialog(
      context,
      "View your answer",
      viewWidget(),
      "Next Exam",
      () {
        Get.back();
        examPut();
      },
      // () => Get.back(),
      null,
      null,
    );
  }

  void endExam(String msg) {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: Center(
          child: GestureDetector(
            onTap: () async {
              // Get.to(WrittenEvent(), transition: Transition.leftToRight);
              Get.back();
              Get.back();
            },
            child: Container(
              width: 80.w,
              padding: EdgeInsets.all(10.sp),
              decoration: BoxDecoration(
                color: Colors.orange.shade700,
                borderRadius: BorderRadius.circular(10.sp),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    msg.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Click me",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
      barrierColor: Colors.indigo.shade900.withOpacity(0.8),
    );
  }

  void examPut() async {
    var auth = Get.find<LoginCont>().auth2;
    Map curentAns = {};
    curentAns['institution_id'] = auth[1]['institute_id'].toString();
    curentAns['user_id'] = auth[1]['id'].toString();
    curentAns['event_id'] = startedExam['id'].toString();
    curentAns['duration'] = answeredDuration.toString();
    curentAns['mcq_ans'] = examResult.text;
    final Uri url = Uri.parse(AppConst().baseLink + AppConst().writtenQuizAnswer);
    final headers = {
      'Accept': 'application/json',
      "Authorization": "Bearer " + auth[0].toString(),
    };
    Map fullData = {};
    fullData['data'] = jsonEncode(curentAns);
    print(fullData);
    await http.post(url, body: fullData, headers: headers).then((response) {
      if (response.statusCode == 200) {
        nextExam();
      } else {
        var rowData = jsonDecode(response.body);
        print(rowData);
      }
    });
  }
}
