import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class SmallButtonWidget extends StatelessWidget {

  final String text;
  final IconData? icon;
  final Function() onPressed;
  final bool elevation;
  final Color color;
  final double? width;
  final double? height;
  final bool outline;
  final BorderRadius? borderRadius;

  const SmallButtonWidget(
      {Key? key,
        required this.text,
        this.elevation=false,
        this.height,
        this.outline=false,
        this.color=kAccentColor,
        required this.onPressed,
        this.icon,
        this.width,
        this.borderRadius}):
        super(key: key);


  @override
  Widget build(BuildContext context) {
    return outline?
    SizedBox(
      width: width,
      height: height??40.h,
      child: icon==null?  OutlinedButton(
        onPressed: onPressed,
        child:   Text(text.tr,style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12.sp,letterSpacing: 0.8,
            color: kAccentColor),),
        style: OutlinedButton.styleFrom(
            foregroundColor: color,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius ?? kBorderRadius30,

            ),side: BorderSide(color: kAccentColor,width: 2.w),
            textStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,letterSpacing: 0.8,
                color: kAccentColor)),
      ):
      OutlinedButton.icon(
        onPressed: onPressed,
        label:   Text(text.tr,style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12.sp,letterSpacing: 0.8,
            color: kAccentColor),),
        icon: Icon(icon,color: kWhiteColor,size: 18.sp,),
        style: OutlinedButton.styleFrom(
            foregroundColor: color, elevation: 0,side: BorderSide(color: kAccentColor,width: 2.w),
            shape: RoundedRectangleBorder(
                borderRadius: borderRadius ?? kBorderRadius30),
            textStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,letterSpacing: 0.8,
                color: kAccentColor)),
      )
      ,
    )
        :
    SizedBox(
      width: width,
      height: height??40.h,
      child: icon==null?  ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: color,
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: borderRadius ?? kBorderRadius30),
            textStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,letterSpacing: 0.8,
                color: Colors.white)),
        child: Text(text.tr,style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12.sp,letterSpacing: 0.8,
            color: Colors.white),),
      ):
      ElevatedButton.icon(
        onPressed: onPressed,
        label:   Text(text.tr,style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12.sp,letterSpacing: 0.8,
            color: Colors.white),),
        icon: Icon(icon,color: kWhiteColor,size: 18.sp,),
        style: ElevatedButton.styleFrom(
            backgroundColor: color, elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: borderRadius ?? kBorderRadius30),
            textStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,letterSpacing: 0.8,
                color: Colors.white)),
      )
      ,
    );
  }
}

