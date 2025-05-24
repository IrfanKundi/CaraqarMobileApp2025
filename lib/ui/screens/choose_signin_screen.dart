import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/button_widget.dart';
import 'package:careqar/ui/widgets/text_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../global_variables.dart';

class ChooseSignInScreen extends StatelessWidget{
  const ChooseSignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: kWhiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                gSelectedLocale?.langCode==0? "assets/images/logo-en.png":"assets/images/logo-ar.png",
                width: 220.w,
                height: 220.w,
              ),
              Image.asset(
                "assets/images/signin-screen.png",
                height: 250.w,
                width: 250.w,
              ),


              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                    ButtonWidget(text: "Login", onPressed: (){
                      Get.offNamed(Routes.loginScreen);

                    }),
                    kVerticalSpace8,
                    ButtonWidget(text: "Register", onPressed: (){
                      Get.offNamed(Routes.signUpScreen);

                    },outline: true,),

                    kVerticalSpace12,
                    TextButtonWidget(text: "SkipNow",color: kGreyColor,onPressed: (){
                      Get.offNamed(Routes.navigationScreen);
                    },)

                  ],
                ),
              ),

              Container(  margin: kVerticalScreenPadding,
                height: 3.w,
                width: 70.w,

                decoration: BoxDecoration(  color: kAccentColor,
                    borderRadius: kBorderRadius30
                ),
              )


            ],
          ),
        ),
      ),
    );
  }

}
