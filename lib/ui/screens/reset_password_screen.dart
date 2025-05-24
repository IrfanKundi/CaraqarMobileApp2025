import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/otp_controller.dart';
import 'package:careqar/controllers/password_controller.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/button_widget.dart';
import 'package:careqar/ui/widgets/remove_splash.dart';
import 'package:careqar/ui/widgets/text_button_widget.dart';
import 'package:careqar/ui/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ResetPasswordScreen extends GetView<PasswordController> {
  @override
  Widget build(BuildContext context) {
      var otpController=Get.find<OtpController>();
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {

        otpController.startTimeout();
      });
    return Scaffold(
        appBar:buildAppBar(context,title:"ResetPassword" ),
        body:

        SafeArea(
            child: RemoveSplash(
                child: SingleChildScrollView(
                    child:Center(
                        child: Container(
                            padding: kScreenPadding,
                            child:Form(
                              autovalidateMode: AutovalidateMode.always,
                                key: controller.resetFormKey.value,
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [


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
                                              keyboardType: TextInputType.numberWithOptions(
                                                  decimal: false, signed: true),
                                              onChanged: (val) { controller.otp.value = val;},
                                              animationDuration: Duration(milliseconds: 300),
                                              backgroundColor: Colors.transparent,
                                              textStyle: TextStyle(
                                                  fontSize: 18.sp, fontWeight: FontWeight.w600),
                                              onCompleted: (v) {
                                                  controller.otp.value = v;
                                              },
                                              beforeTextPaste: (text) {
                                                  return true;
                                              },
                                              appContext: context),
                                        ),
                                        kVerticalSpace16,
                              Obx(() =>   otpController.resendCode.value
                                            ? TextButtonWidget(
                                            onPressed: () {
                                                otpController.resendOtp();
                                            },
                                            text: "ResendCode",
                                        )
                                            :FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                                "${"ResendCodeIn".tr} ${otpController.timerText}",
                                                style: TextStyle(
                                                    color: kBlackColor,
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w500),
                                            ),
                                        ),),
                                      kVerticalSpace20,
                                        TextFieldWidget(
                                          text: controller.newPassword,
                                          labelText: "NewPassword",
                                          obscureText: true,onChanged: (val){
                                            controller.newPassword=val.trim();
                                        },validator: (val){
                                            if(val!.trim().isEmpty){
                                                return kPasswordReqMsg.tr;
                                            }

                                            else if(val.trim().length<8)
                                              return kPasswordLimitMsg.tr;
                                            return null;
                                        },),
                                        kVerticalSpace12,
                                        TextFieldWidget(
                                          text: controller.confirmPassword,
                                          labelText: "ConfirmPassword",obscureText: true,onChanged: (val){
                                            controller.confirmPassword=val.trim();
                                        },validator: (val){
                                            val=val!.trim();
                                            if(val.isEmpty){
                                                return kPasswordReqMsg.tr;
                                            }else if(val!=controller.newPassword){
                                                return kPasswordNotMatchMsg.tr;
                                            }
                                            return null;
                                        },),
                                        kVerticalSpace16,
                              Obx(() =>  ButtonWidget(text: "Reset".toUpperCase(),
                                            onPressed: controller.otp.value.isNotEmpty? controller.resetPassword:(){},)),
                                    ],
                                ),
                            )
                        ),
                    )))
                ),

    );
  }


}
