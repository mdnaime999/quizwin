import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

import '../initial/app_const.dart';
import '../methords/custom_methord.dart';
import 'login_cont.dart';

class NoticeCont extends GetxController {
  RxList<Map<dynamic, dynamic>> allNotices = [{}].obs;
  RxBool noNotices = false.obs;

  @override
  void onInit() {
    super.onInit();
    getAllNotice();
  }

  Future<void> getAllNotice() async {
    var auth = Get.find<LoginCont>().auth2;
    final Uri url = Uri.parse(AppConst().baseLink + AppConst().notices);
    final headers = {
      'Accept': 'application/json',
      "Authorization": "Bearer " + auth[0].toString(),
    };
    Map apiData = {};
    apiData['notice_from'] = "institution";
    apiData['institute_id'] = auth[1]['institute_id'].toString();

    await http.post(url, body: apiData, headers: headers).then((response) {
      if (response.statusCode == 200) {
        var rowData = jsonDecode(response.body);
        allNotices.clear();
        if (rowData['data'].length > 0) {
          for (var item in rowData['data']) {
            allNotices.add(item);
          }
        } else {
          noNotices.value = true;
        }
      } else {
        var rowData = jsonDecode(response.body);
        noNotices.value = true;
        print(rowData);
      }
    });
    // print(allNotices);
  }

  Widget noticeDialogBody(BuildContext context, noticeContent) {
    var meadia = noticeContent['medias'];
    print(meadia.length);
    return Column(
      children: [
        if (meadia != null)
          SizedBox(
            height: 25.h,
            child: CarouselSlider.builder(
              itemCount: meadia.length,
              itemBuilder: (context, itemIndex, pageIndex) {
                return SizedBox(
                  width: 100.w,
                  child: meadia.length > 0
                      ? CachedNetworkImage(
                          imageUrl: meadia[itemIndex]['full_notice_media_path'],
                          imageBuilder: (context, imageProvider) => Image(
                            image: imageProvider,
                            fit: BoxFit.fitWidth,
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
                autoPlay: true,
                viewportFraction: 1,
              ),
            ),
          ),
        ListTile(
          title: Text(
            noticeContent['notice_description'],
          ),
        )
      ],
    );
  }

  void fullViewNotice(BuildContext context, fullNotice) {
    // print(fullNotice);
    customDialog(
      context,
      fullNotice['notice_title'],
      noticeDialogBody(context, fullNotice),
      null,
      null,
      () => Get.back(),
      true,
    );
  }
}
