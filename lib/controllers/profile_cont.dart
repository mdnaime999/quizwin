import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

import '../initial/app_const.dart';
import '../methords/custom_methord.dart';
import '../views/widgets/profile_update.dart';
import 'login_cont.dart';

class ProfileController extends GetxController {
  RxBool edting = false.obs;
  final ImagePicker imgPicker = ImagePicker();
  // Database
  RxMap auth = Get.find<LoginCont>().auth2.obs;
  // Text Editing Controler
  Rx<TextEditingController> proName = TextEditingController().obs;
  Rx<TextEditingController> proEmail = TextEditingController().obs;
  Rx<TextEditingController> regId = TextEditingController().obs;
  Rx<TextEditingController> school = TextEditingController().obs;
  XFile? regCard;
  RxString imgPath = "".obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void loadData() {
    proName.value.text = auth[1]['name'];
    proEmail.value.text = auth[1]['email'];
    regId.value.text = auth[1]['registration_no'] ?? "";
    school.value.text = auth[1]['school_name'] ?? "";
  }

  void profileUpdate(BuildContext context) async {
    if (proName.value.text == "") {
      Get.snackbar(
        "Worning!",
        "Name field cannot be left blank",
        backgroundColor: Colors.orange.shade300,
        margin: EdgeInsets.only(top: 10.h, left: 10.sp, right: 10.sp),
      );
    } else if (proEmail.value.text == "") {
      Get.snackbar(
        "Worning!",
        "Name field cannot be left blank",
        backgroundColor: Colors.orange.shade300,
        margin: EdgeInsets.only(top: 10.h, left: 10.sp, right: 10.sp),
      );
    } else {
      SmartDialog.showLoading(
        msg: "Profile Updating....",
        backDismiss: false,
        background: Colors.indigo.shade200,
      );
      final Uri url = Uri.parse(AppConst().baseLink + AppConst().profileUpdate);
      var request = http.MultipartRequest("POST", url);
      request.headers['Accept'] = 'application/json';
      request.headers['Authorization'] = "Bearer " + auth[0].toString();
      request.fields['user_id'] = auth[1]['id'].toString();
      request.fields['name'] = proName.value.text;
      request.fields['email'] = proEmail.value.text;
      if (school.value.text != "") {
        request.fields['school_name'] = school.value.text;
      }
      if (regId.value.text != "") {
        request.fields['registration_no'] = regId.value.text;
      }
      if (regCard != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'registration_card_photo_path',
            regCard!.path,
            filename: regCard!.path.split("/").last,
          ),
        );
      }
      await request.send().then((response) {
        if (response.statusCode == 200) {
          edting.value = false;
          SmartDialog.dismiss().then((value) {
            customDialog(
              context,
              "User Profile Update".toUpperCase(),
              ProfileUpdatePopup(),
              "Ok".toUpperCase(),
              () {
                Get.back();
                Get.find<LoginCont>().authRefresh(auth);
              },
              null,
              false,
            );
          });
        } else {
          SmartDialog.dismiss();
        }
      });
    }
  }

  void pickImage() async {
    await imgPicker.pickImage(source: ImageSource.gallery).then((response) async {
      if (response != null) {
        regCard = response;
        imgPath.value = regCard!.path;
        print(regCard!.path);
        print(regCard!.name);
      }
    });
  }
}
