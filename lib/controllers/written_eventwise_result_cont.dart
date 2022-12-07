// import 'dart:convert';

// import 'package:get/get.dart';

// import '../initial/app_const.dart';
// import 'login_cont.dart';

// class WrittenEventResultCont extends GetxController{
//    RxList allResult = [].obs;
//    RxMap singalResult = {}.obs;
//   RxBool noResult = false.obs;

//    @override
//   void onInit() {
//     super.onInit();
//     getAllResult();
//     getSingalResult();

    
//   }

//   void getAllResult() async {
//     var auth = Get.find<LoginCont>().auth2;
//     final Uri url = Uri.parse(AppConst().baseLink + AppConst().eventResult);
//     final headers = {
//       'Accept': 'application/json',
//       "Authorization": "Bearer " + auth[0].toString(),
//     };
//     Map apiData = {};
//     apiData['event_id'] = event['id'];
//     apiData['institution_id'] = event['institution_id'];

//     await http.post(url, body: apiData, headers: headers).then((response) {
//       if (response.statusCode == 200) {
//         var rowData = jsonDecode(response.body);
//         allResult.clear();
//         if (rowData['data'].length > 0) {
//           for (var item in rowData['data']) {
//             allResult.add(item);
//           }
//         } else {
//           noResult.value = true;
//         }
//       } else {
//         var rowData = jsonDecode(response.body);
//         print(rowData);
//       }
//     });
//   }

//   void getSingalResult() async {
//     var auth = Get.find<LoginCont>().auth2;
//     final Uri url = Uri.parse(AppConst().baseLink + AppConst().eventResultByUser);
//     final headers = {
//       'Accept': 'application/json',
//       "Authorization": "Bearer " + auth[0].toString(),
//     };
//     Map apiData = {};
//     apiData['event_id'] = event['id'];
//     apiData['institution_id'] = event['institution_id'];
//     apiData['user_id'] = auth[1]['id'].toString();
//     await http.post(url, body: apiData, headers: headers).then((response) {
//       if (response.statusCode == 200) {
//         var rowData = jsonDecode(response.body);
//         print(rowData);
//         singalResult.clear();
//         if (rowData['data'].length > 0) {
//           singalResult.addAll(rowData['data']);
//         }
//       } else {
//         var rowData = jsonDecode(response.body);
//         print(rowData);
//       }
//     });
//   }
// }