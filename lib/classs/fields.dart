import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../initial/app_const.dart';

class TextIconField extends StatelessWidget {
  TextIconField({
    this.title,
    this.icon,
    this.cont,
    this.multi = false,
    this.keybord,
    this.passType = false,
  });

  final String? title;
  final IconData? icon;
  final TextEditingController? cont;
  final bool? multi;
  final TextInputType? keybord;
  final bool passType;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.all(Radius.circular(5.sp)),
      ),
      child: TextFormField(
        controller: cont,
        cursorColor: Theme.of(context).primaryColor,
        keyboardType: multi! ? TextInputType.multiline : keybord,
        maxLines: multi! ? 5 : 1,
        obscureText: passType,
        style: TextStyle(
          fontSize: 14.sp,
          color: Theme.of(context).primaryColor,
        ),
        // keyboardType: TextInputType.name,
        decoration: InputDecoration(
          hintText: title,
          hintStyle: Theme.of(context).textTheme.bodyText1,
          border: InputBorder.none,
          icon: multi! ? null : Icon(icon, color: Theme.of(context).primaryColor, size: 20.sp),
        ),
      ),
    );
  }
}

class InputTextField extends StatelessWidget {
  InputTextField({
    this.title,
    this.textStyle,
    this.fieldtext,
    this.fieldTextStyle,
    this.cont,
    this.multi = false,
    this.multiLine,
    this.readOnly = false,
    this.keybord,
    this.passType = false,
    this.control,
    this.backColor,
  });
  final String? title;
  final TextStyle? textStyle;
  final String? fieldtext;
  final TextStyle? fieldTextStyle;
  final TextEditingController? cont;
  final bool? multi;
  final int? multiLine;
  final bool? readOnly;
  final TextInputType? keybord;
  final bool passType;
  final bool? control;
  final Color? backColor;

  final format = DateFormat("yyyy-MM-dd");

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Container(
            width: 100.w,
            decoration: BoxDecoration(
              color: AppConst.backgroundColor,
              // border: Border.all(color: tcolor),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(2.w),
                topRight: Radius.circular(2.w),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 3.sp, horizontal: 10.sp),
              child: Text(
                title!,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.sp,
                ),
              ),
            ),
          ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.sp),
          decoration: BoxDecoration(
            color: backColor ?? Colors.white,
            border: Border.all(color: AppConst.backgroundColor),
            borderRadius: title != null
                ? BorderRadius.only(
                    bottomLeft: Radius.circular(2.w),
                    bottomRight: Radius.circular(2.w),
                  )
                : BorderRadius.all(
                    Radius.circular(2.w),
                  ),
          ),
          child: TextFormField(
            controller: cont,
            cursorColor: Theme.of(context).primaryColor,
            keyboardType: multi! ? TextInputType.multiline : keybord,
            maxLines: multi! ? multiLine ?? 5 : 1,
            readOnly: readOnly!,
            obscureText: passType,
            style: textStyle ?? Theme.of(context).textTheme.bodyText1,
            enableInteractiveSelection: control ?? true,
            decoration: InputDecoration(
              hintText: fieldtext,
              hintStyle: fieldTextStyle ?? TextStyle(color: Colors.grey.shade400),
              border: InputBorder.none,
              // icon: Icon(Icons.badge_outlined, color: tcolor, size: 18.sp),
            ),
          ),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class CustomDropDown extends StatelessWidget {
  CustomDropDown({required this.items, required this.selectedItem, required this.onCh, this.color, this.fieldtext});

  final String? fieldtext;
  final Color? color;
  List<DropdownMenuItem<dynamic>> items;
  var selectedItem;
  Function(dynamic) onCh;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<dynamic>(
          dropdownColor: Color(0xFFFFFFFF),
          isExpanded: true,
          menuMaxHeight: 40.h,
          iconEnabledColor: Colors.indigo.shade900,
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
          style: Theme.of(context).textTheme.bodyText1,
          hint: Text(
            fieldtext != null ? fieldtext! : "Input Hint",
            style: TextStyle(color: Colors.grey[400], fontSize: 13.sp),
          ),
          items: items,
          value: selectedItem,
          onChanged: onCh,
        ),
      ],
    );
  }
}

class InputInConteiner extends StatelessWidget {
  InputInConteiner({
    this.title,
    this.icon,
    this.cont,
    this.multi = false,
    this.keybord,
    this.focus,
    this.passType = false,
    this.color,
    this.length,
  });

  final String? title;
  final IconData? icon;
  final TextEditingController? cont;
  final bool? multi;
  final TextInputType? keybord;
  final bool? focus;
  final bool passType;
  final Color? color;
  final int? length;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: length,
      controller: cont,
      cursorColor: color,
      keyboardType: multi! ? TextInputType.multiline : keybord,
      autofocus: focus ?? false,
      maxLines: multi! ? 5 : 1,
      obscureText: passType,
      style: TextStyle(
        fontSize: 14.sp,
        color: color,
      ),
      decoration: InputDecoration(
        hintText: title,
        hintStyle: TextStyle(color: Colors.grey),
        border: InputBorder.none,
        icon: icon != null ? Icon(icon, color: color, size: 20.sp) : null,
        counterText: "",
      ),
    );
  }
}