import 'dart:async';

import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../enums.dart';
import '../global_variables.dart';
import 'auth_controller.dart';

class OtpController extends GetxController {


  bool isCompanyReg=false;
  var status = Status.initial.obs;
  var otp = "".obs;
  var token = "".obs;
  var resendCode = false.obs;
  var endTime =  DateTime.now().millisecondsSinceEpoch + 1000 * 60;
  final interval = const Duration(seconds: 1);

  final int timerMaxSeconds = 60;
  Rx<Timer?> timer=Rx(null);
  var currentSeconds = 0.obs;

  String get timerText =>
      '${((timerMaxSeconds - currentSeconds.value) ~/ 60).toString().padLeft(2, '0')}: ${((timerMaxSeconds - currentSeconds.value) % 60).toString().padLeft(2, '0')}';

  startTimeout() {
    if(timer.value!=null){
      timer.value?.cancel();
    }
    timer.value = Timer.periodic(interval, (timer) {
        currentSeconds.value = timer.tick;
        resendCode.value=false;
        if (timer.tick >= timerMaxSeconds) {
          timer.cancel();
          currentSeconds(0);
            resendCode.value=true;
        }
    });
  }




  Future<void> verify() async {
    try {
      if (otp.value.isNotEmpty) {
        Get.focusScope?.unfocus();
        status(Status.loading);
        EasyLoading.show(status: "VerifyingPleaseWait".tr);

        var response = await gApiProvider.post(
            path: "user/verifyPhoneNumber",
            body: {
              "otp": otp.value,
            },);
        EasyLoading.dismiss();

        response.fold((l) {
          showSnackBar(message: l.message!);
          status(Status.error);
        }, (r) async {
          status(Status.success);
          await Get.find<AuthController>().createSession(r.data["accessToken"]);
          Get.offNamedUntil(Routes.navigationScreen, (route) => false);
          showSnackBar(message: r.message);
        });
      }
    } catch (e) {
      EasyLoading.dismiss();
      showSnackBar(message: "VerificationFailed");
      status(Status.error);
    }
  }

  Future<void> resendOtp() async {
    try {
      Get.focusScope?.unfocus();
      status(Status.loading);
      EasyLoading.show(status: "PleaseWait".tr);

      var response = await gApiProvider.get(
          path: "user/resendOtp",

      accessToken: token.value,authorization: true);
      EasyLoading.dismiss();

      response.fold((l) {
        showSnackBar(message: l.message!);
        status(Status.error);
      }, (r) async {
        startTimeout();
        status(Status.success);
        showSnackBar(message: r.message);
      });
    } catch (e) {
      EasyLoading.dismiss();
      showSnackBar(message: "SendingFailed");
      status(Status.error);
    }
  }
}
