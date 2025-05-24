
import 'package:careqar/models/product_model.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:careqar/user_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../enums.dart';
import '../global_variables.dart';
import '../routes.dart';

class AddToCartController extends GetxController {
  var status = Status.loading.obs;
  var choicesStatus = Status.loading.obs;


  var formKey = GlobalKey<FormState>().obs;

  Product? product;
  int quantity=1;
  double price=0;

  var sliderIndex=0.obs;
  Map<String,Set<Option>> selectedOptions={};
  ProductChoiceModel? productChoiceModel;
  @override
  void onReady() {
    if(Get.arguments is String){
    }else{
      product=Get.arguments;
      status(Status.success);
    }
    price=product!.price!;
    getChoices();


    // TODO: implement onReady
    super.onReady();
  }
  Future<void> getChoices() async {
    try {

      var response = await gApiProvider.get(path: "product/GetChoices?productId=${product?.productId}");

      await response.fold((l) {
        showSnackBar(message: l.message!);
        choicesStatus(Status.error);
      }, (r) async {
        choicesStatus(Status.success);
        selectedOptions.clear();
        productChoiceModel=ProductChoiceModel.fromJson(parsedJson: r.data);

        for (var element in productChoiceModel!.productChoices) {

          if(!element.allowMultiple!){
            selectedOptions[element.choiceId.toString()]={element.options.first};
            price+=element.options.first.price!;

          }else{
            selectedOptions[element.choiceId.toString()]={};
          }
        }


      }); update();
    } catch (e) {
      showSnackBar(message: "Error");
      choicesStatus(Status.error);update();
    }
  }
  Future<void> addToCart() async {
    try {

        if(UserSession.isLoggedIn!){
          // if (formKey.value.currentState.validate()) {
          List<int> options = [];
          for (var e in selectedOptions.values) {
            for (var e in e) {
              options.add(e.optionId!);
            }
          }

          Get.focusScope?.unfocus();
          //formKey.value.currentState.save();
          status(Status.loading);
          EasyLoading.show(status: "ProcessingPleaseWait".tr);

          var response = await gApiProvider
              .post(path: "cart/create",
              authorization: true,
              body: {
                "ProductId": product?.productId,
                "SupplierId": product?.supplierId,
                "Price": price,
                "Subtotal": (price*quantity),
                "Quantity":quantity,
                "options": options
              });

          EasyLoading.dismiss();
          response.fold((l) {
            showSnackBar(
                message: l.message!);
            status(Status.error);
          }, (r) async {
            await    showAlertDialog(title: "Success",message: r.message);
            Get.back();
          });
        }else{
          Get.toNamed(Routes.loginScreen);
        }

      // }
    } catch (e) {
      EasyLoading.dismiss();
      showSnackBar(message: "OperationFailed");
      status(Status.error);
    }
  }
}


