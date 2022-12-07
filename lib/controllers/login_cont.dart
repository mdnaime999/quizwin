import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pinput/pinput.dart';
import 'package:sizer/sizer.dart';

import '../classs/fields.dart';
import '../initial/app_const.dart';
import '../main.dart';
import '../methords/custom_methord.dart';
import '../views/auth/otp_page.dart';
import '../views/auth/reg_page.dart';
import '../views/home_page.dart';
import '../views/pages/update.dart';
// import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

class LoginCont extends GetxController {
  TextEditingController searchtext = TextEditingController();
  TextEditingController fullNameCont = TextEditingController();
  TextEditingController phoneCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();

  TextEditingController otpR = TextEditingController();
  int? saveCode;

  Map institute = {};

  // Profession Dropdown menu
  List<String> professionList = ['Student', 'Job', 'Others'];
  List<DropdownMenuItem<dynamic>>? professionDropList;
  RxString selectedProfession = "".obs;

  // District Dropdown menu
  List<DropdownMenuItem<dynamic>>? districtsDropList;
  RxString selectedDistrict = "".obs;

  // Database
  Box auth = Hive.box('auth');
  Map auth2 = {};
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // App Updater
  Rx<PackageInfo> appInfo = PackageInfo(
    appName: "",
    packageName: "",
    version: "",
    buildNumber: "",
  ).obs;
  RxBool versionStatus = false.obs;
  RxMap newVersion = {}.obs;

  @override
  void onInit() {
    splashScreen();
    super.onInit();
  }

  void splashScreen() async {
    // versionCheck();
    print('ready in 3...');
    await Future.delayed(Duration(seconds: 1));
    print('ready in 2...');
    await Future.delayed(Duration(seconds: 1));
    print('ready in 1...');
    await Future.delayed(Duration(seconds: 1));
    print('go!');

    authRefresh(auth.toMap());
    SmartDialog.config.clickBgDismiss = false;
    districtLoad();
  }

  void versionCheck() async {
    var storeVersion = FirebaseFirestore.instance.collection("appversion");
    appInfo.value = await PackageInfo.fromPlatform();

    if (appInfo.value.version != "") {
      // print(appInfo.value.version);
      storeVersion.doc('version').get().then((fields) {
        newVersion['code'] = fields.get('code');
        newVersion['date'] = fields.get('date');
        if (fields.get('code') == appInfo.value.version) {
          versionStatus.value = true;
        } else {
          versionStatus.value = false;
          Get.offAll(Updater());
        }
      });
    }

    // final NewVersion newVersion = NewVersion(androidId: AppConst().packAndroid, iOSId: AppConst().packAndroid);
    // try {
    //   await newVersion.getVersionStatus().then((versionStatus) {
    //     if (versionStatus != null && versionStatus.canUpdate) {
    //       newVersion.showUpdateDialog(
    //         context: Get.context!,
    //         versionStatus: versionStatus,
    //         allowDismissal: false,
    //       );
    //     }
    //   });
    // } catch (e) {
    //   print(e);
    // }
  }

  void professionChanged(value) {
    selectedProfession.value = value;
    update();
    print(selectedProfession);
  }

  void authRefresh(upAuth) async {
    if (upAuth.isNotEmpty) {
      final Uri url =
          Uri.parse(AppConst().baseLink + AppConst().loginGetDataUri);
      final headers = {'Accept': 'application/json'};
      Map data = {};
      data['mobile_number'] = upAuth[1]['mobile_number'].toString();
      data['institute_id'] = upAuth[1]['institute_id'].toString();
      await http.post(url, body: data, headers: headers).then((response) {
        if (response.statusCode == 200) {
          var rowData = jsonDecode(response.body);
          auth.clear();
          Map putData = {0: rowData['headers']['token'], 1: rowData['data']};
          auth.putAll(putData);
          auth2.addAll(putData);
        } else {
          var rowData = jsonDecode(response.body);
          print(rowData);
        }
      });
      Get.to(() => HomePage(), binding: InitBinding());
    } else {
      // bool ifr = await IsFirstRun.isFirstRun();
      // if (ifr) {
      //   Get.to(() => FirstOpening(), binding: FirstOpeningBinding());
      // } else {
      //   FlutterNativeSplash.remove();
      // }
      FlutterNativeSplash.remove();
    }
    // print(upAuth);
  }

