import 'package:careqar/controllers/my_request_controller.dart';
import 'package:careqar/controllers/type_controller.dart';
import 'package:careqar/models/request_model.dart';
import 'package:careqar/models/type_model.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../enums.dart';
import '../global_variables.dart';
import 'location_controller.dart';

class AddRequestController extends GetxController {
  var status = Status.initial.obs;
  var typeStatus = Status.initial.obs;
  Request request = Request();
 // Rx<TypeModel> typeModel = Rx<TypeModel>(TypeModel());
  late TypeController typeController;
  late LocationController locationController;
  var delStatus = Status.initial.obs;
  SubType? selectedSubtype;
  Type? selectedType;
  @override
  void onInit() {
    request.purpose = EnumToString.convertToString(Purpose.Sell);
    typeController = Get.put(TypeController());
    typeController.getTypesWithSubTypes();
    locationController = Get.put(LocationController());

    // TODO: implement onInit
    super.onInit();
  }

  var formKey = GlobalKey<FormState>().obs;
  var featuresFormKey = GlobalKey<FormState>().obs;



  Future<void> deleteRequest({required Request request}) async {
    try {
      delStatus(Status.loading);
      EasyLoading.show();

      var response = await gApiProvider.get(
          path: "request/delete?requestId=${request.requestId}",
          authorization: true);

      EasyLoading.dismiss();
      response.fold((l) {
        showSnackBar(message: l.message!);
        delStatus(Status.error);
      }, (r) async {
        delStatus(Status.success);
         showSnackBar(message: r.message);
        var requestController = Get.find<MyRequestController>();
        requestController.requestModel.value.requests.remove(request);
        requestController.update();
      });
    } catch (e) {
      EasyLoading.dismiss();
      showSnackBar(message: "Error");
      delStatus(Status.error);
    }
  }

  Future<void> addRequest() async {
    try {
      if (request.cityId == null) {
        showSnackBar(message: "SelectCity");
      } else if (request.location == null) {
        showSnackBar(message: "SelectLocation");
      } else if (request.typeId == null) {
        showSnackBar(message: "SelectPropertyType");
      } else if (formKey.value.currentState!.validate()) {
        Get.focusScope?.unfocus();
        formKey.value.currentState?.save();
        status(Status.loading);
        EasyLoading.show(status: "ProcessingPleaseWait".tr);

        var response = await gApiProvider
            .post(path: "request/save", authorization: true, body: {
          "kitchens": request.typeId!>2? null: request.kitchens,
          "bedrooms": request.typeId!>2? null: request.bedrooms,
          "baths":  request.typeId!>2? null:request.baths,
          "floors":  request.typeId!>2? null:request.floors,
          "typeId": request.typeId,
          "countryId": gSelectedCountry?.countryId,
          "subTypeId": request.subTypeId,
          "purpose": request.purpose,
          "cityId": request.cityId,
          "location": request.location,
          "startPrice": request.startPrice,
          "endPrice": request.endPrice,
          "area": request.area,
          "furnished": request.typeId!>2? null:request.furnished,
          "locationId": request.locationId,
          "requestId": request.requestId,
          "phoneNumber": request.phoneNumber?.parseNumber(),
          "countryCode": request.phoneNumber?.dialCode,
          "isoCode": request.phoneNumber?.isoCode,
        });

        response.fold((l) {
          EasyLoading.showError(l.message!);
          status(Status.error);
        }, (r) async {
          Get.put(MyRequestController()).getRequests();
          //Get.find<MyRequestController>().getRequests();
          request = Request();Get.back();
          EasyLoading.showSuccess(r.message.tr);
          status(Status.success);
        });
      }
    } catch (e) {
      EasyLoading.dismiss();
      showSnackBar(message: "OperationFailed");
      status(Status.error);
    }
  }
}
