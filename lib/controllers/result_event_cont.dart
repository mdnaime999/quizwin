import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../initial/app_const.dart';
import 'login_cont.dart';

class ResultEventCont extends GetxController {
  RxList<Map<dynamic, dynamic>> resultEvents = [{}].obs;
  RxBool noResultEvents = false.obs;

  @override
  void onInit() {
    super.onInit();
    getEventResult();
  }

  Future<void> getEventResult() async {
    var a2 = Get.find<LoginCont>().auth2;
    final Uri url = Uri.parse(AppConst().baseLink + AppConst().events);
    final headers = {
      'Accept': 'application/json',
      "Authorization": "Bearer " + a2[0].toString(),
    };
    Map data = {};
    data['institution_id'] = a2[1]['institute_id'].toString();
    // print(headers);
    await http.post(url, body: data, headers: headers).then((response) async {
      // print(response.statusCode);
      if (response.statusCode == 200) {
        var rowData = jsonDecode(response.body);
        DateTime cDate = DateTime.now();
        resultEvents.clear();
        if (rowData['data'].length > 0) {
          for (var eventItem in rowData['data']) {
            DateTime eStartTime = DateTime.parse(eventItem['event_start']);
            if (cDate.isAfter(eStartTime)) {
              resultEvents.add(eventItem);
            }
          }
          noResultEvents.value = true;
        } else {
          noResultEvents.value = false;
        }
      } else {
        var rowData = jsonDecode(response.body);
        rowData['page'] = "result_event_cont.dart";
        rowData['function'] = "getEventResult()";
        noResultEvents.value = false;
        print(rowData);
      }
    });
  }
}
