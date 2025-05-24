import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

 initEasyLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 3000)
    ..indicatorType = EasyLoadingIndicatorType.circle
    ..indicatorSize =  40.w
    ..radius = 10.r
    ..successWidget = Icon(
      MaterialCommunityIcons.check_circle_outline,
      color: Colors.green,
      size: 50.sp,
    )
    ..errorWidget = Icon(
      MaterialCommunityIcons.close_circle_outline,
      color: Colors.red,
      size: 50.sp,
    )
    ..infoWidget = Icon(
      MaterialCommunityIcons.information_outline,
      color: Colors.lightBlueAccent,
      size: 50.sp,
    )
    ..maskType = EasyLoadingMaskType.black
    ..toastPosition = EasyLoadingToastPosition.bottom
    ..fontSize = 14.sp
    ..maskColor = Colors.black38
    ..userInteractions = false
    ..dismissOnTap = false;

  return EasyLoading.init();
}
