import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/global_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

showSnackBar({String message = "Error", Duration? duration, color}) {
  return Get.showSnackbar(GetSnackBar(
      message: message.tr,
      duration: duration ?? const Duration(seconds: 3),
      isDismissible: true,
      backgroundColor: color ?? kBlackColor,
      dismissDirection: DismissDirection.horizontal));
}

showConfirmationDialog(
    {String? title,
    String? message,
    Duration? duration,
    color,
    String? textConfirm,
    String? textCancel,
    onConfirm,
    onCancel}) {
  return Get.defaultDialog(
      title: title!.tr,
      middleTextStyle: kTextStyle14,
      barrierDismissible: false,
      titlePadding: kScreenPadding,
      confirmTextColor: kWhiteColor,
      contentPadding: EdgeInsets.only(
        bottom: 16.w,
        left: 16.w,
        right: 16.w,
      ),
      middleText: message!.tr,
      onConfirm: onConfirm,
      backgroundColor: kWhiteColor,
      onCancel: onCancel,
      navigatorKey: gNavigatorKey,
      radius: 4.r,
      textConfirm: textConfirm?.tr ?? "Proceed".tr,
      textCancel: textCancel?.tr ?? "Cancel".tr);
}

showAlertDialog({String? title, String? message, Duration? duration}) {
  return Get.defaultDialog(
      title: title!.tr,
      middleTextStyle: kTextStyle14,
      barrierDismissible: false,
      titlePadding: kScreenPadding,
      confirmTextColor: kWhiteColor,
      contentPadding: EdgeInsets.only(
        bottom: 16.w,
        left: 16.w,
        right: 16.w,
      ),
      middleText: message!.tr,
      backgroundColor: kWhiteColor,
      buttonColor: kPrimaryColor,
      onConfirm: () {
        Navigator.pop(Get.context!);
      },
      textConfirm: "OK".tr,
      navigatorKey: gNavigatorKey,
      radius: 4.r);
}
