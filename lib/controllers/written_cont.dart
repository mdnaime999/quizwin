import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class WrittenCont extends GetxController {
  double a = 0;

  @override
  void onInit() {
    super.onInit();
    a = 3.w;
    print(a);
  }

  Widget lathi = Transform.rotate(
    angle: 42 / 12.0,
    child: Container(
      height: 5.h,
      width: 1.5.w,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.5),
        border: Border.all(
          color: Colors.yellow,
        ),
        borderRadius: BorderRadius.circular(5.sp),
      ),
    ),
  );
}
