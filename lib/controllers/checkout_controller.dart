
import 'package:careqar/controllers/cart_controller.dart';
import 'package:careqar/models/city_model.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../enums.dart';
import '../global_variables.dart';

class CheckoutController extends GetxController {
  var status = Status.loading.obs;

  String? firstName;
  String? lastName;
  String? email;
  String? zipCode;
  String? address;
  String? coordinates;
  double? totalPrice;
  PhoneNumber phoneNumber=PhoneNumber(isoCode: gSelectedCountry?.isoCode);
  City? city;

  var formKey = GlobalKey<FormState>();



  Future<void> placeOrder() async {
    try {


      if (formKey.currentState!.validate()) {


        Get.focusScope?.unfocus();
      formKey.currentState?.save();
        status(Status.loading);
        EasyLoading.show(status: "ProcessingPleaseWait".tr);

        var response = await gApiProvider
            .post(path: "order/create",
            authorization: true,
            body: {
              "firstName":firstName,
              "lastName":lastName,
              "cityId":city?.cityId,
              "deliveryCoordinates":coordinates,
              "deliveryAddress":address,
              "totalPrice":totalPrice,
              "orderDate":DateTime.now().toString(),
              "contact":phoneNumber.phoneNumber,
              "email":email,
              "zipCode":zipCode

        });

        EasyLoading.dismiss();
        response.fold((l) {
          showSnackBar(
              message: l.message!);
          status(Status.error);
        }, (r) async {
          await    showAlertDialog(title: "Success",message: r.message);
          Get.find<CartController>().getCart();
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


