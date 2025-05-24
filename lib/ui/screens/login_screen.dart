  import 'dart:io';

import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/login_controller.dart';
import 'package:careqar/controllers/social_signin_controller.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/button_widget.dart';
import 'package:careqar/ui/widgets/phone_number_text_field.dart';
import 'package:careqar/ui/widgets/text_button_widget.dart';
import 'package:careqar/ui/widgets/text_field_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../global_variables.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: buildAppBar(context,title: "LoginToCrimson"),

      body: Obx(()=>
         SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 32.w,),
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
                        Text("LoginToContinue".tr,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20.sp),),
                      kVerticalSpace24,

                      PhoneNumberTextField(value: controller.phoneNumber,
                        labelText: "PhoneNumber",
                        onChanged: (PhoneNumber val){
                          controller.phoneNumber=val;
                        },
                      ),
                      kVerticalSpace12,
                      TextFieldWidget(text: controller.password,
                        labelText: "Password",
                        prefixIcon: Icon(SimpleLineIcons.lock,size: 16.sp,),
                        obscureText: true,
                        onChanged: (String val){
                          controller.password=val.trim();
                        },
                        validator: (String? val){
                          val=val?.trim();
                          if(val!.isEmpty)
                            return kRequiredMsg.tr;
                          else
                            return null;
                        },
                      ),
                      Align(
                          alignment: Alignment.centerRight,
                          child: TextButtonWidget(text: "ForgotPassword",onPressed: (){
                            Get.toNamed(Routes.forgotPasswordScreen);
                          },)),
                      kVerticalSpace8,
                      ButtonWidget(text: "SignIn", onPressed: controller.login,),

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
                      ButtonWidget(text: "SignUp", onPressed: () {
                        Get.offNamed(Routes.signUpScreen);

                      },color: kPrimaryColor,),
                      kVerticalSpace8,
                  InkWell(
                    onTap: (){
                    Get.find<SocialSignInController>().signInWithGoogle();
                    },
                    child: Container(
                      height: 40.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: kBorderRadius30,
                          border: Border.all(color: kBorderColor,width: 1.w)
                      ),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/google.png",width: 20.w,height: 20.w,fit: BoxFit.scaleDown,),
                          kHorizontalSpace8,
                          Text("SignInWithGoogle".tr,style: kTextStyle16,),
                        ],
                      ),

                    ),
                  ),
                      kVerticalSpace8,

                      InkWell(
                        onTap: (){
                          Get.find<SocialSignInController>().signInWithFacebook();
                          },
                        child: Container(
                          height: 40.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: kBorderRadius30,
                              border: Border.all(color: kBorderColor,width: 1.w)
                          ),
                          child: Row(mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(MaterialCommunityIcons.facebook,color: Colors.blueAccent),
                              kHorizontalSpace8,
                              Text("SignInWithFacebook".tr,style: kTextStyle16,),
                            ],
                          ),

                        ),
                      ),

                      if(Platform.isIOS)
                        Column(
                          children: [
                            kVerticalSpace8,
                            InkWell(
                              onTap: (){
                                Get.find<SocialSignInController>().signInWithApple();
                              },
                              child: Container(
                                height: 40.h,
                                alignment: Alignment.center,
                                child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(MaterialCommunityIcons.apple,color: Colors.black),
                                    kHorizontalSpace8,
                                    Text("SignInWithApple".tr,style: kTextStyle16,),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: kBorderRadius30,
                                    border: Border.all(color: kBorderColor,width: 1.w)
                                ),

                              ),
                            ),

                          ],
                        ),



                    ],
                  ),
                  TextButtonWidget(text: "SkipNow",color: kGreyColor,onPressed: (){
                    if(Get.previousRoute==Routes.navigationScreen){
                      try{
                        Navigator.of(context).pop();
                      }catch(e){
                        print(e);
                      }

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
