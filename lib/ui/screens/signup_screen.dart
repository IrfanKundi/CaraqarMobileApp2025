import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/signup_controller.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/button_widget.dart';
import 'package:careqar/ui/widgets/phone_number_text_field.dart';
import 'package:careqar/ui/widgets/text_button_widget.dart';
import 'package:careqar/ui/widgets/text_field_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../global_variables.dart';

class SignUpScreen extends GetView<SignUpController> {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // appBar: buildAppBar(context,title: "CreateAnAccount"),

      body: Obx(()=>
         SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Form(
              key: controller.formKey.value,
              autovalidateMode: AutovalidateMode.always,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset(
                        gSelectedLocale?.langCode==0? "assets/images/logo-en.png":"assets/images/logo-ar.png",
                        width: 200.w,
                        height: 200.w,
                      ),
                      Text("CreateAnAccount".tr,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20.sp),),
                      kVerticalSpace24,
                      TextFieldWidget(
                        text: controller.firstName,
                        labelText: "FullName",
                        onChanged: (String? val){
                          controller.firstName=val!.trim();
                        },
                        validator: (String? val){
                          val=val!.trim();
                          if(val.isEmpty) {
                            return kRequiredMsg.tr;
                          } else {
                            return null;
                          }
                        },
                      )
                      ,kVerticalSpace12,
                      PhoneNumberTextField(value: controller.phoneNumber,
                        labelText: "PhoneNumber",
                        onChanged: (PhoneNumber val){
                          controller.phoneNumber=val;
                        },
                      ),
                      kVerticalSpace12,

                      TextFieldWidget(text: controller.password,
                        labelText: "Password",
                        obscureText: true,
                        onChanged: (String? val){
                          controller.password=val!.trim();
                        },
                        validator: (String? val){
                          val=val!.trim();
                          if(val.isEmpty) {
                            return kRequiredMsg.tr;
                          } else if(val.trim().length<8)
                            {
                              return kPasswordLimitMsg.tr;
                            }
                          else
                            {
                              return null;
                            }
                        },
                      ),
                      kVerticalSpace12,
                      TextFieldWidget(
                        text: controller.email,
                        labelText: "EmailAddress",
                        onChanged: (String? val){
                          controller.email=val!.trim();
                        },
                        validator: (String? val){
                          val=val!.trim();
                          if(val.isEmpty) {
                            return null;
                          } else if(!RegExp(kEmailRegExp).hasMatch(val))
                           {
                             return kInvalidEmailMsg.tr;
                           }
                          else
                           {
                             return null;
                           }
                        },
                      ),

                     // kVerticalSpace12,
                      // Text(
                      //   'AgreeToTerms&Conditions'.tr,
                      //   style: TextStyle(color: kGreyColor, fontSize: 14.sp),
                      // ),
                       kVerticalSpace16,
                      ButtonWidget(text: "Submit", onPressed:controller.register),

                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 1.w,
                              width: 50.w,
                              color: Colors.grey.shade300,
                            ),
                            Text(
                              " ${"Or".tr} ",
                              style: TextStyle(
                                  color: kGreyColor,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                            Container(
                              height: 1.w,
                              width: 50.w,
                              color: Colors.grey.shade300,
                            ),
                          ],
                        ),
                      ),
                      ButtonWidget(text: "SignIn", onPressed: () {
                        Get.offNamed(Routes.loginScreen);

                      },color: kPrimaryColor,),
                    ],
                  ),
                  TextButtonWidget(text: "SkipNow",color: kGreyColor,onPressed: (){
                    if(Get.previousRoute==Routes.navigationScreen){
                              Get.back();
                    }else{
                      Get.offNamed(Routes.navigationScreen);
                    }

                  },)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
