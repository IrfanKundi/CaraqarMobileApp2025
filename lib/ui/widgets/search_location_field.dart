
import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/location_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SearchLocationField extends GetView<LocationController> {
  const SearchLocationField({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> TextField(
        autofocus: true,
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.center,
        style:kTextFieldStyle,
        onChanged: (val){
          controller.searchText.value=val.trim();
          controller.searchPlaces();
        },
        textInputAction: TextInputAction.search,
        onSubmitted: controller.searchText.value.isNotEmpty? (val){
          controller.searchPlaces();
        }:null,
        decoration: InputDecoration(
          hintStyle:  Theme.of(context).textTheme.labelSmall,
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: "Search...".tr,
          contentPadding:

         EdgeInsets.only(top: 10.w,left:12.w),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kSuccessColor,width: 1.w),
            borderRadius: kBorderRadius4,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300,width: 1.w),
            borderRadius: kBorderRadius4,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kSuccessColor,width: 1.w),
            borderRadius: kBorderRadius4,
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red,width: 1.w),
            borderRadius: kBorderRadius4,
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color:Colors.grey.shade300,width: 1.w),
            borderRadius: kBorderRadius4,
          ),
        ),
      ),
    );
  }
}

