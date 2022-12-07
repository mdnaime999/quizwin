import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../controllers/notice_cont.dart';
import '../initial/app_const.dart';
import 'pages/google_add.dart';

class Notice extends StatelessWidget {
  Notice({Key? key}) : super(key: key);
  final NoticeCont noticeCont = Get.put(NoticeCont());

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
            Expanded(
              child: Obx(() {
                if (noticeCont.allNotices.isNotEmpty && noticeCont.allNotices[0].isNotEmpty) {
                  return RefreshIndicator(
                    onRefresh: () => noticeCont.getAllNotice(),
                    backgroundColor: Color(0x05000000),
                    color: AppConst.tabText,
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 20.sp, horizontal: 10.sp),
                      shrinkWrap: true,
                      // physics: BouncingScrollPhysics(),
                      itemCount: noticeCont.allNotices.length,
                      itemBuilder: (context, index) {
                        var notice = noticeCont.allNotices[index];
                        var meadia = notice['medias'];
                        // print(meadia);
                        return Card(
                          elevation: 2,
                          color: Colors.white,
                          clipBehavior: ClipPath().clipBehavior,
                          child: Column(
                            children: [
                              if (meadia != null)
                                CarouselSlider.builder(
                                  itemCount: meadia.length,
                                  itemBuilder: (context, itemIndex, pageIndex) {
                                    return SizedBox(
                                      width: 100.w,
                                      child: notice['medias'].length > 0
                                          ? CachedNetworkImage(
                                              imageUrl: notice['medias'][itemIndex]['full_notice_media_path'],
                                              imageBuilder: (context, imageProvider) => Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                              placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                              errorWidget: (context, url, error) => Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "No Image",
                                                    style: TextStyle(
                                                      fontSize: 20.sp,
                                                      color: Colors.grey[800],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              fit: BoxFit.fitWidth,
                                            )
                                          : Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "No Image",
                                                  style: TextStyle(
                                                    fontSize: 20.sp,
                                                    color: Colors.grey[800],
                                                  ),
                                                ),
                                              ),
                                            ),
                                    );
                                  },
                                  options: CarouselOptions(
                                    height: 15.h,
                                    autoPlay: true,
                                    viewportFraction: 1,
                                  ),
                                ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.sp),
                                child: ListTile(
                                  // leading: CircleAvatar(
                                  //   radius: 20.sp,
                                  // ),
                                  onTap: () {
                                    noticeCont.fullViewNotice(context, notice);
                                  },
                                  title: Text(
                                    notice['notice_title'].toString(),
                                    style: TextStyle(),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Text(
                                    notice['notice_description'].toString(),
                                    style: TextStyle(),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return noticeCont.noNotices.value
                      ? Center(
                          child: Card(
                            color: Colors.white70,
                            child: Padding(
                              padding: EdgeInsets.all(10.sp),
                              child: SizedBox(
                                width: 100.w,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("No Notice"),
                                    SizedBox(height: 2.h),
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange,
                                      ),
                                      onPressed: () => noticeCont.getAllNotice(),
                                      icon: Icon(Icons.refresh),
                                      label: Text("Refresh"),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        );
                }
              }),
            ),
            BannerAdmob(),
          ],
        ),
      ),
    );
  }
}
