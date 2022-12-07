import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/login_cont.dart';

class Updater extends StatelessWidget {
  Updater({Key? key}) : super(key: key);
  final LoginCont loginController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade300,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100.w,
            height: 30.h,
            margin: EdgeInsets.all(10.sp),
            child: Obx(
              () => Card(
                child: Padding(
                  padding: EdgeInsets.all(15.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "New Version Available!",
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      SizedBox(height: 3.h),
                      Expanded(
                        child: Text(
                          "Update version (${loginController.newVersion['code']}) is available,\nPlease update this application \nYour curent version is (${loginController.appInfo.value.version})",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      Container(
                        width: 100.w,
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo[900],
                          ),
                          onPressed: () async {
                            final Uri appUrl = Uri.parse('https://play.google.com/store/apps/details?id=${loginController.appInfo.value.packageName}');
                            if (!await launchUrl(appUrl)) {
                              throw 'Could not launch $appUrl';
                            }
                          },
                          child: Text("Go for update".toUpperCase()),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
