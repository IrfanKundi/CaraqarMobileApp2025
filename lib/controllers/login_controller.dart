import 'package:careqar/constants/colors.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../enums.dart';
import '../global_variables.dart';
import '../routes.dart';
import 'auth_controller.dart';

class LoginController extends GetxController {
  var status = Status.initial.obs;
  var phoneNumber = PhoneNumber(isoCode: gSelectedCountry?.isoCode);
  var password = "";

  var formKey = GlobalKey<FormState>().obs;


  Future<void> login() async {
    try {
      if (formKey.value.currentState!.validate()) {
        Get.focusScope?.unfocus();
        formKey.value.currentState?.save();
        status(Status.loading);
        EasyLoading.show(status: "AuthenticatingPleaseWait".tr);

        var response = await gApiProvider.post(
            path: "user/login",
            body: {"phoneNumber": phoneNumber.parseNumber(),
              "countryCode":phoneNumber.dialCode,
              "password": password});
        EasyLoading.dismiss();

        response.fold((l) {
          if (l.errorCode == 401 &&
              (l.data["token"] != null)) {
            status(Status.success);
            Get.offNamed(Routes.otpScreen, arguments: l.data["token"]);
            showSnackBar(message: l.message!);
          } else {
            showSnackBar(message: l.message!);
            status(Status.error);
          }
        }, (r) async {
          status(Status.success);
          await Get.find<AuthController>()
              .createSession(r.data["token"]);
          Get.offNamedUntil(Routes.navigationScreen, (route) => false);
          showSnackBar(
              message: r.message, color: kSuccessColor);
        });
      }
    } catch (e) {
      EasyLoading.dismiss();
      showSnackBar(message: "LoginFailed");
      status(Status.error);
    }
  }



}
