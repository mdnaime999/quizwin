import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../controllers/result_event_cont.dart';
import '../initial/app_const.dart';
import 'result_page.dart';

class ExamResult extends StatelessWidget {
  final ResultEventCont resultEventCont = Get.put(ResultEventCont());

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
                if (resultEventCont.resultEvents.isNotEmpty && resultEventCont.resultEvents[0].isNotEmpty) {
                  return RefreshIndicator(
                    onRefresh: () => resultEventCont.getEventResult(),
                    backgroundColor: Color(0x05000000),
                    color: AppConst.tabText,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: 100.h,
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 20.sp, horizontal: 10.sp),
                        // physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: resultEventCont.resultEvents.length,
                        itemBuilder: (context, index) {
                          var event = resultEventCont.resultEvents[index];
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 5.sp),
                            padding: EdgeInsets.all(7.sp),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.white30,
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
                                  'assets/images/quiz.png',
                                  fit: BoxFit.fill,
                                ),
                              ),
                              title: Text(
                                event['event_name'],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.sp,
                                ),
                              ),
                              trailing: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                ),
                                child: Text(
                                  "Result",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.sp,
                                  ),
                                ),
                                onPressed: () {
                                  Get.to(
                                    () => Result(),
                                    binding: ResultBinding(event: event),
                                    transition: Transition.zoom,
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                } else {
                  return resultEventCont.noResultEvents.value
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
                                    Text("No Result"),
                                    SizedBox(height: 2.h),
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange,
                                      ),
                                      onPressed: () => resultEventCont.getEventResult(),
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
                          child: Text("data"),
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
