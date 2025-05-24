import 'package:careqar/ui/widgets/alerts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../enums.dart';
import '../global_variables.dart';
import '../routes.dart';

class SignUpController extends GetxController {
  var status = Status.initial.obs;
  var firstName = "";
  var lastName = "";
  var phoneNumber = PhoneNumber(isoCode: gSelectedCountry?.isoCode);
  var email = "";
  var password = "";
  var confirmPassword = "";

  var formKey = GlobalKey<FormState>().obs;




  Future<void> register() async {
    try {
      if (formKey.value.currentState!.validate()) {
        Get.focusScope?.unfocus();
        formKey.value.currentState?.save();
        status(Status.loading);
        EasyLoading.show(status: "ProcessingPleaseWait".tr);

        var response = await gApiProvider
            .post(path: "user/register", isFormData: true,
             body: {
          "firstName": firstName,
          "lastName": lastName,
          "email":email,
          "phoneNumber": phoneNumber.parseNumber(),
          "countryCode": phoneNumber.dialCode,
          "password": password
        });
        EasyLoading.dismiss();

        response.fold((l) {
          showSnackBar(
              message: l.message!);
          status(Status.error);
        }, (r) async {

          Get.offNamed(Routes.otpScreen,parameters: {
            "token":r.data["token"]
          });
          showSnackBar(
              message:
                  r.message);
          status(Status.success);

        });
      }
    } catch (e) {
      EasyLoading.dismiss();
      showSnackBar(message: "RegistrationFailed");
      status(Status.error);
    }
  }
}
