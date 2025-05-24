import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/ui/widgets/button_widget.dart';
import 'package:careqar/ui/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        iconTheme: IconThemeData(color: kBlackColor),
        backgroundColor: kWhiteColor,
        title: Text("ContactUs".tr,
          style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20.sp,color: kBlackColor),),
      ),
body: SingleChildScrollView(
  padding: kScreenPadding,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text("AskUsAnything".tr.toUpperCase(),style: kTextStyle16,),

      kVerticalSpace8,
      Text("ContactUsDescription".tr,style: kTextStyle14,),

      kVerticalSpace12,

      TextFieldWidget(hintText: "Name",),
      kVerticalSpace8,
      TextFieldWidget(hintText: "Email",),
      kVerticalSpace8,
      TextFieldWidget(hintText: "PhoneNumber",),
      kVerticalSpace8,
      TextFieldWidget(hintText: "YourMessage",maxLines: 3,),

      kVerticalSpace8,

      Text("AllFieldsAreRequired".tr,style: kTextStyle14,),
      kVerticalSpace12,
      ButtonWidget(text: "Send".tr.toUpperCase(), onPressed: (){}),

      Divider(thickness: 4.w,color: Colors.grey.shade300,height: 40.h,),
      Text("GiveUsACall".tr.toUpperCase(),style: kTextStyle16,),

      kVerticalSpace8,
      Text("FeelFreeToGiveUsAJingleOnTheFollowingNumber.".tr,style: kTextStyle14,),

      kVerticalSpace12,
      Text("Helpline".tr.toUpperCase(),textAlign: TextAlign.center,style: kTextStyle16,),

      kVerticalSpace8,
      Container(
        width: double.infinity,
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          borderRadius: kBorderRadius30,
          border: Border.all(color: kAccentColor,width: 1.w)
        ),
        child: Text("0800-343443423",textAlign: TextAlign.center,style: kTextStyle16.copyWith(color: kAccentColor),),
      ),
      kVerticalSpace12,
      Text("Doha".tr,textAlign: TextAlign.center,style: kTextStyle16,),

      kVerticalSpace8,
      Container(
        width: double.infinity,
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
            borderRadius: kBorderRadius30,
            border: Border.all(color: kAccentColor,width: 1.w)
        ),
        child: Text("343-213232232",textAlign: TextAlign.center,style: kTextStyle16.copyWith(color: kAccentColor),),
      ),

      Divider(thickness: 4.w,color: Colors.grey.shade300,height: 40.h,),
      Text("OrJustWalkIn".tr.toUpperCase(),style: kTextStyle16,),

      kVerticalSpace8,
      Text("ContactUsDescription2".tr,style: kTextStyle14,),
      kVerticalSpace12,
      ButtonWidget(text: "Map", onPressed: (){}),
      kVerticalSpace16,
      Text("DohaHeadOffice".tr,textAlign: TextAlign.center,style: kTextStyle16.copyWith(color: kAccentColor),),

      kVerticalSpace8,

      Text("lorem ipsum lorem ipsum\n lorem ipsum lorem ipsum lorem ipsum",
        textAlign: TextAlign.center,style: kTextStyle14,),


    ],
  ),
),
    );
  }
}
