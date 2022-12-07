import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:sizer/sizer.dart';

import '../initial/app_const.dart';

void customDialog(BuildContext context, String title, Widget body, String? btnName, Function()? btnFun, Function()? cBtnFun, bool? backButton) {
  showAnimatedDialog(
    context: context,
    barrierColor: Color(0xC8000000),
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => backButton!,
        child: AlertDialog(
          contentPadding: EdgeInsets.all(0),
          insetPadding: EdgeInsets.symmetric(horizontal: 5.w),
          backgroundColor: Colors.transparent,
          content: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: 100.w,
                  padding: EdgeInsets.all(5.w),
                  decoration: BoxDecoration(
                    color: AppConst.backgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.sp),
                      topRight: Radius.circular(10.sp),
                    ),
                  ),
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  width: 100.w,
                  padding: EdgeInsets.all(5.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: body,
                ),
                Container(
                  width: 100.w,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.sp),
                      bottomRight: Radius.circular(10.sp),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (cBtnFun != null)
                        ElevatedButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.red[900],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1.w),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
                          ),
                          child: Text("Cancel"),
                          onPressed: cBtnFun,
                        ),
                      SizedBox(width: 3.w),
                      if (btnName != null)
                        ElevatedButton(
                          style: TextButton.styleFrom(
                            backgroundColor: AppConst.backgroundColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1.w),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
                          ),
                          child: Text(
                            btnName != "" ? btnName : "Button Name",
                            style: TextStyle(),
                          ),
                          // ignore: unnecessary_null_in_if_null_operators
                          onPressed: btnFun ?? null,
                        )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
    animationType: DialogTransitionType.scale,
    curve: Curves.bounceInOut,
    duration: Duration(milliseconds: 500),
  );
}

flushbar(BuildContext context, title, message, IconData? icon, color, Duration? duration) {
  Flushbar(
    backgroundColor: color,
    borderRadius: BorderRadius.circular(10),
    maxWidth: 90.w,
    margin: EdgeInsets.only(top: 10.h),
    flushbarPosition: FlushbarPosition.TOP,
    dismissDirection: FlushbarDismissDirection.HORIZONTAL,
    // title: title,
    titleText: Padding(
      padding: EdgeInsets.only(left: 8.w),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 11.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    messageText: Padding(
      padding: EdgeInsets.only(left: 8.w),
      child: Text(
        message,
        style: TextStyle(
          color: Colors.white,
          fontSize: 10.sp,
        ),
      ),
    ),
    // message: message,
    icon: icon != null
        ? Padding(
            padding: EdgeInsets.only(left: 5.w),
            child: Icon(
              icon,
              size: 10.w,
              color: Colors.white,
            ),
          )
        : null,
    boxShadows: [
      BoxShadow(
        color: Colors.indigo.shade900.withOpacity(0.5),
        spreadRadius: 30,
        blurRadius: 30,
        offset: Offset(0, -10.h),
      ),
    ],
    duration: duration ?? Duration(seconds: 3),
    animationDuration: Duration(milliseconds: 300),
  ).show(context);
}

// class NetworkImageWidget extends StatelessWidget {
//   NetworkImageWidget({required this.path});
//   final String path;

//   @override
//   Widget build(BuildContext context) {
//     return CachedNetworkImage(
//       imageUrl: path,
//       imageBuilder: (context, imageProvider) => CircleAvatar(
//         radius: 10.w,
//         backgroundColor: Colors.indigo.shade900,
//         child: CircleAvatar(
//           radius: 9.w,
//           backgroundColor: Colors.white,
//           backgroundImage: imageProvider,
//         ),
//       ),
//       placeholder: (context, url) => CircularProgressIndicator(),
//       errorWidget: (context, url, error) => CircleAvatar(
//         radius: 10.w,
//         backgroundColor: Colors.indigo.shade900,
//         child: CircleAvatar(
//           radius: 9.w,
//           backgroundColor: Colors.white,
//           backgroundImage: CachedNetworkImageProvider("https://ui-avatars.com/api/?name=" + inst['institution_name'].replaceAll("+", " ") + ".png"),
//         ),
//       ),
//       fit: BoxFit.cover,
//     );
//   }
// }
