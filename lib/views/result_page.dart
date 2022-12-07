import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:humanizer/humanizer.dart';

import '../controllers/result_cont.dart';
import '../initial/app_const.dart';
import '../initial/initial_app.dart';

class Result extends StatelessWidget {
  Result({Key? key}) : super(key: key);
  final ResultCont resultCont = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: 10.sp, right: 10.sp, top: 40.sp, bottom: 10.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.sp),
                      child: Text(
                        resultCont.event['event_name'],
                        style: TextStyle(
                          fontSize: 20.sp,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              // margin: EdgeInsets.only(left: 10.sp, right: 10.sp, top: 20.sp),
              decoration: BoxDecoration(
                color: Color.fromARGB(200, 255, 255, 255),
                // gradColor.fromARGB(255, 14, 13, 13)ent(
                //   begin: Alignment.topLeft,
                //   end: Alignment.bottomLeft,
                //   colors: [AppConst.blue, AppConst.indigo],
                // ),
                borderRadius: BorderRadius.all(Radius.circular(10.sp)),
              ),
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 25.sp, vertical: 7.sp),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.sp),
                      child: Obx(() {
                        if (resultCont.singalResult.isNotEmpty) {
                          var myResult = resultCont.singalResult;
                          var position = int.parse('${myResult['position']}')
                              .toOrdinalNumerical();
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: myResult['profile_picture'],
                                    imageBuilder: (context, imageProvider) =>
                                        CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 30.sp,
                                      child: CircleAvatar(
                                        radius: 28.sp,
                                        backgroundColor: Colors.white,
                                        backgroundImage: imageProvider,
                                      ),
                                    ),
                                    placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 30.sp,
                                      child: CircleAvatar(
                                        radius: 28.sp,
                                        backgroundColor: Colors.white,
                                        backgroundImage: CachedNetworkImageProvider(
                                            "https://ui-avatars.com/api/?name=" +
                                                myResult['name']
                                                    .replaceAll("+", " ") +
                                                ".png"),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: -7.sp,
                                    right: -0.sp,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 20,
                                      child: CircleAvatar(
                                        foregroundColor: Colors.green,
                                        backgroundColor: Colors.orange,
                                        radius: 18,
                                        child: Text(
                                          position,
                                          style: TextStyle(fontSize: 8.sp),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              // CachedNetworkImage(
                              //   height: 17.w,
                              //   width: 17.w,
                              //   imageUrl: myResult['profile_picture'],
                              //   imageBuilder: (context, imageProvider) =>
                              //       Container(
                              //     decoration: BoxDecoration(
                              //       // border: Border.all(color: Colors.white),
                              //       // borderRadius: BorderRadius.circular(10.sp),
                              //       image: DecorationImage(
                              //         image: imageProvider,
                              //       ),
                              //     ),
                              //   ),
                              //   placeholder: (context, url) =>
                              //       Center(child: CircularProgressIndicator()),
                              //   errorWidget: (context, url, error) => Container(
                              //     decoration: BoxDecoration(
                              //       // border: Border.all(color: Colors.white),
                              //       // borderRadius:
                              //       //     BorderRadius.circular(10.sp),
                              //       image: DecorationImage(
                              //         image: CachedNetworkImageProvider(
                              //             "https://ui-avatars.com/api/?name=" +
                              //                 myResult['name']
                              //                     .replaceAll("+", " ") +
                              //                 ".png"),
                              //         fit: BoxFit.cover,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              SizedBox(width: 4.w),
                              Container(
                                width: 50.w,
                                // padding: EdgeInsets.symmetric(horizontal: 10.sp),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(3.sp),
                                    topRight: Radius.circular(10.sp),
                                    bottomLeft: Radius.circular(10.sp),
                                    bottomRight: Radius.circular(3.sp),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(3.0, 3.0),
                                        blurRadius: 5.0,
                                        spreadRadius: 2.0),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.sp, vertical: 11.sp),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        myResult['name'],
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.sp,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      // Text(
                                      //   "Position : " + position,
                                      //   style: TextStyle(
                                      //     color: Color(0xFB9E9E9E),
                                      //     fontSize: 10.sp,
                                      //   ),
                                      // ),
                                      Text(
                                        "Mark : ${myResult['total_mark']}",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 10.sp,
                                        ),
                                      ),
                                      Text(
                                        "Duration : ${myResult['total_time']} sec",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 10.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return resultCont.noResult.value
                              ? Card(
                                  color: Colors.yellow,
                                  child: Padding(
                                    padding: EdgeInsets.all(10.sp),
                                    child: Text(
                                        "You are not attend this event exam"),
                                  ),
                                )
                              : CircularProgressIndicator();
                        }
                      }),
                    )
                  ],
                ),
              ),
            ),
            Obx(() {
              if (resultCont.allResult.isNotEmpty) {
                return Container(
                  padding: EdgeInsets.only(
                    top: 10.sp,
                    bottom: 5.sp,
                    right: 15.sp,
                  ),
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 10.w,
                        child: Text(
                          "Mark",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 5.w),
                      SizedBox(
                        width: 15.w,
                        child: Text(
                          "Duration",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return SizedBox();
              }
            }),
            Expanded(
              child: Obx(() {
                if (resultCont.allResult.isNotEmpty) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.sp),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: resultCont.allResult.length,
                      itemBuilder: (context, index) {
                        var resultIndex = resultCont.allResult[index];
                        var position = int.parse('${resultIndex['position']}')
                            .toOrdinalNumerical();
                        return Column(
                          children: [
                            Divider(
                              height: 2,
                              thickness: 2,
                            ),
                            ListTile(
                              dense: true,
                              visualDensity: VisualDensity(vertical: -2),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 0),
                              leading: SizedBox(
                                width: 12.w,
                                child: CachedNetworkImage(
                                  imageUrl: resultIndex['profile_picture'],
                                  imageBuilder: (context, imageProvider) =>
                                      CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 15.sp,
                                    child: CircleAvatar(
                                      radius: 13.sp,
                                      backgroundColor: Colors.white,
                                      backgroundImage: imageProvider,
                                    ),
                                  ),
                                  placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 16.sp,
                                    child: CircleAvatar(
                                      radius: 14.sp,
                                      backgroundColor: Colors.white,
                                      backgroundImage: CachedNetworkImageProvider(
                                          "https://ui-avatars.com/api/?name=" +
                                              resultIndex['name']
                                                  .replaceAll("+", " ") +
                                              ".png"),
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                resultIndex['name'],
                                style: TextStyle(
                                  color: Colors.indigo[800],
                                  fontSize: 12.sp,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                "Position : $position",
                                style: TextStyle(
                                  color: Color.fromRGBO(8, 8, 8, 0.875),
                                  fontSize: 11.sp,
                                ),
                              ),
                              trailing: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 10.w,
                                    child: Text(
                                      resultIndex['total_mark'].toString(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 10.sp,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5.w),
                                  SizedBox(
                                    width: 15.w,
                                    child: Text(
                                      resultIndex['total_time'].toString() +
                                          " sec",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 10.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                } else {
                  return resultCont.noResult.value
                      ? Center(
                          child: Card(
                            color: Colors.yellow,
                            child: Padding(
                              padding: EdgeInsets.all(10.sp),
                              child: Text("No Result"),
                            ),
                          ),
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultBinding implements Bindings {
  ResultBinding({this.event});
  final event;
  @override
  void dependencies() {
    Get.lazyPut<InitialApp>(() => InitialApp());
    Get.lazyPut<ResultCont>(() => ResultCont(event: event));
  }
}
