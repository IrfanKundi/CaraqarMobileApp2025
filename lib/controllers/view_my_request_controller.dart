import 'package:careqar/models/request_model.dart';
import 'package:get/get.dart';

import '../enums.dart';

class ViewMyRequestController extends GetxController {
  var status = Status.initial.obs;


  Rx<Request?> request=Rx(null);


  @override
  void onInit() {
    status(Status.loading);

    // TODO: implement onInit
    super.onInit();
  }


  @override
  void onReady() {
      request.value=Get.arguments;
      status(Status.success);

    // TODO: implement onReady
    super.onReady();
  }

}
