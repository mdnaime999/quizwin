import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../controllers/written_result_cont.dart';
import '../initial/app_const.dart';
import 'written_eventwise_result.dart';

class WrittenResult extends StatelessWidget {
  WrittenResult({Key? key}) : super(key: key);
  final WrittenResultCont writtenResultCont = Get.put(WrittenResultCont());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConst.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Padding(
              padding: EdgeInsets.all(5.sp),
              child: Icon(Icons.arrow_back_ios_new_sharp),
            ),
          ),
          Text(
            'Written Exam Result',
            style: TextStyle(fontSize: 18.sp),
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {},
          ),
        ]),
      ),
      body: Obx(() {
        if (writtenResultCont.writtenAllResult.isNotEmpty && writtenResultCont.writtenAllResult[0].isNotEmpty) {
          return ListView.builder(
            padding: EdgeInsets.all(10.sp),
            // physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: writtenResultCont.writtenAllResult.length,
            itemBuilder: (context, index) {
              var writtenEvent = writtenResultCont.writtenAllResult[index];
              return Container(
                margin: EdgeInsets.symmetric(vertical: 5.sp),
                padding: EdgeInsets.all(10.sp),
                decoration: BoxDecoration(
                  // color: Color(0xff282449).withOpacity(0.8),
                  border: Border.all(
                    color: Colors.yellow,
                  ),
                  borderRadius: BorderRadius.circular(10.sp),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.yellow,
                  //     blurRadius: 3,
                  //     spreadRadius: 2,
                  //     offset: Offset(3, 2),
                  //   )
                  // ],
                ),
                child: ListTile(
                  leading: SizedBox(
                    height: 6.h,
                    child: Image.asset(
                      'assets/images/exam_icon.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                  title: Text(
                    writtenEvent['written_examination_name'],
                    style: TextStyle(
                      color: Color(0xFFCDF009),
                      fontSize: 14.sp,
                    ),
                  ),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                    ),
                    child: Text(
                      "Result",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                      ),
                    ),
                    onPressed: () {
                      Get.to(
                        () => WrittenWiseResult(),
                        //binding: ResultBinding(event: event),
                        transition: Transition.zoom,
                      );
                    },
                  ),
                ),
              );
            },
          );
        } else {
          return writtenResultCont.noWrittenAllResult.value
              ? Center(
                  child: Card(
                    color: Colors.yellow,
                    child: Padding(
                      padding: EdgeInsets.all(10.sp),
                      child: Text("No Events"),
                    ),
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(),
                );
        }
      }),
    );
  }
}
