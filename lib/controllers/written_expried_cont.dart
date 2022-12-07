import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../initial/app_const.dart';
import 'login_cont.dart';

class WrittenExpriedCont extends GetxController {
  RxList allExpWrEvent = [].obs;
  RxBool noExpWrEvent = false.obs;

  @override
  void onInit() {
    super.onInit();
    getExpWrittenEvent();
  }

  void getExpWrittenEvent() async {
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
          allExpWrEvent.clear();

          DateTime cDate = DateTime.now();
          var rowData = jsonDecode(response.body);
          for (var eventItem in rowData['data']) {
            DateTime wrEvEndDate = DateTime.parse(eventItem['we_end']);
            if (cDate.isAfter(wrEvEndDate)) {
              allExpWrEvent.add(eventItem);
            } else {
              noExpWrEvent.value = true;
            }
          }
          print(allExpWrEvent);
        } else {
          var rowData = jsonDecode(response.body);
          noExpWrEvent.value = true;
          print(rowData);
        }
      },
    );
  }
}
