import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class AppConst {
  String appTitle = "QuizWin";

  // Pakage Name
  final String packAndroid = "com.prostuti.contest";

  // Api
  final String baseLink = "https://quizwin.xyz/api/";

  final String searchInstUri = "institute_search";
  final String districtUri = "districts";
  final String userRegUri = "user_registration";
  final String userRegOtpUri = "check_otp";
  final String userLoginUri = "user_login_institute";
  final String userLoginOtpUri = "user_login_otp";
  final String loginGetDataUri = "user_login";
  final String checkUserStatusUri = "check_user_status";
  final String reSendOtpUri = "resend_otp";

  final String events = "events";
  final String event = "event";
  final String eventResult = "event_result";
  final String eventResultByUser = "event_result_by_user";
  final String eventPayment = "event_payment";
  final String eventPaymentStatus = "event_payment_status";

  final String writtenAllevents = "all_written_events";
  final String writtenQuizAnswer = "written_quiz_answer";

  final String notices = "notices";

  final String profileUpdate = "profile_update";

  final String quizAnswer = "quiz_answer";
  final String institute = "institute";

  ///Color
  static Color backgroundColor = Colors.green.shade900;
  // static Color backgroundColor = Color.fromARGB(255, 255, 254, 255);
  static Color blueMagenta = Colors.orange.shade900.withOpacity(0.8);
  static Color blue = Color(0xFF71AEF3);
  static Color indigo = Color(0xFF215591);
  static Color appbarColor = Colors.black54;

  static Color tabHoverBg = Colors.black;
  static Color tabText = Colors.black;

  var loadInd_1 = LoadingIndicator(
    indicatorType: Indicator.ballScaleMultiple,
    colors: [Colors.white],
    strokeWidth: 2,
    backgroundColor: Colors.black,
    pathBackgroundColor: Colors.black,
  );
}
