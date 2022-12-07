import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../initial/app_const.dart';
import 'login_cont.dart';

class WrittenEventCont extends GetxController {
  RxList allUpWrEvent = [].obs;
  RxBool noUpWrEvent = false.obs;
  @override
  void onInit() {
    super.onInit();
    getUpWrittenEvent();
  }

  void getUpWrittenEvent() async {
    var auth = Get.find<LoginCont>().auth2;
    final Uri url = Uri.parse(AppConst().baseLink + AppConst().writtenAllevents);
    final headers = {
      'Accept': 'application/json',
      "Authorization": "Bearer " + auth[0].toString(),
    };
    Map apiData = {};
    apiData['institution_id'] = auth[1]['institute_id'];
    await http.post(url, body: apiData, headers: headers).then(
      (response) {
        if (response.statusCode == 200) {
          allUpWrEvent.clear();
          DateTime cDate = DateTime.now();
          var rowData = jsonDecode(response.body);
          for (var eventItem in rowData['data']) {
            // allUpWrEvent.add(eventItem);
            DateTime wrEvEndDate = DateTime.parse(eventItem['we_end']);
            if (cDate.isBefore(wrEvEndDate)) {
              // await eventPaymentStatus(itemData['id']).then((value) {
              //   print("----------payst--------");
              //   print(value);
              //   itemData['payst'] = value;
              //   events.add(itemData);
              // });
              allUpWrEvent.add(eventItem);
            } else {
              noUpWrEvent.value = true;
            }
          }
          print(allUpWrEvent);
        } else {
          var rowData = jsonDecode(response.body);
          noUpWrEvent.value = true;
          print(rowData);
        }
      },
    );
  }
}
