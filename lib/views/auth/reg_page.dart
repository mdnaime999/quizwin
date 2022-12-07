import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../classs/fields.dart';
import '../../controllers/login_cont.dart';
import '../../controllers/register_cont.dart';

class Registration extends StatelessWidget {
  Registration({Key? key}) : super(key: key);
  final RegisterCont regCont = Get.put(RegisterCont());
  final LoginCont loginCont = Get.find();

  @override
  Widget build(BuildContext context) {
    final data = loginCont.institute['data']['institute'];
    return Scaffold(
      body: Container(
        height: 100.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.indigo.shade900,
              Colors.purple.shade100,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50.sp),
                    child: Container(
                      //width: 60.w,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 10.sp),
                      decoration: BoxDecoration(
                          // border: Border.all(
                          //   width: 1.sp,
                          //   color: Color(0xFFCDF009),
                          // ),
                          // borderRadius: BorderRadius.circular(10.sp),
                          ),
                      child: Text(
                        "Registration".toUpperCase(),
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Container(
                    width: 100.w,
                    margin: EdgeInsets.symmetric(horizontal: 8.w),
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade200,
                      borderRadius: BorderRadius.circular(10.sp),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.indigo.shade900,
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: Offset(4, 4),
                        ),
                        BoxShadow(
                          color: Colors.white70,
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: Offset(-4, -4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10.sp),
                      child: Column(
                        children: [
                          CachedNetworkImage(
                            imageUrl: data['full_institution_logo_path'],
                            imageBuilder: (context, imageProvider) =>
                                CircleAvatar(
                              radius: 10.w,
                              backgroundColor: Colors.orange,
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
                              backgroundColor: Colors.indigo.shade400,
                              child: CircleAvatar(
                                radius: 9.w,
                                backgroundColor: Colors.white,
                                backgroundImage: CachedNetworkImageProvider(
                                    "https://ui-avatars.com/api/?name=" +
                                        data['institution_name']
                                            .replaceAll("+", " ") +
                                        ".png"),
                              ),
                            ),
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            "${data['institution_name']} / ${data['institution_code']}",
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (data['institution_bio'] != null)
                            Text(
                              "${data['institution_bio']}",
                              style: TextStyle(
                                fontSize: 13.sp,
                              ),
                              textAlign: TextAlign.center,
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 3.h),

                  /// For name input
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.w),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 1),
                    decoration: BoxDecoration(
                      color: Color(0xFFEAEAEA),
                      border: Border.all(color: Colors.indigo),
                      borderRadius: BorderRadius.circular(10.sp),
                    ),
                    child: InputInConteiner(
                      cont: loginCont.fullNameCont,
                      title: "Type your full name",
                      color: Colors.indigo.shade900,
                    ),
                  ),
                  SizedBox(height: 2.h),

                  /// For mobile input
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.w),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 1),
                    decoration: BoxDecoration(
                      color: Color(0xFFEAEAEA),
                      border: Border.all(color: Colors.indigo),
                      borderRadius: BorderRadius.circular(10.sp),
                    ),
                    child: Row(
                      children: [
                        Text(
                          "+88",
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14.sp,
                          ),
                        ),
                        Expanded(
                          child: InputInConteiner(
                            cont: loginCont.phoneCont,
                            keybord: TextInputType.phone,
                            title: "01XXXXXXXXX",
                            color: Colors.indigo.shade900,
                            length: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h),

                  /// For Email input
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.w),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 1),
                    decoration: BoxDecoration(
                      color: Color(0xFFEAEAEA),
                      border: Border.all(color: Colors.indigo),
                      borderRadius: BorderRadius.circular(10.sp),
                    ),
                    child: InputInConteiner(
                      cont: loginCont.emailCont,
                      keybord: TextInputType.emailAddress,
                      title: "Type your email",
                      color: Colors.indigo.shade900,
                    ),
                  ),
                  SizedBox(height: 2.h),

                  /// For profession input
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.w),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 1),
                    decoration: BoxDecoration(
                      color: Color(0xFFEAEAEA),
                      border: Border.all(color: Colors.indigo),
                      borderRadius: BorderRadius.circular(10.sp),
                    ),
                    child: Obx(
                      () {
                        return CustomDropDown(
                          fieldtext: 'Select Profession',
                          items: loginCont.professionDropList!,
                          onCh: (value) {
                            loginCont.professionChanged(value);
                          },
                          selectedItem: loginCont.selectedProfession.value != ""
                              ? loginCont.selectedProfession.value
                              : null,
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 2.h),
                  if (loginCont.districtsDropList != null)
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.w),
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 1),
                      decoration: BoxDecoration(
                        color: Color(0xFFEAEAEA),
                        border: Border.all(color: Colors.indigo),
                        borderRadius: BorderRadius.circular(10.sp),
                      ),
                      child: Obx(
                        () => CustomDropDown(
                          fieldtext: 'Select Distric',
                          items: loginCont.districtsDropList!,
                          onCh: (value) {
                            loginCont.districtChanged(value);
                          },
                          selectedItem: loginCont.selectedDistrict.value != ""
                              ? loginCont.selectedDistrict.value
                              : null,
                        ),
                      ),
                    ),
                  SizedBox(height: 3.h),
                  Container(
                    width: 100.w,
                    margin: EdgeInsets.symmetric(horizontal: 8.w),
                    decoration: BoxDecoration(
                      // color: Color(0xFFEAEAEA),
                      // border: Border.all(),
                      borderRadius: BorderRadius.circular(10.sp),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.indigo.shade300,
                      //     spreadRadius: 2,
                      //     blurRadius: 2,
                      //     offset: Offset(0, 0),
                      //   ),
                      // ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF07013F),
                        //shadowColor: Colors.blue,
                        padding: EdgeInsets.symmetric(vertical: 10.sp),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.sp),
                        ),
                      ),
                      child: Text(
                        "Confirm Now".toUpperCase(),
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      onPressed: () {
                        loginCont.registration(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
