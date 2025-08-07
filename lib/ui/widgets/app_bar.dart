

import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

buildAppBar(BuildContext context,{String? title,child,actions,isPrimaryAppBar=false}){

  return AppBar(
    centerTitle: true,
    backgroundColor:isPrimaryAppBar?kAccentColor: kWhiteColor,
    surfaceTintColor: Colors.transparent, // This removes the scroll tint
    iconTheme: IconThemeData(color:  isPrimaryAppBar? kWhiteColor: kBlackColor),
    title: child??FittedBox(
        fit: BoxFit.scaleDown,
        child:  Text((title??"").tr,style: isPrimaryAppBar? kAppBarStyle.copyWith(color: kWhiteColor) : kAppBarStyle,)),
    elevation: 0,
    actions:actions?? [],
  );
}