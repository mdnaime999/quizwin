import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ProfileUpdatePopup extends StatelessWidget {
  const ProfileUpdatePopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            radius: 30.sp,
            backgroundColor: Colors.green,
            child: CircleAvatar(
              radius: 18.sp,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.done,
                color: Colors.green,
                size: 15.sp,
              ),
            ),
          ),
          title: Text("Successfully Updated your profile"),
        )
      ],
    );
  }
}