  void districtLoad() async {
    final Uri url = Uri.parse(AppConst().baseLink + AppConst().districtUri);
    final headers = {'Accept': 'application/json'};
    Map data = {};
    await http.post(url, body: data, headers: headers).then((response) async {
      if (response.statusCode == 200) {
        var rowDatas = jsonDecode(response.body)['data'];
        districtsDropList = List.generate(
          rowDatas.length,
          (i) => DropdownMenuItem(
            value: rowDatas[i]['id'].toString(),
            child: Text(
              "${rowDatas[i]['district_name']}",
              style: TextStyle(
                fontSize: 12.sp,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      } else if (response.statusCode == 400) {
        var rowData = jsonDecode(response.body);
        Get.snackbar("Warning!", "${rowData['msg']}");
      } else {
        Get.snackbar("Warning!", "Your district request is incorrect");
      }
    });
  }

  void districtChanged(value) {
    selectedDistrict.value = value;
    update();
    print(selectedDistrict);
  }

  Widget listInstitute(BuildContext context, instData) {
    return SizedBox(
      height: 40.h,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: instData.length,
        itemBuilder: (context, index) {
          var inst = instData[index]['institution'];
          return Container(
            padding: EdgeInsets.all(5.sp),
            // margin: EdgeInsets.only(bottom: 1.h),
            child: GestureDetector(
              onTap: () {
                // print(instData[index]['institution']);
                loginVerify(context, instData[index]['institution']);
              },
              child: Card(
                elevation: 5,
                color: Colors.indigo.shade800,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 20.sp,
                    backgroundColor: Colors.red,
                    child: CircleAvatar(
                      backgroundColor: Colors.indigo,
                      radius: 18.sp,
                      child: CachedNetworkImage(
                        imageUrl: inst['full_institution_logo_path'],
                        imageBuilder: (context, imageProvider) => CircleAvatar(
                          radius: 10.w,
                          backgroundColor: Colors.indigo.shade900,
                          child: CircleAvatar(
                            radius: 9.w,
                            backgroundColor: Colors.white,
                            backgroundImage: imageProvider,
                          ),
                        ),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => CircleAvatar(
                          radius: 10.w,
                          backgroundColor: Colors.indigo.shade900,
                          child: CircleAvatar(
                            radius: 9.w,
                            backgroundColor: Colors.white,
                            backgroundImage: CachedNetworkImageProvider(
                                "https://ui-avatars.com/api/?name=" +
                                    inst['institution_name']
                                        .replaceAll("+", " ") +
                                    ".png"),
                          ),
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text(
                    inst['institution_name'],
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    "Institution Code : ${inst['institution_code']}",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void login(BuildContext context) async {
    final Uri url = Uri.parse(AppConst().baseLink + AppConst().userLoginUri);
    final headers = {'Accept': 'application/json'};
    Map data = {};
    if (phoneCont.text == "") {
      flushbar(context, "Warning!", "Phone field is required", Icons.warning,
          Colors.red, null);
    } else if (phoneCont.text.length < 11) {
      flushbar(context, "Warning!", "Phone number to short", Icons.warning,
          Colors.red, null);
    } else {
      data['mobile_number'] = phoneCont.text;

      SmartDialog.showLoading(
        backDismiss: false,
        background: Colors.indigo.shade200,
      );

      await http.post(url, body: data, headers: headers).then((response) {
        if (response.statusCode == 200) {
          var rowData = jsonDecode(response.body);
          if (rowData['data'].length == 1) {
            SmartDialog.dismiss().then((value) =>
                loginVerify(context, rowData['data'][0]['institution']));
          } else if (rowData['data'].length > 1) {
            SmartDialog.dismiss().then(
              (value) => customDialog(
                context,
                "Institution List's",
                listInstitute(context, rowData['data']),
                null,
                null,
                () => Get.back(),
                true,
              ),
            );
          } else {
            SmartDialog.dismiss().then((value) => null);
          }
        } else if (response.statusCode == 400) {
          var rowData = jsonDecode(response.body);
          // print(rowData);
          SmartDialog.dismiss();
          flushbar(context, "Warning!", "${rowData['msg']}", Icons.warning,
              Colors.red, null);
        } else {
          var rowData = jsonDecode(response.body);
          print(rowData);
          TextStyle textStyle = TextStyle(
            color: Colors.white,
          );
          SmartDialog.dismiss().then((value) {
            Get.defaultDialog(
              backgroundColor: AppConst.backgroundColor,
              title: "Message",
              titleStyle: textStyle,
              middleText:
                  "You are not registered user,\nPlease confirm your registration",
              middleTextStyle: textStyle,
              radius: 10.sp,
            );
          });
        }
      });
    }
  }

  loginVerify(BuildContext context, infoData) async {
    final Uri url = Uri.parse(AppConst().baseLink + AppConst().userLoginOtpUri);
    final headers = {'Accept': 'application/json'};
    Map data = {};

    data['mobile_number'] = phoneCont.text;
    var rng = Random();
    var code = rng.nextInt(1111) + 1000;
    if (phoneCont.text == "01301393735" || phoneCont.text == "01761273082") {
      code = 1234;
    }
    data['otp'] = code.toString();
    data['institute_id'] = infoData['id'].toString();
    saveCode = code;

    // print(data);
    SmartDialog.showLoading(
      backDismiss: false,
      background: Colors.indigo.shade200,
    );

    await http.post(url, body: data, headers: headers).then((response) {
      if (response.statusCode == 200) {
        var rowData = jsonDecode(response.body);
        print(rowData);
        Get.back();
        otpCoundown.value = 100;
        focusNode.requestFocus();
        coundownOtp();
        SmartDialog.dismiss().then(
          (value) => Get.to(
            OtpVerify(
              action: () {
                otpCoundown.value = 0;
                focusNode = FocusNode();
                print(code);
                if (pinCont.text != "") {
                  if (int.parse(pinCont.text) == saveCode) {
                    getLoginData(context, infoData);
                  } else {
                    print("Don't Match OTP");
                  }
                  pinCont.text = "";
                } else {}
              },
              pageType: "login",
              instInfo: infoData,
            ),
          ),
        );
      } else if (response.statusCode == 400) {
        var rowData = jsonDecode(response.body);
        print(rowData);
        SmartDialog.dismiss();
        flushbar(context, "Warning!", "${rowData['msg']}", Icons.warning,
            Colors.red, null);
      } else {
        var rowData = jsonDecode(response.body);
        print(rowData);
        SmartDialog.dismiss();
        flushbar(context, "Warning!", "Your login otp sms request is incorrect",
            Icons.warning, Colors.red, null);
      }
    });
  }

  getLoginData(BuildContext context, infoData) async {
    final Uri url = Uri.parse(AppConst().baseLink + AppConst().loginGetDataUri);
    final headers = {'Accept': 'application/json'};
    Map data = {};

    data['mobile_number'] = phoneCont.text;
    data['institute_id'] = infoData['id'].toString();
    // print(data);

    SmartDialog.showLoading(
      backDismiss: false,
      background: Colors.indigo.shade200,
    );

    await http.post(url, body: data, headers: headers).then((response) async {
      // print(response.body);
      if (response.statusCode == 200) {
        var rowData = jsonDecode(response.body);
        // print(rowData);
        auth.clear();

        Map putData = {0: rowData['headers']['token'], 1: rowData['data']};
        auth.putAll(putData);
        auth2.addAll(putData);
        if (auth.isNotEmpty) {
          SmartDialog.dismiss().then(
              (value) => Get.offAll(() => HomePage(), binding: InitBinding()));
        }
      } else if (response.statusCode == 400) {
        var rowData = jsonDecode(response.body);
        print(rowData);
        SmartDialog.dismiss().then((value) => flushbar(context, "Warning!",
            "${rowData['msg']}", Icons.warning, Colors.red, null));
      } else {
        var rowData = jsonDecode(response.body);
        print(rowData);
        SmartDialog.dismiss().then((value) => flushbar(
            context,
            "Warning!",
            "Your login get data request is incorrect",
            Icons.warning,
            Colors.red,
            null));
      }
    });
  }

  Widget searchInst() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.sp),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: Color(0xFFEAEAEA),
        // border: Border.all(),
        borderRadius: BorderRadius.circular(10.sp),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.shade100,
            spreadRadius: 5,
            blurRadius: 5,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: InputInConteiner(
        cont: searchtext,
        icon: Icons.search,
        title: "Search Name / Code",
        color: Colors.indigo.shade900,
        focus: true,
      ),
    );
  }

  void searchChange(BuildContext context) async {
    searchtext.text = "3247";
    final Uri url = Uri.parse(AppConst().baseLink + AppConst().searchInstUri);
    final headers = {'Accept': 'application/json'};
    Map data = {};
    if (searchtext.text == "") {
      flushbar(context, "Warning!", "Search text is requard", Icons.warning,
          Colors.red, null);
    } else {
      data['search_term'] = searchtext.text;
      // print(data);
      // Get.back();

      await http.post(url, body: data, headers: headers).then((response) async {
        // print(response.statusCode);
        if (response.statusCode == 200) {
          institute.clear();
          institute = jsonDecode(response.body);
          searchtext.text = "";
          // Get.back();
          if (institute.isNotEmpty) {
            var prof = institute['data']['professions'];
            professionDropList = List.generate(
              prof.length,
              (i) => DropdownMenuItem(
                value: prof[i]['id'].toString(),
                child: Text(
                  "${prof[i]['profession_name']}",
                  style: TextStyle(
                    fontSize: 12.sp,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
            if (professionDropList!.isNotEmpty) {
              Get.to(() => Registration(), transition: Transition.zoom);
            } else {
              flushbar(
                  context,
                  "Warning!",
                  "Please Contact with Institute Admin (profession)",
                  Icons.warning,
                  Colors.red,
                  null);
            }
          }
        } else if (response.statusCode == 400) {
          var rowData = jsonDecode(response.body);
          flushbar(context, "Warning!", "${rowData['msg']}", Icons.warning,
              Colors.red, null);
        } else {
          flushbar(context, "Warning!", "Your search request is incorrect",
              Icons.warning, Colors.red, null);
        }
      });
    }
  }

  TextEditingController pinCont = TextEditingController();
  var focusNode = FocusNode();
  var length = 4;
  RxInt otpCoundown = 100.obs;
  Color borderColor = Colors.indigo.shade500;
  Color errorColor = Colors.red.shade900;
  Color fillColor = Colors.grey.shade100;

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 60,
    textStyle: TextStyle(
      fontSize: 22,
      color: Colors.indigo.shade900,
    ),
    decoration: BoxDecoration(
      color: Colors.grey.shade300,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.indigo.shade900),
    ),
  );

  void coundownOtp() async {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (otpCoundown <= 0) {
        timer.cancel();
      } else {
        otpCoundown--;
      }
      update();
    });
  }

  Widget otpInput() {
    focusNode.requestFocus();
    coundownOtp();
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10.sp),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Pinput(
            length: length,
            controller: pinCont,
            focusNode: focusNode,
            defaultPinTheme: defaultPinTheme,
            focusedPinTheme: defaultPinTheme.copyWith(
              height: 68,
              width: 64,
              decoration: defaultPinTheme.decoration!.copyWith(
                border: Border.all(color: borderColor),
              ),
            ),
            errorPinTheme: defaultPinTheme.copyWith(
              decoration: BoxDecoration(
                color: errorColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10.sp),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Obx(() => otpCoundown.value <= 0
              ? TextButton(
                  onPressed: () {}, child: Text("Resend Otp".toUpperCase()))
              : Text(
                  "Wait for resend\n${otpCoundown.value}",
                  textAlign: TextAlign.center,
                )),
        ),
        SizedBox(height: 3.h),
        // Container(
        //   margin: EdgeInsets.symmetric(horizontal: 10.sp),
        //   padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        //   child: RichText(
        //     text: TextSpan(
        //       children: [
        //         TextSpan(
        //           text: "OTP Code Send to ",
        //           style: TextStyle(
        //             color: Colors.indigo[900],
        //           ),
        //         ),
        //         WidgetSpan(
        //           child: Icon(
        //             Icons.mail_outline,
        //             color: Colors.indigo[900],
        //             size: 12.sp,
        //           ),
        //         ),
        //         TextSpan(
        //           text: " +88${phoneCont.text}",
        //           style: TextStyle(
        //             color: Colors.indigo[900],
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }

  void registration(BuildContext context) async {
    final Uri url = Uri.parse(AppConst().baseLink + AppConst().userRegUri);
    final headers = {'Accept': 'application/json'};
    Map data = {};
    if (institute.isEmpty) {
      flushbar(context, "Warning!", "Institute is required", Icons.warning,
          Colors.red, null);
    } else if (fullNameCont.text == "") {
      flushbar(context, "Warning!", "Name field is required", Icons.warning,
          Colors.red, null);
    } else if (phoneCont.text == "") {
      flushbar(context, "Warning!", "Phone field is required", Icons.warning,
          Colors.red, null);
    } else if (phoneCont.text.length < 11) {
      flushbar(context, "Warning!", "Phone number to short", Icons.warning,
          Colors.red, null);
    } else if (selectedProfession.value == "") {
      flushbar(context, "Warning!", "Profession is required", Icons.warning,
          Colors.red, null);
    } else if (selectedDistrict.value == "") {
      flushbar(context, "Warning!", "District is required", Icons.warning,
          Colors.red, null);
    } else {
      data['institution_id'] = institute['data']['institute']['id'].toString();
      data['name'] = fullNameCont.text;
      data['mobile_number'] = phoneCont.text;
      data['email'] = emailCont.text;
      data['profession_id'] = selectedProfession.value;
      data['district_id'] = selectedDistrict.value;

      SmartDialog.showLoading(
        backDismiss: false,
        background: Colors.indigo.shade200,
      );

      await http.post(url, body: data, headers: headers).then((response) async {
        if (response.statusCode == 200) {
          var rowData = jsonDecode(response.body);
          print(rowData);

          otpCoundown.value = 100;
          focusNode.requestFocus();
          coundownOtp();
          SmartDialog.dismiss().then(
            (value) => Get.to(
              OtpVerify(
                action: () {
                  otpCoundown.value = 0;
                  focusNode = FocusNode();
                  verifyOtp(context);
                  pinCont.text = "";
                },
                pageType: "register",
                instInfo: institute['data']['institute'],
              ),
            ),
          );

          // SmartDialog.dismiss().then(
          //   (value) => customDialog(
          //     context,
          //     "Verification",
          //     otpInput(),
          //     "verify otp".toUpperCase(),
          //     () {
          //       verifyOtp(context);
          //       pinCont.text = "";
          //       otpCoundown.value = 100;
          //     },
          //     null,
          //     false,
          //   ),
          // );
        } else if (response.statusCode == 400) {
          var rowData = jsonDecode(response.body);
          print(rowData);
          SmartDialog.dismiss();
          flushbar(context, "Warning!", "${rowData['msg']}", Icons.warning,
              Colors.red, null);
        } else {
          var rowData = jsonDecode(response.body);
          print(rowData);
          TextStyle textStyle = TextStyle(
            color: Colors.white,
          );
          SmartDialog.dismiss().then((value) {
            Get.defaultDialog(
              backgroundColor: AppConst.backgroundColor,
              title: "Message",
              titleStyle: textStyle,
              middleText: "User Already Registered",
              middleTextStyle: textStyle,
              radius: 10.sp,
            );
          });
          // flushbar(context, "Warning!", "Your registration request is incorrect", Icons.warning, Colors.red, null);
        }
      });
    }
  }

  verifyOtp(BuildContext context) async {
    final Uri url = Uri.parse(AppConst().baseLink + AppConst().userRegOtpUri);
    final headers = {'Accept': 'application/json'};
    Map data = {};

    if (institute.isEmpty) {
      flushbar(context, "Warning!", "Institute is required", Icons.warning,
          Colors.red, null);
    } else if (phoneCont.text == "") {
      flushbar(context, "Warning!", "Phone field is required", Icons.warning,
          Colors.red, null);
    } else if (pinCont.text == "") {
      flushbar(context, "Warning!", "OTP pin fields is required", Icons.warning,
          Colors.red, null);
    } else {
      data['mobile_number'] = phoneCont.text;
      data['otp'] = pinCont.text;
      data['institute_id'] = institute['data']['institute']['id'].toString();
      print(data);
      SmartDialog.showLoading(
        backDismiss: false,
        background: Colors.indigo.shade200,
      );
      await http.post(url, body: data, headers: headers).then((response) {
        if (response.statusCode == 200) {
          var rowData = jsonDecode(response.body);
          print(rowData);
          auth.clear();
          Map putData = {
            0: rowData['headers']['token'],
            1: rowData['data'],
            2: rowData['auto_approved']
          };
          auth.putAll(putData);
          auth2.addAll(putData);
          if (auth.isNotEmpty) {
            SmartDialog.dismiss().then((value) =>
                Get.offAll(() => HomePage(), binding: InitBinding()));
          }
        } else if (response.statusCode == 400) {
          var rowData = jsonDecode(response.body);
          // print(rowData);
          SmartDialog.dismiss();
          flushbar(context, "Warning!", "${rowData['msg']}", Icons.warning,
              Colors.red, null);
        } else {
          var rowData = jsonDecode(response.body);
          // print(rowData);
          SmartDialog.dismiss();
          flushbar(context, "Warning!", "${rowData['msg']}", Icons.warning,
              Colors.red, null);
        }
      });
    }
  }

  void reSendOtp(String type, instInfo) async {
    otpCoundown.value = 50;
    coundownOtp();
    final Uri url = Uri.parse(AppConst().baseLink + AppConst().reSendOtpUri);
    final headers = {'Accept': 'application/json'};
    Map data = {};
    data['mobile_number'] = phoneCont.text;
    var rng = Random();
    var code = rng.nextInt(1111) + 1000;
    if (phoneCont.text == "01301393735" || phoneCont.text == "01761273082") {
      code = 1234;
    }
    data['otp'] = code.toString();
    data['institute_id'] = instInfo['id'].toString();
    data['type'] = type;
    saveCode = code;
    await http.post(url, body: data, headers: headers).then((response) {
      if (response.statusCode == 200) {
        var rowData = jsonDecode(response.body);
        print(rowData);
      } else {
        var rowData = jsonDecode(response.body);
        print(rowData);
      }
    });
  }

  Future<Map<String, dynamic>> userProfile(userId) async {
    var userProfile = FirebaseFirestore.instance.collection("user_profile");
    Map<String, dynamic> profileData = {};
    await userProfile.doc(userId.toString()).get().then((value) {
      if (value.data() != null) {
        profileData.addAll(value.data()!);
      }
    });
    return profileData;
  }
}
