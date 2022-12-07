import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shurjopay_sdk/shurjopay_sdk.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

import '../classs/fields.dart';
import '../controllers/login_cont.dart';
import '../methords/custom_methord.dart';
import '../views/auth/login_page.dart';
import '../views/home_page.dart';
import 'app_const.dart';

class InitialApp extends GetxController with GetSingleTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    Tab(
      child: Text("Contest"),
    ),
    Tab(
      child: Text("Result"),
    ),
    Tab(
      child: Text("Notice"),
    ),
    Tab(
      child: Text("Expired"),
    ),
  ];
  TabController? tabController;

  Box authdb = Hive.box('auth');
  RxList events = [].obs;
  RxBool noEvent = false.obs;
  RxBool eventReload = true.obs;
  RxMap<dynamic, dynamic> instInfo = {}.obs;

  RefreshController refController = RefreshController(initialRefresh: false);

  final List<String> examList = [
    'MCQ Exam',
    'Expired Exam',
    'Written Exam',
    'Practice',
    'Notice',
    'Result',
  ];
  final List<String> imageList = [
    'assets/images/upcoming.png',
    'assets/images/icon2.png',
    'assets/images/icon3.png',
    'assets/images/icons16.png',
    'assets/images/notice.png',
    'assets/images/result.png',
  ];
  final List<String> profileImageList = [
    'assets/images/message.jpg',
    'assets/images/privacy.png',
    'assets/images/rules.png',
    'assets/images/share.png',
  ];
  final List<String> profileItemList = [
    'Message',
    'Privacy',
    'Rating',
    'Share',
  ];

  final List<Color> iconColor = [
    Color.fromARGB(255, 35, 102, 218),
    Colors.deepOrange,
    Colors.green,
    Colors.red,
  ];

  // controller for payment
  TextEditingController payName = TextEditingController();
  TextEditingController payPhone = TextEditingController();
  TextEditingController payEmail = TextEditingController();
  // TextEditingController payAddress = TextEditingController();
  // TextEditingController payCity = TextEditingController();

  late ShurjopaySdk shurjopaySdk;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(vsync: this, length: myTabs.length);
    splashScreen();
  }

  // @override
  // void onClose() {
  //   instInfo.clear();
  //   events.clear();
  //   super.onClose();
  // }

  infoupdata() {
    // instInfo.value['institution_name'] = "gjhdsgfg";
    update();
  }

  void splashScreen() async {
    await Future.delayed(Duration(seconds: 1));
    print('Home is ready.....');
    // print(authdb.toMap());
    instituteInfo();
    FlutterNativeSplash.remove();
    // openingAd();
  }

  void statusDilog(String msg) {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: Center(
          child: GestureDetector(
            onTap: () async {
              // Get.back();
              checkUserStatus();
            },
            child: Container(
              width: 80.w,
              height: 10.h,
              decoration: BoxDecoration(
                color: Colors.orange.shade700,
                borderRadius: BorderRadius.circular(10.sp),
              ),
              child: Center(
                child: Text(
                  msg.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
      barrierColor: Colors.indigo.shade900.withOpacity(0.8),
    );
  }

  void userStatus() {
    if (authdb.get(2) == 0 && int.parse(authdb.get(1)['user_status']) != 1) {
      statusDilog("Your Account \nPending...");
    } else {
      Get.to(() => HomePage());
    }
  }

  void checkUserStatus() async {
    final Uri url = Uri.parse(AppConst().baseLink + AppConst().checkUserStatusUri);
    final headers = {
      'Accept': 'application/json',
      "Authorization": "Bearer " + authdb.get(0).toString(),
    };
    Map data = {};
    await http.post(url, body: data, headers: headers).then((response) {
      if (response.statusCode == 200) {
        var rowData = jsonDecode(response.body);
        print(rowData);
        authdb.putAt(1, rowData['data']);
      } else {
        // var rowData = jsonDecode(response.body);
        Get.back();
      }
    });
  }

  void logout() {
    authdb.clear().then((value) => Get.offAll(() => LoginPage()));
    // auth.clear().then((value) => Get.offAllNamed("/login"));
  }

  Future<void> getEvents() async {
    eventReload.value = false;
    var a2 = Get.find<LoginCont>().auth2;
    final Uri url = Uri.parse(AppConst().baseLink + AppConst().events);
    final headers = {
      'Accept': 'application/json',
      "Authorization": "Bearer " + a2[0].toString(),
    };
    Map data = {};
    data['institution_id'] = a2[1]['institute_id'].toString();
    // data['institution_id'] = "0";
    // print(headers);
    await http.post(url, body: data, headers: headers).then((response) async {
      // print(response.statusCode);
      if (response.statusCode == 200) {
        var rowData = jsonDecode(response.body);
        DateTime cDate = DateTime.now();
        events.clear();
        for (var itemData in rowData['data']) {
          // DateTime eStartDate = DateTime.parse(itemData['event_start']);
          DateTime eEndDate = DateTime.parse(itemData['event_end']);
          if (cDate.isBefore(eEndDate)) {
            await eventPaymentStatus(itemData['id']).then((value) {
              print("----------payst--------");
              print(value);
              itemData['payst'] = value;
              events.add(itemData);
            });
          } else {
            noEvent.value = true;
          }
        }
        eventReload.value = true;
        // print(events);
      } else if (response.statusCode == 404) {
        events.clear();
        noEvent.value = true;
      } else {
        var rowData = jsonDecode(response.body);
        rowData['page'] = "initial_app.dart";
        rowData['function'] = "getEvents()";
        noEvent.value = true;
        print(rowData);
      }
    });
    update();
    // print(events);
  }

  void instituteInfo() async {
    var a2 = Get.find<LoginCont>().auth2;
    print(a2);
    final Uri url = Uri.parse(AppConst().baseLink + AppConst().institute);
    final headers = {
      'Accept': 'application/json',
      "Authorization": "Bearer " + a2[0].toString(),
    };
    Map data = {};
    data['institute_id'] = a2[1]['institute_id'].toString();
    // data['institute_id'] = "0";

    await http.post(url, body: data, headers: headers).then((response) {
      if (response.statusCode == 200) {
        instInfo.clear();
        var rowData = jsonDecode(response.body);
        // print(rowData);
        instInfo.addAll(rowData['data']);
        if (instInfo.isNotEmpty) {
          getEvents();
        }
      } else {
        var rowData = jsonDecode(response.body);
        print(rowData);
      }
    });
    update();
  }

  Widget regWidget(exItem) {
    return Column(
      children: [
        Text(
          "Event Name : ${exItem['event_name']}",
        ),
        Text(
          "Payable Amount : ${exItem['registration_fee']}",
        ),
        SizedBox(height: 2.h),
        Container(
          width: 100.w,
          padding: EdgeInsets.all(10.sp),
          decoration: BoxDecoration(
            color: Colors.orange[300],
          ),
          child: Text("Payment Information"),
        ),
        SizedBox(height: 2.h),
        InputTextField(
          cont: payName,
          fieldtext: "Type Your Name",
          readOnly: true,
        ),
        SizedBox(height: 2.h),
        InputTextField(
          cont: payPhone,
          fieldtext: "Type Your Phone Number",
          keybord: TextInputType.phone,
          readOnly: true,
        ),
        SizedBox(height: 2.h),
        InputTextField(
          cont: payEmail,
          fieldtext: "Type Your Email",
          keybord: TextInputType.emailAddress,
          readOnly: true,
        ),
        SizedBox(height: 2.h),
        // InputTextField(
        //   cont: payAddress,
        //   fieldtext: "Type Your Address",
        //   keybord: TextInputType.streetAddress,
        // ),
        // SizedBox(height: 2.h),
        // InputTextField(
        //   cont: payCity,
        //   fieldtext: "Type Your City",
        // ),
      ],
    );
  }

  void regPage(BuildContext context, exItem) {
    var auth = Get.find<LoginCont>().auth2;
    payName.text = auth[1]['name'];
    payPhone.text = auth[1]['mobile_number'];
    payEmail.text = auth[1]['email'];

    customDialog(
      context,
      "Registration For Event",
      regWidget(exItem),
      "Payment Now",
      () {
        Get.back();
        onShurjopaySdk(context, exItem);
      },
      () => Get.back(),
      true,
    );
  }

  void onShurjopaySdk(BuildContext context, exItem) {
    int orderId = Random().nextInt(1000);
    RequiredRequestData requiredRequestData = RequiredRequestData(
      username: "lambdabd",
      password: "lambfd9mdrzxywu5",
      prefix: "LMB",
      currency: "BDT",
      amount: double.parse(exItem['registration_fee']),
      orderId: "LMB$orderId",
      discountAmount: 0,
      discPercent: 0,
      customerName: payName.text,
      customerPhone: payPhone.text,
      customerEmail: payEmail.text,
      customerAddress: instInfo.isNotEmpty ? "${instInfo['upazila']['upazila_name']} , ${instInfo['district']['district_name']}" : "null",
      customerCity: null,
      customerState: null,
      customerPostcode: null,
      customerCountry: null,
      returnUrl: "https://www.sandbox.shurjopayment.com/return_url",
      cancelUrl: "https://www.sandbox.shurjopayment.com/cancel_url",
      clientIp: "127.0.0.1",
      value1: null,
      value2: null,
      value3: null,
      value4: null,
    );
    ShurjopaySdk shurjopaySdk = ShurjopaySdk(
      onSuccess: (BuildContext context, TransactionInfo? transactionInfo, ErrorSuccess errorSuccess) async {
        print(transactionInfo);
        print("DEBUG_LOG_PRINT: onSuccess");
        if (transactionInfo != null) {
          print("Pament - LMB$orderId");
          paymentSuccess(context, exItem, "LMB$orderId");
        }
      },
      onFailed: (BuildContext context, ErrorSuccess errorSuccess) {
        print("DEBUG_LOG_PRINT:onInternetFailed: $errorSuccess");
      },
    );
    shurjopaySdk.makePayment(
      context: context,
      // sdkType: AppConstants.SDK_TYPE_SANDBOX,
      sdkType: AppConstants.SDK_TYPE_LIVE,
      data: requiredRequestData,
    );
  }

  void paymentSuccess(BuildContext context, exItem, orderid) async {
    var auth = Get.find<LoginCont>().auth2;
    final Uri url = Uri.parse(AppConst().baseLink + AppConst().eventPayment);
    final headers = {
      'Accept': 'application/json',
      "Authorization": "Bearer " + auth[0].toString(),
    };
    Map data = {};
    data['institution_id'] = auth[1]['institute_id'].toString();
    data['user_id'] = auth[1]['id'].toString();
    data['event_id'] = exItem['id'].toString();
    data['amount'] = exItem['registration_fee'];
    data['transactionId'] = orderid;
    print(data);
    await http.post(url, body: data, headers: headers).then((response) {
      print(response.statusCode);
      if (response.statusCode == 200) {
        // flushbar(context, "Payment", "Your Payment is Successed", Icons.done, Colors.green[900], null);
        paymentSuccessPopup();
      } else {
        var rowData = jsonDecode(response.body);
        rowData['page'] = "initial_app.dart";
        rowData['function'] = "paymentSuccess()";
        print(rowData);
      }
    });
  }

  void paymentSuccessPopup() {
    Get.defaultDialog(
      // contentPadding: EdgeInsets.all(20.sp),
      title: "Payment Status",
      titleStyle: TextStyle(
        color: Colors.indigo[900],
      ),
      titlePadding: EdgeInsets.all(10.sp),
      radius: 10.sp,
      contentPadding: EdgeInsets.symmetric(vertical: 5.h),
      content: Container(
        decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey))),
        child: Padding(
          padding: EdgeInsets.all(10.sp),
          child: Column(
            children: [
              Icon(
                Icons.done,
                color: Colors.green[700],
                size: 50.sp,
              ),
              SizedBox(height: 2.h),
              Text("Your Payment Is Successfully Completed"),
            ],
          ),
        ),
      ),
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
        ),
        onPressed: () {
          getEvents();
          Get.back();
        },
        child: Text("Confirmed"),
      ),
      barrierDismissible: false,
    );
  }

  Future<bool> eventPaymentStatus(eventid) async {
    bool payStatus = false;
    var auth = Get.find<LoginCont>().auth2;
    final Uri url = Uri.parse(AppConst().baseLink + AppConst().eventPaymentStatus);
    final headers = {
      'Accept': 'application/json',
      "Authorization": "Bearer " + auth[0].toString(),
    };
    Map data = {};
    data['institution_id'] = auth[1]['institute_id'].toString();
    data['user_id'] = auth[1]['id'].toString();
    data['event_id'] = eventid.toString();
    await http.post(url, body: data, headers: headers).then((response) {
      var st = jsonDecode(response.body)['success'];
      payStatus = st;
    });
    return payStatus;
  }
}
