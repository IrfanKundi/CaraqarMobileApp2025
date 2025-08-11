import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/otp_controller.dart';
import 'package:careqar/global_variables.dart';
import 'package:careqar/ui/widgets/button_widget.dart';
import 'package:careqar/ui/widgets/remove_splash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreen extends GetView<OtpController> {
  @override
  Widget build(BuildContext context) {
    controller.isCompanyReg= Get.parameters["isCompanyReg"] =="true" ;
    controller.token.value= Get.parameters["token"]??"";
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

      controller.startTimeout();
    });

    return Scaffold(
     // appBar: buildAppBar(context,title: "VerifyOTP"),
      body: SafeArea(
              child:  RemoveSplash(
                  child: SingleChildScrollView(
                      child:Center(
                        child: Container(
                            padding: kScreenPadding,
                            child: Obx(() => Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  gSelectedLocale!.langCode==0? "assets/images/logo-en.png":"assets/images/logo-ar.png",
                                  width: 200.w,
                                  height: 200.w,
                                ),
                                Text("VerifyOTP".tr,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20.sp),),
                                kVerticalSpace8,
                                Text(
                                  "PleaseEnterThe6DigitsVerificationCode".tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 14.sp, color: kBlackColor)),
                                kVerticalSpace24,
                                SizedBox(
                                  width: 0.7.sw,
                                  child: PinCodeTextField(
                                      length: 4,
                                      obscureText: false,
                                      animationType: AnimationType.fade,
                                      pinTheme: PinTheme(
                                        shape: PinCodeFieldShape.circle,
                                        activeFillColor: kAccentColor,
                                        inactiveColor: kGreyColor,
                                        fieldHeight: 40.w,
                                        activeColor: kAccentColor,
                                        selectedColor: kAccentColor,
                                        inactiveFillColor: kAccentColor,
                                        selectedFillColor: kAccentColor,
                                        fieldWidth: 40.w,
                                        borderWidth: 1.5,
                                      ),
                                      showCursor: false,
                                      keyboardType: const TextInputType.numberWithOptions(
                                          decimal: false, signed: true),
                                      onChanged: (val) {},
                                      animationDuration: const Duration(milliseconds: 300),
                                      backgroundColor: Colors.transparent,
                                      textStyle: TextStyle(
                                          fontSize: 18.sp, fontWeight: FontWeight.w600),
                                      onCompleted: (v) {
                                        controller.otp.value = v;
                                        controller.verify();
                                      },
                                      beforeTextPaste: (text) {
                                        return true;
                                      },
                                      appContext: context),
                                ),
                                kVerticalSpace20,
                                controller.resendCode.value
                                    ? ButtonWidget(
                                  onPressed: () {
                                    controller.resendOtp();
                                  },
                                  text: "ResendCode",
                                )
                                    :FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    "${"ResendCodeIn".tr} ${controller.timerText}",
                                    style: TextStyle(
                                        color: kBlackColor,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              ],
                            ))),
                      )))),

    );
  }

}
