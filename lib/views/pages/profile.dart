import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../classs/fields.dart';
import '../../controllers/profile_cont.dart';

class Profile extends StatelessWidget {
  Profile({Key? key}) : super(key: key);
  final ProfileController profileController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 2.8.h),
            decoration: BoxDecoration(
              color: Colors.orange,
            ),
            child: ListTile(
              leading: IconButton(
                onPressed: () => Get.back(),
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
              title: Container(
                alignment: Alignment.center,
                child: Text(
                  "User Profile".toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              trailing: TextButton.icon(
                onPressed: () => profileController.profileUpdate(context),
                icon: Icon(
                  Icons.save,
                  color: Colors.white,
                ),
                label: Text(
                  "Save".toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10.sp),
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(20.sp),
                child: Text(
                  "Please update your profile for QUIZ contest Verification -",
                  style: TextStyle(
                    fontSize: 12.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () => SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: ListView(
                  padding: EdgeInsets.all(10.sp),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    InputTextField(
                      fieldtext: "Please type your name",
                      cont: profileController.proName.value,
                    ),
                    SizedBox(height: 2.h),
                    InputTextField(
                      fieldtext: "Please type your email",
                      cont: profileController.proEmail.value,
                      keybord: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 2.h),
                    InputTextField(
                      fieldtext: "Please type your registration id",
                      cont: profileController.regId.value,
                      keybord: TextInputType.number,
                      readOnly: profileController.auth[1]['registration_no'] != null ? true : false,
                      backColor: profileController.auth[1]['registration_no'] != null ? Colors.grey.shade300 : Colors.white,
                      textStyle: profileController.auth[1]['registration_no'] != null ? TextStyle(color: Colors.grey) : TextStyle(),
                    ),
                    SizedBox(height: 2.h),
                    InputTextField(
                      fieldtext: "Please type your school name",
                      cont: profileController.school.value,
                      readOnly: profileController.auth[1]['school_name'] != null ? true : false,
                      backColor: profileController.auth[1]['school_name'] != null ? Colors.grey.shade300 : Colors.white,
                      textStyle: profileController.auth[1]['school_name'] != null ? TextStyle(color: Colors.grey) : TextStyle(),
                    ),
                    SizedBox(height: 2.h),
                    profileController.auth[1]['registration_card_photo_path'] != null
                        ? Card(
                            child: Image.network(
                              profileController.auth[1]['full_registration_card_photo_path'],
                            ),
                          )
                        : Container(
                            width: 100.w,
                            decoration: BoxDecoration(
                              color: Color(0xFFEAEAEA),
                              // border: Border.all(),
                              borderRadius: BorderRadius.circular(10.sp),
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: profileController.regCard == null ? Colors.orange.shade700 : Colors.green,
                                // elevation: 5,
                                // shadowColor: Colors.blue,
                                padding: EdgeInsets.symmetric(vertical: 10.sp),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.sp),
                                ),
                              ),
                              onPressed: () async {
                                profileController.pickImage();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.image),
                                  SizedBox(width: 5.sp),
                                  Text("Upload Registration Card"),
                                ],
                              ),
                            ),
                          ),
                    if (profileController.imgPath.value != "") SizedBox(height: 2.h),
                    if (profileController.imgPath.value != "")
                      Card(
                        child: Image.file(
                          File(profileController.imgPath.value),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
