import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../initial/app_const.dart';
import 'login_cont.dart';

class WrittenResultCont extends GetxController {
  RxList writtenAllResult = [].obs;
  RxBool noWrittenAllResult = false.obs;

  @override
  void onInit() {
    // ignore: todo
    // TODO: implement onInit
    super.onInit();
    getWrittenEventResult();
  }

  void getWrittenEventResult() async {
    var a2 = Get.find<LoginCont>().auth2;
    final Uri url =
        Uri.parse(AppConst().baseLink + AppConst().writtenAllevents);
    final headers = {
      'Accept': 'application/json',
      "Authorization": "Bearer " + a2[0].toString(),
    };
    Map data = {};
    data['institution_id'] = a2[1]['institute_id'];
    // print(headers);
    await http.post(url, body: data, headers: headers).then((response) async {
      // print(response.statusCode);
      if (response.statusCode == 200) {
        var rowData = jsonDecode(response.body);
        DateTime cDate = DateTime.now();
        writtenAllResult.clear();
        if (rowData['data'].length > 0) {
          for (var eventItem in rowData['data']) {
            DateTime eStartTime = DateTime.parse(eventItem['we_start']);
            if (cDate.isAfter(eStartTime)) {
              writtenAllResult.add(eventItem);
            }
          }
        } else {
          noWrittenAllResult.value = true;
        }
      } else {
        var rowData = jsonDecode(response.body);
        rowData['page'] = "written_result_cont.dart";
        rowData['function'] = "getWrittenEventResult()";
        noWrittenAllResult.value = true;
        print(rowData);
      }
    });
    print(writtenAllResult);
  }
}
