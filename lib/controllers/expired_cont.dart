import 'dart:convert';
import 'package:get/get.dart';
import '../initial/app_const.dart';
import 'login_cont.dart';
import 'package:http/http.dart' as http;

class ExpiredCont extends GetxController {
  final data;
  RxList<Map<dynamic, dynamic>> expiredevent = [{}].obs;
  RxBool noExpiredEvent = false.obs;

  ExpiredCont({this.data});
  @override
  void onInit() {
    super.onInit();
    getEvents();
  }

  Future<void> getEvents() async {
    var a2 = Get.find<LoginCont>().auth2;
    final Uri url = Uri.parse(AppConst().baseLink + AppConst().events);
    final headers = {
      'Accept': 'application/json',
      "Authorization": "Bearer " + a2[0].toString(),
    };
    Map data = {};
    data['institution_id'] = a2[1]['institute_id'].toString();
    // print(headers);
    await http.post(url, body: data, headers: headers).then((response) {
      print(response.statusCode);
      if (response.statusCode == 200) {
        expiredevent.clear();
        var rowData = jsonDecode(response.body);
        DateTime cDate = DateTime.now();
        // print(rowData);
        for (var itemData in rowData['data']) {
          DateTime eEndTime = DateTime.parse(itemData['event_end']);
          if (cDate.isAfter(eEndTime)) {
            expiredevent.add(itemData);
          }
        }
        if (expiredevent.isNotEmpty) {
          noExpiredEvent.value = false;
        } else {
          noExpiredEvent.value = true;
        }
      } else {
        var rowData = jsonDecode(response.body);
        rowData['page'] = "expired_exam.dart";
        rowData['function'] = "getEvents()";
        noExpiredEvent.value = true;
        print(rowData);
      }
    });
    update();
    // print(expiredevent);
  }
}
