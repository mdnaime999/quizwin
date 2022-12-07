import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../classs/fields.dart';
import '../initial/app_const.dart';
import '../initial/initial_app.dart';
import '../methords/custom_methord.dart';
import 'login_cont.dart';

class DrawerCont extends GetxController {
  RxMap profile = {}.obs;
  final ImagePicker _picker = ImagePicker();
  XFile? proPhotoPicker;
  RxBool proPhotoProgress = false.obs;

  // Text Editing Controler
  TextEditingController proName = TextEditingController();
  TextEditingController proEmail = TextEditingController();

  TextEditingController regId = TextEditingController();
  TextEditingController school = TextEditingController();
  TextEditingController upazila = TextEditingController();
  XFile? regCard;
  UploadTask? putFile;

  @override
  void onInit() {
    getProfile();
    super.onInit();
  }

  void goto() async {
    Uri url = Uri.parse("https://play.google.com/store/apps/details?id=com.prostuti.contest");
    if (!await launchUrl(url)) throw 'Could not launch $url';
  }

  void getProfile() {
    profile.addAll(Get.find<LoginCont>().auth2);
  }

  void getImage(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(100.h)),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 5,
      builder: (builder) {
        return Container(
          height: 30.h,
          color: Colors.transparent,
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: 60.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100.w,
                  padding: EdgeInsets.symmetric(horizontal: 10.sp),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(10.sp),
                      primary: AppConst.backgroundColor,
                    ),
                    onPressed: () => pickImage(context, ImageSource.camera),
                    icon: Icon(Icons.camera),
                    label: Text("Camera"),
                  ),
                ),
                SizedBox(height: 2.h),
                Container(
                  width: 100.w,
                  padding: EdgeInsets.symmetric(horizontal: 10.sp),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(10.sp),
                      primary: AppConst.backgroundColor,
                    ),
                    onPressed: () => pickImage(context, ImageSource.gallery),
                    icon: Icon(Icons.photo),
                    label: Text("Gallery"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget proPhotoDialog() {
    return Center(
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.sp),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10.sp),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 40.w,
                    height: 40.w,
                    child: Obx(
                      () => CircularProgressIndicator(
                        value: proPhotoProgress.value ? null : 1.0,
                        strokeWidth: 10.sp,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 40.w,
                    height: 40.w,
                    child: CircleAvatar(
                      backgroundImage: FileImage(
                        File(proPhotoPicker!.path),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      saveImage();
                    },
                    child: Text("Save"),
                  ),
                  SizedBox(width: 5.w),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text("Cancel"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void pickImage(BuildContext context, ImageSource source) async {
    Get.back();
    await _picker.pickImage(source: source).then((response) async {
      if (response != null) {
        proPhotoPicker = response;
        Get.dialog(proPhotoDialog());
        // imgOn.value = true;
      }
    });
  }

  void saveImage() async {
    var auth = Get.find<LoginCont>().auth2;
    proPhotoProgress.value = true;
    if (auth.isNotEmpty) {
      final Uri url = Uri.parse(AppConst().baseLink + AppConst().profileUpdate);
      var request = http.MultipartRequest("POST", url);
      request.headers['Accept'] = 'application/json';
      request.headers['Authorization'] = "Bearer " + auth[0].toString();
      request.fields['user_id'] = auth[1]['id'].toString();
      request.files.add(
        await http.MultipartFile.fromPath(
          'profile_photo_path',
          proPhotoPicker!.path,
          filename: proPhotoPicker!.path.split("/").last,
        ),
      );
      print(proPhotoPicker!.path);
      http.StreamedResponse response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 200) {
        Get.find<LoginCont>().authRefresh(auth);
        await Future.delayed(Duration(seconds: 1)).then((value) {
          getProfile();
          proPhotoProgress.value = false;
        });
        Get.back();
      }
    } else {}
  }

  Widget profileDialog() {
    return Column(
      children: [
        InputTextField(
          fieldtext: "Please type your name",
          cont: proName,
        ),
        SizedBox(height: 1.h),
        InputTextField(
          fieldtext: "Please type your email",
          cont: proEmail,
          keybord: TextInputType.emailAddress,
        )
      ],
    );
  }

  void profileEdit(BuildContext context) {
    proName.text = profile[1]["name"];
    proEmail.text = profile[1]["email"];
    customDialog(
      context,
      "Edit Your Profile",
      profileDialog(),
      "Save",
      () => saveProfile(),
      () => Get.back(),
      false,
    );
  }

  Widget impUpdateDialog() {
    return Column(
      children: [
        InputTextField(
          fieldtext: "Please type your registration id",
          cont: regId,
          keybord: TextInputType.number,
        ),
        SizedBox(height: 1.h),
        InputTextField(
          fieldtext: "Please type your school name",
          cont: school,
        ),
        SizedBox(height: 1.h),
        InputTextField(
          fieldtext: "Please type your upazila",
          cont: upazila,
          keybord: TextInputType.streetAddress,
        ),
        SizedBox(height: 1.h),
        Container(
          width: 100.w,
          decoration: BoxDecoration(
            color: Color(0xFFEAEAEA),
            // border: Border.all(),
            borderRadius: BorderRadius.circular(10.sp),
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: regCard == null ? Colors.orange.shade700 : Colors.green,
              // elevation: 5,
              // shadowColor: Colors.blue,
              padding: EdgeInsets.symmetric(vertical: 10.sp),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.sp),
              ),
            ),
            onPressed: () async {
              await _picker.pickImage(source: ImageSource.gallery).then((response) async {
                if (response != null) {
                  regCard = response;
                  print(regCard!.path);
                  print(regCard!.name);
                }
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image),
                SizedBox(width: 5.sp),
                Text("Select Registration Card"),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void impUpdate(BuildContext context) {
    var auth = Get.find<LoginCont>().auth2;
    if (auth.isEmpty) {
      Get.snackbar(
        "Worning!",
        "Please Login First",
        backgroundColor: Color(0xFFFFA600),
        margin: EdgeInsets.only(top: 5.h),
      );
    } else {
      customDialog(
        context,
        "Importent Update Your Profile",
        impUpdateDialog(),
        "Save",
        () => saveImpUpdate(auth[1]['id'].toString()),
        () => Get.back(),
        false,
      );
    }
  }

  void saveImpUpdate(String uid) async {
    if (regId.text == "") {
      Get.snackbar(
        "Worning!",
        "Registration id field is requard",
        backgroundColor: Color(0xFFFFA600),
        margin: EdgeInsets.only(top: 5.h),
      );
    } else if (school.text == "") {
      Get.snackbar(
        "Worning!",
        "School name field is requard",
        backgroundColor: Color(0xFFFFA600),
        margin: EdgeInsets.only(top: 5.h),
      );
    } else if (upazila.text == "") {
      Get.snackbar(
        "Worning!",
        "Upazila field is requard",
        backgroundColor: Color(0xFFFFA600),
        margin: EdgeInsets.only(top: 5.h),
      );
    } else if (regCard == null) {
      Get.snackbar(
        "Worning!",
        "Please select registration card",
        backgroundColor: Color(0xFFFFA600),
        margin: EdgeInsets.only(top: 5.h),
      );
    } else {
      SmartDialog.showLoading(
        msg: "Importent Updating....",
        backDismiss: false,
        background: Colors.indigo.shade200,
      );
      Map<String, dynamic> sendData = {};
      var fileExt = regCard!.name.split('.').last;
      sendData['reg_id'] = regId.text;
      sendData['school'] = school.text;
      sendData['upazila'] = upazila.text;
      sendData['reg_card'] = 'regcard$uid.$fileExt';

      final regPath = 'registration_card/regcard$uid.$fileExt';
      final regFile = File(regCard!.path);

      var userProfile = FirebaseFirestore.instance.collection("user_profile");
      var regStore = FirebaseStorage.instance.ref().child(regPath);

      await userProfile.doc(uid).set(sendData).then((value) async {
        putFile = regStore.putFile(regFile);
        await putFile!.whenComplete(() {}).then((snapshot) {
          SmartDialog.dismiss().then((value) => InitialApp().logout());
        });
      });
    }
  }

  void saveProfile() async {
    var auth = Get.find<LoginCont>().auth2;
    if (auth.isEmpty) {
    } else if (proName.text == "") {
      Get.snackbar(
        "Worning!",
        "Name field cannot be left blank",
        backgroundColor: Color(0xFFFFA600),
        margin: EdgeInsets.only(top: 5.h),
      );
    } else if (proEmail.text == "") {
      Get.snackbar(
        "Worning!",
        "Email field cannot be left blank",
        backgroundColor: Color(0xFFFFA600),
        margin: EdgeInsets.only(top: 5.h),
      );
    } else {
      SmartDialog.showLoading(
        msg: "Profile Updating....",
        backDismiss: false,
        background: Colors.indigo.shade200,
      );
      final Uri url = Uri.parse(AppConst().baseLink + AppConst().profileUpdate);
      var request = http.MultipartRequest("POST", url);
      request.headers['Accept'] = 'application/json';
      request.headers['Authorization'] = "Bearer " + auth[0].toString();
      request.fields['user_id'] = auth[1]['id'].toString();
      request.fields['name'] = proName.text;
      request.fields['email'] = proEmail.text;
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        Get.find<LoginCont>().authRefresh(auth);
        await Future.delayed(Duration(seconds: 1)).then((value) {
          SmartDialog.dismiss().then((v) => getProfile());
        });
        Get.back();
      }
    }
  }
}
