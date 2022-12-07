import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../controllers/expired_cont.dart';
import '../controllers/notice_cont.dart';
import '../initial/app_const.dart';
import '../initial/initial_app.dart';
import '../methords/custom_methord.dart';
import 'exam_result.dart';
import 'notice_page.dart';
import 'pages/drawer_profile.dart';
import 'pages/notification.dart';
import 'widgets/contest.dart';
import 'widgets/expired.dart';

class HomePage extends StatelessWidget {
  final InitialApp intApp = Get.find();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // print(intApp.instInfo);
    return WillPopScope(
      onWillPop: () async {
        customDialog(
          context,
          "Applition Exit ?",
          Text("Are you sure application exit ?"),
          "Exit",
          () async {
            SystemNavigator.pop(animated: true);
          },
          () => Get.back(),
          false,
        );
        return false;
      },
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          toolbarHeight: 10.h,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              scaffoldKey.currentState?.openDrawer();
            },
            icon: Icon(Icons.sort),
            color: Colors.grey,
            iconSize: 21.sp,
          ),

          title: Center(
            child: Image.asset(
              'assets/images/logo.png',
              height: 6.h,
              fit: BoxFit.contain,
            ),
          ),
          // Center(
          //   child: Obx(() {
          //     if (intApp.instInfo.isNotEmpty) {
          //       return Text(
          //         intApp.instInfo['institution_name'],
          //         maxLines: 2,
          //         style: TextStyle(
          //           fontSize: 20.sp,
          //         ),
          //       );
          //     } else {
          //       return SizedBox().paddingZero;
          //     }
          //   }),
          // ),
          actions: [
            IconButton(
              onPressed: () {
                Get.to(NotificationPage());
              },
              icon: Icon(Icons.notifications),
              color: Colors.grey,
              iconSize: 18.sp,
            ),
          ],
          bottom: TabBar(
            indicatorColor: AppConst.tabHoverBg,
            labelColor: AppConst.tabText,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
            controller: intApp.tabController,
            tabs: intApp.myTabs,
            onTap: (index) {
              if (index == 0) {
                intApp.eventReload.value
                    ? () {
                        intApp.getEvents();
                      }
                    : null;
              } else if (index == 2) {
                NoticeCont().getAllNotice();
              }
            },
          ),
        ),
        drawer: SizedBox(
          width: 100.w,
          child: DrawerProfile(),
        ),
        extendBodyBehindAppBar: false,
        backgroundColor: AppConst.backgroundColor,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              opacity: 500,
              scale: 4,
              image: AssetImage(
                "assets/images/logo.png",
              ),
            ),
          ),
          child: TabBarView(
            controller: intApp.tabController,
            children: <Widget>[
              ContestPage(),
              ExamResult(),
              Notice(),
              ExpiredPage(),
            ],
          ),
        ),
      ),
    );
  }
}

class ExpiredBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExpiredCont>(() => ExpiredCont());
  }
}
