import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../enums.dart';
import '../global_variables.dart';
import 'otp_controller.dart';

class PasswordController extends GetxController {
  var status = Status.initial.obs;
  var phoneNumber = PhoneNumber(isoCode: gSelectedCountry?.isoCode);
  String? newPassword = "";
  String? currentPassword = "";
  String? confirmPassword = "";
  RxString otp = "".obs;
  var token = "";

  var forgotFormKey = GlobalKey<FormState>().obs;
  var resetFormKey = GlobalKey<FormState>().obs;


  Future<void> forgotPassword() async {
    try {
      if (forgotFormKey.value.currentState!.validate()) {
        Get.focusScope?.unfocus();
        forgotFormKey.value.currentState?.save();
        status(Status.loading);
        EasyLoading.show(status: "ProcessingPleaseWait".tr);

        var response = await gApiProvider.post(
            path: "user/forgotPassword",
            body: {"phoneNumber": phoneNumber.parseNumber(),
              "countryCode":phoneNumber.dialCode});
        EasyLoading.dismiss();

        response.fold((l) {
          showSnackBar(message: l.message!);
          status(Status.error);
        }, (r) async {
          status(Status.success);
          token=r.data["token"];
          var otpController=Get.find<OtpController>();
          otpController.token.value=token;
          showSnackBar(message: r.message);
           Get.toNamed(Routes.resetPasswordScreen);
          //Get.back();
        });
      }
    } catch (e) {
      EasyLoading.dismiss();
      showSnackBar(message: "OperationFailed");
      status(Status.error);
    }
  }

  Future<void> resetPassword() async {
    try {
      if (resetFormKey.value.currentState!.validate()) {
        Get.focusScope?.unfocus();
        resetFormKey.value.currentState?.save();
        status(Status.loading);
        EasyLoading.show(status: "ProcessingPleaseWait".tr);

        var response =
            await gApiProvider.post(path: "user/resetPassword", body: {
          "otp": otp.value,
          "newPassword": newPassword,
        },accessToken: token,authorization: true);
        EasyLoading.dismiss();

        response.fold((l) {
          showSnackBar(message: l.message!);
          status(Status.error);
        }, (r) async {

          await Get.defaultDialog(
              title: "Success",
              middleText: r.message.tr,
              textCancel: "Close");
          Get.offNamedUntil(Routes.loginScreen, (route) => false);
          status(Status.success);

          currentPassword=null;
          newPassword=null;
          confirmPassword=null;

        });
      }
    } catch (e) {
      EasyLoading.dismiss();
      showSnackBar(message: "OperationFailed");
      status(Status.error);
    }
  }

  Future<void> changePassword() async {
    try {
      if (resetFormKey.value.currentState!.validate()) {
        Get.focusScope?.unfocus();
        resetFormKey.value.currentState?.save();
        status(Status.loading);
        EasyLoading.show(status: "ProcessingPleaseWait".tr);

        var response = await gApiProvider.post(
            path: "user/changePassword",
            body: {
              "currentPassword": currentPassword,
              "newPassword": newPassword
            },
            authorization: true);
        EasyLoading.dismiss();

        response.fold((l) {
          showSnackBar(
              message:l.message!);
          status(Status.error);
        }, (r) async {
          await Get.defaultDialog(
              title: "Success",
              middleText: r.message.tr,
              textCancel: "Close");
          status(Status.success);
          currentPassword=null;
          newPassword=null;
          confirmPassword=null;
          Get.back();
        });
      }
    } catch (e) {
      EasyLoading.dismiss();
      showSnackBar(message: "OperationFailed");
      status(Status.error);
    }
  }
}
