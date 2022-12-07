import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../controllers/written_result_cont.dart';
import '../initial/app_const.dart';

class WrittenWiseResult extends StatelessWidget {
  final WrittenResultCont writtenResultCont = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConst.backgroundColor,
      body: Column(
        children: [
          Container(
            width: 100.w,
            // height: 30.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomLeft,
                colors: [AppConst.blue, AppConst.indigo],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.sp),
                bottomRight: Radius.circular(20.sp),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(height: 2.5.h),
                Padding(
                  padding: EdgeInsets.all(10.sp),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_new_sharp,
                          color: Colors.white,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          "Event Name",
                          // resultCont.event['event_name'],
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.sp, vertical: 10.sp),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CachedNetworkImage(
                        height: 17.w,
                        width: 17.w,
                        imageUrl:
                            "https://www.pinkvilla.com/entertainment/news/janhvi-kapoor-shares-adorable-pic-furry-friend-our-hearts-are-melting-915425",
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(10.sp),
                            image: DecorationImage(
                              image: imageProvider,
                            ),
                          ),
                        ),
                        placeholder: (context, url) =>
                            Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(10.sp),
                            image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    "https://ui-avatars.com/api/?name=" +
                                        "Nazmul".replaceAll("+", " ") +
                                        ".png"),
                                fit: BoxFit.fill),
                          ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Container(
                        width: 50.w,
                        padding: EdgeInsets.all(5.sp),
                        // decoration: BoxDecoration(
                        //   border: Border.all(),
                        // ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Md. Nazmul Talukder",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "Position : 1st",
                              style: TextStyle(
                                color: Color(0xDC9E9E9E),
                                fontSize: 10.sp,
                              ),
                            ),
                            Text(
                              "Marks : 17",
                              style: TextStyle(
                                color: Color(0xDC9E9E9E),
                                fontSize: 10.sp,
                              ),
                            ),
                            Text(
                              "Duration : 250 sec",
                              style: TextStyle(
                                color: Color(0xDC9E9E9E),
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
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
                    "Marks",
                    style: TextStyle(
                      color: Colors.white,
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
                      color: Colors.white,
                      fontSize: 10.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5.sp),
              // physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: 2,
              itemBuilder: (context, index) {
                // var resultIndex = resultCont.allResult[index];
                // var position = int.parse('${resultIndex['position']}')
                // .toOrdinalNumerical();
                return ListTile(
                  leading: SizedBox(
                    width: 12.w,
                    child: CachedNetworkImage(
                      imageUrl:
                          "https://www.pinkvilla.com/entertainment/news/janhvi-kapoor-shares-adorable-pic-furry-friend-our-hearts-are-melting-915425",
                      imageBuilder: (context, imageProvider) => CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 18.sp,
                        child: CircleAvatar(
                          radius: 16.sp,
                          backgroundColor: Colors.white,
                          backgroundImage: imageProvider,
                        ),
                      ),
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 18.sp,
                        child: CircleAvatar(
                          radius: 16.sp,
                          backgroundColor: Colors.white,
                          backgroundImage: CachedNetworkImageProvider(
                              "https://ui-avatars.com/api/?name=" +
                                  "Nazmul".replaceAll("+", " ") +
                                  ".png"),
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    "Nazmul Talukder",
                    style: TextStyle(
                      color: Color(0xFFCDF009),
                      fontSize: 12.sp,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    "Position : 1st",
                    style: TextStyle(
                      color: Color(0x7C9E9E9E),
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
                          "17",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 5.w),
                      SizedBox(
                        width: 15.w,
                        child: Text(
                          "250",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
