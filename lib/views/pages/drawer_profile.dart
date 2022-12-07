import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../controllers/drawer_cont.dart';
import '../../controllers/login_cont.dart';
import '../../initial/app_const.dart';
import '../../initial/initial_app.dart';
import '../../methords/custom_methord.dart';
import '../about_us.dart';
import '../../views/pages/profile.dart';

class DrawerProfile extends StatelessWidget {
  DrawerProfile({Key? key}) : super(key: key);
  // final InitialApp drawerInitApp = Get.put(InitialApp());
  final DrawerCont drawercont = Get.find();
  final auth = Get.find<LoginCont>().auth2;

  @override
  Widget build(BuildContext context) {
    // print(auth);
    return Drawer(
      backgroundColor: Colors.green.withOpacity(0.8),
      child: Column(
        // Important: Remove any padding from the ListView.
        //padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 20.h,
          ),
          Obx(
            () => Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 80.h,
                  decoration: BoxDecoration(
                    color: Colors.green[300],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                ),
                Positioned(
                  top: -18.w,
                  left: 50.w - 18.w,
                  child: Badge(
                    padding: EdgeInsets.zero,
                    elevation: 0,
                    // badgeColor: Colors.red,
                    position: BadgePosition(
                      bottom: 0,
                      end: 10.sp,
                    ),
                    badgeContent: InkWell(
                      onTap: () {
                        drawercont.getImage(context);
                      },
                      child: CircleAvatar(
                        radius: 16.sp,
                        backgroundColor: Colors.green[300],
                        child: CircleAvatar(
                          backgroundColor: Colors.grey[300],
                          child: Icon(
                            Icons.add_a_photo,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                    child: drawercont.profile[1]["full_user_photo_path"] != null
                        ? CachedNetworkImage(
                            imageUrl: drawercont.profile[1]
                                ["full_user_photo_path"],
                            imageBuilder: (context, imageProvider) =>
                                CircleAvatar(
                              radius: 18.w,
                              backgroundColor: Colors.green[300],
                              child: CircleAvatar(
                                backgroundImage: imageProvider,
                                backgroundColor:
                                    AppConst.backgroundColor.withOpacity(0.5),
                                radius: 16.5.w,
                              ),
                            ),
                            placeholder: (context, url) => CircleAvatar(
                              radius: 18.w,
                              backgroundColor: Colors.green[300],
                              child: CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                    "https://ui-avatars.com/api/?name=" +
                                        drawercont.profile[1]['name']
                                            .replaceAll("+", " ") +
                                        ".png"),
                                radius: 16.5.w,
                              ),
                            ),
                            errorWidget: (context, url, error) => CircleAvatar(
                              radius: 18.w,
                              backgroundColor: Colors.green[300],
                              child: CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                    "https://ui-avatars.com/api/?name=" +
                                        drawercont.profile[1]['name']
                                            .replaceAll("+", " ") +
                                        ".png"),
                                radius: 16.5.w,
                              ),
                            ),
                            fit: BoxFit.fitWidth,
                          )
                        : CircleAvatar(
                            radius: 18.w,
                            backgroundColor: Colors.green[300],
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: CachedNetworkImageProvider(
                                  "https://ui-avatars.com/api/?name=" +
                                      drawercont.profile[1]['name']
                                          .replaceAll("+", " ") +
                                      ".png"),
                              radius: 16.5.w,
                            ),
                          ),
                  ),
                ),
                Positioned.fill(
                  top: 20.w,
                  left: 0.w,
                  right: 0.w,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Name
                      Text(
                        '${drawercont.profile[1]["name"]}',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      // Email
                      Text(
                        '${drawercont.profile[1]["email"]}',
                        style: TextStyle(fontSize: 12.sp, color: Colors.white),
                      ),
                      SizedBox(height: 0.5.h),
                      // Phone
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.phone,
                            size: 12.sp,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 1.w,
                          ),
                          Text(
                            ' ${drawercont.profile[1]["mobile_number"]}',
                            style:
                                TextStyle(fontSize: 12.sp, color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      // Edit Botton
                      // auth[1]['profile'] == null
                      //     ? Container(
                      //         width: 100.w,
                      //         margin: EdgeInsets.symmetric(horizontal: 20.sp),
                      //         padding: EdgeInsets.all(10.sp),
                      //         decoration: BoxDecoration(
                      //           color: Colors.yellow,
                      //           borderRadius: BorderRadius.circular(10.sp),
                      //         ),
                      //         child: Row(
                      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //           children: [
                      //             Text("Importent Update"),
                      //             ElevatedButton(
                      //               style: ElevatedButton.styleFrom(
                      //                 primary: Colors.orange,
                      //               ),
                      //               onPressed: () => drawercont.impUpdate(context),
                      //               child: Text("Update Now"),
                      //             ),
                      //           ],
                      //         ),
                      //       )
                      //     : ElevatedButton.icon(
                      //         style: ElevatedButton.styleFrom(
                      //           primary: Colors.grey[700],
                      //         ),
                      //         onPressed: () => drawercont.profileEdit(context),
                      //         label: Text("Edit Profile"),
                      //         icon: Icon(Icons.edit),
                      //       ),
                      // SizedBox(height: 2.h),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 20.sp),
                                child: GestureDetector(
                                  onTap: () {
                                    Get.back();
                                    Get.to(Profile());
                                  },
                                  child: Card(
                                    child: ListTile(
                                      leading: SizedBox(
                                        width: 8.w,
                                        child: Image.asset(
                                            "assets/images/profile.png"),
                                      ),
                                      title: Text(
                                        "User Profile",
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.indigo[900],
                                        ),
                                      ),
                                      trailing: Icon(Icons.arrow_forward_ios),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Container(
                                height: 25.h,
                                width: 100.w,
                                margin: EdgeInsets.symmetric(horizontal: 20.sp),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.sp),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.3),
                                          blurRadius: 10,
                                          spreadRadius: 5)
                                    ]),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 20.sp,
                                          right: 20.sp,
                                          top: 20.sp),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(
                                            Icons.arrow_circle_up,
                                            size: 20.sp,
                                            color: AppConst.blue,
                                          ),
                                          SizedBox(width: 3.w),
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Joined Exam',
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: '\n10 times',
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    height: 1.5,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Spacer(),
                                          Icon(
                                            Icons.arrow_circle_down,
                                            size: 20.sp,
                                            color: AppConst.blue,
                                          ),
                                          SizedBox(width: 3.w),
                                          RichText(
                                              text: TextSpan(children: [
                                            TextSpan(
                                              text: 'Winner',
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: Colors.black,
                                              ),
                                            ),
                                            TextSpan(
                                              text: '\n5 times',
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                color: Colors.green.shade600,
                                                fontWeight: FontWeight.bold,
                                                height: 1.5,
                                              ),
                                            ),
                                          ])),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2.2.h,
                                    ),
                                    Divider(
                                      color: AppConst.backgroundColor
                                          .withOpacity(0.5),
                                      height: 1,
                                      thickness: 0.5,
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: 4,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              if (index == 2 || index == 3) {
                                                drawercont.goto();
                                              }
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  right: index != 3
                                                      ? 30.0.sp
                                                      : 0.sp),
                                              child: Column(
                                                children: [
                                                  Spacer(),
                                                  Image.asset(
                                                    InitialApp()
                                                            .profileImageList[
                                                        index],
                                                    height: 4.h,
                                                  ),
                                                  Text(
                                                    InitialApp()
                                                        .profileItemList[index],
                                                    style: TextStyle(
                                                        fontSize: 10.sp,
                                                        height: 1.5),
                                                  ),
                                                  Spacer(),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 20.sp),
                                child: GestureDetector(
                                  onTap: () {
                                    Get.back();
                                    Get.to(AboutUs());
                                  },
                                  child: Card(
                                    child: ListTile(
                                      title: Text(
                                        "About Competition SSC Contest",
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.indigo[900],
                                        ),
                                      ),
                                      leading: SizedBox(
                                        width: 8.w,
                                        child: Image.asset(
                                            "assets/images/about.png"),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 1.h),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 20.sp),
                                child: GestureDetector(
                                  onTap: () {
                                    customDialog(
                                      context,
                                      "Attention !!!",
                                      Text(
                                          "Are you sure logout this application"),
                                      "yes".toUpperCase(),
                                      () => InitialApp().logout(),
                                      () => Get.back(),
                                      true,
                                    );
                                  },
                                  child: Card(
                                    child: ListTile(
                                      title: Text(
                                        "Logout",
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.indigo[900],
                                        ),
                                      ),
                                      leading: SizedBox(
                                        width: 8.w,
                                        child: Image.asset(
                                            "assets/images/logout-org.png"),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 2.h),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
