import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:sizer/sizer.dart';

import '../initial/app_const.dart';
import '../views/pages/google_add.dart';
import 'login_cont.dart';

class ExamCont extends GetxController {
  final data;
  ExamCont({this.data});

  RxMap fullEvent = {}.obs;
  RxMap startingExam = {}.obs;
  RxInt mcqDuration = 15.obs;
  RxInt startingExamIndex = 0.obs;
  bool closeExam = false;
  String curentAnswer = "no answer";
  int answeredDuration = 0;
  List<dynamic> answerData = [];
  RxInt rightAns = 0.obs;
  RxInt mcqNumber = 1.obs;
  List alfaNumber = ["A", "B", "C"];
  RxBool optAnsChange = true.obs;
  RxList colors = [
    Color(0xff14112e),
    Color(0xff14112e),
    Color(0xff14112e),
  ].obs;

  final player = AudioPlayer();

  @override
  void onInit() {
    super.onInit();
    getEvent();
  }

  void getEvent() async {
    var auth = Get.find<LoginCont>().auth2;
    final Uri url = Uri.parse(AppConst().baseLink + AppConst().event);
    final headers = {
      'Accept': 'application/json',
      "Authorization": "Bearer " + auth[0].toString(),
    };
    Map apiData = {};
    apiData['id'] = data['id'].toString();
    apiData['user_id'] = auth[1]['id'].toString();

    await http.post(url, body: apiData, headers: headers).then((response) {
      if (response.statusCode == 200) {
        var rowData = jsonDecode(response.body);
        if (rowData['data']['mark'] != null) {
          fullEvent.clear();
          fullEvent.addAll(rowData['data']);
          if (fullEvent.isNotEmpty) {
            startExam();
          }
        } else {
          Get.back();
          Get.defaultDialog(
            radius: 10.sp,
            backgroundColor: Color(0xFFF76009),
            title: "Warning!",
            titleStyle: TextStyle(
              color: Colors.white,
            ),
            middleText: "There is not mark setup",
            middleTextStyle: TextStyle(
              color: Colors.white,
            ),
          );
        }
      } else if (response.statusCode == 409) {
        var rowData = jsonDecode(response.body);
        Get.back();
        Get.defaultDialog(
          radius: 10.sp,
          backgroundColor: Color(0xFFF76009),
          title: "Warning!",
          titleStyle: TextStyle(
            color: Colors.white,
          ),
          middleText: rowData['msg'],
          middleTextStyle: TextStyle(
            color: Colors.white,
          ),
        );
        print(rowData);
      } else {
        var rowData = jsonDecode(response.body);
        print(rowData);
      }
    });
  }

  void startExam() {
    player.stop();
    startingExam.addAll(fullEvent['questions'][startingExamIndex.value]);
    mcqDuration.value =
        int.parse(fullEvent['mark']['per_mcq_time_duration'].toString());
    Timer.periodic(Duration(seconds: 1), (timer) async {
      if (closeExam) {
        timer.cancel();
        Get.back();
      } else if (mcqDuration <= 0) {
        timer.cancel();
        naxtMcq();
      } else {
        mcqDuration--;
        player.setAsset("assets/sounds/water.mp3");
        player.play();
      }
    });
  }

  Widget compliteExamDilog() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(),
          borderRadius: BorderRadius.circular(10.sp),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.sp),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40.sp,
                backgroundColor: Colors.green[900],
                child: CircleAvatar(
                  radius: 30.sp,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.done,
                    color: Colors.green[900],
                    size: 40.sp,
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                "Your Exam is Successfully Completed",
                style: TextStyle(
                  fontSize: 15.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void naxtMcq() async {
    var auth = Get.find<LoginCont>().auth2;
    Map curentAns = {};
    curentAns['institution_id'] = auth[1]['institute_id'];
    curentAns['user_id'] = auth[1]['id'].toString();
    curentAns['event_id'] = fullEvent['id'];
    curentAns['duration'] = answeredDuration;
    curentAns['mcq_id'] = startingExam['id'];
    curentAns['mcq_ans'] = curentAnswer;
    if (curentAnswer == startingExam['answer']) {
      curentAns['mcq_st'] = true;
      rightAns.value = rightAns.value + 1;
    } else {
      curentAns['mcq_st'] = false;
    }
    answerData.add(curentAns);
    curentAnswer = "no answer";
    player.setAsset("assets/sounds/ans2.mp3");
    player.play();
    await Future.delayed(Duration(seconds: 3));
    colors[0] = Color(0xff14112e);
    colors[1] = Color(0xff14112e);
    colors[2] = Color(0xff14112e);
    optAnsChange.value = true;
    if ((fullEvent['questions'].length - 1) > startingExamIndex.value) {
      mcqNumber++;
      startingExamIndex.value = startingExamIndex.value + 1;
      startExam();
    } else {
      SmartDialog.show(widget: compliteExamDilog(), backDismiss: false);
      await Future.delayed(Duration(seconds: 3));
      compliteExamAndSetData();
      openingAd();
    }
  }

  void examClose() {
    closeExam = true;
  }

  void answerMCQ(ans, index) async {
    curentAnswer = ans;
    optAnsChange.value = false;
    if (curentAnswer == startingExam['answer']) {
      colors[index] = Color(0xFF1C5F02);
    } else {
      colors[index] = Colors.red;
    }
    answeredDuration = mcqDuration.value;
    mcqDuration.value = 0;
  }

  int a = 0;
  void compliteExamAndSetData() async {
    a++;
    print(a.toString() + " time back");
    // print(answerData);

    var auth = Get.find<LoginCont>().auth2;
    final Uri url = Uri.parse(AppConst().baseLink + AppConst().quizAnswer);
    final headers = {
      'Accept': 'application/json',
      "Authorization": "Bearer " + auth[0].toString(),
    };
    Map fullData = {};
    fullData['data'] = jsonEncode(answerData);
    await http.post(url, body: fullData, headers: headers).then((response) {
      if (response.statusCode == 200) {
        SmartDialog.dismiss().then((value) => Get.back());
      } else {
        var rowData = jsonDecode(response.body);
        print(rowData);
        SmartDialog.dismiss().then((value) => Get.back());
      }
    });
  }
}
