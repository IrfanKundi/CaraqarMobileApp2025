import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/password_controller.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/button_widget.dart';
import 'package:careqar/ui/widgets/phone_number_text_field.dart';
import 'package:careqar/ui/widgets/remove_splash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class ForgotPasswordScreen extends GetView<PasswordController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context,title: "ForgotPassword"),
      body:

      SafeArea(
        child: RemoveSplash(
            child: SingleChildScrollView(
                child:Center(
                  child: Container(
                    padding: kScreenPadding,
                    child: Obx(() => Form(
                      key: controller.forgotFormKey.value,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [

                          Text("EnterPhoneNumberToResetPassword".tr,
                              style: TextStyle(fontSize: 14.sp,color: kBlackColor)),
                          kVerticalSpace16,

                          PhoneNumberTextField(value: controller.phoneNumber,
                            onChanged: (PhoneNumber val) {
                              controller.phoneNumber=val;
                            },
                            labelText: "PhoneNumber",
                          ),
                          kVerticalSpace16,
                          ButtonWidget(text: "Send",
                            onPressed: controller.forgotPassword,),
                        ],
                      ),
                    )),
                  ),
                )))
          ),
    );
  }


}
