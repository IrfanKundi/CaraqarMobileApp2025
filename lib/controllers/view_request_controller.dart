import 'package:careqar/models/request_model.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:get/get.dart';

import '../enums.dart';
import '../global_variables.dart';

class ViewRequestController extends GetxController {
  var status = Status.initial.obs;


  Rx<Request?> request=Rx(null);


  @override
  void onInit() {
    status(Status.loading);

    // TODO: implement onInit
    super.onInit();
  }


  Future<void> getRequest(var requestId) async {
    try {
      status(Status.loading);

      var response =
      await gApiProvider.get(path: "request/get?requestId=$requestId");



     return response.fold((l) {
        showSnackBar(message: l.message!);
        status(Status.error);
      }, (r) async {
        status(Status.success);
        request.value = RequestModel.fromMap(r.data).requests.first;

      });
    } catch (e) {

      showSnackBar(message: "Error");
      status(Status.error);
    }
  }
  @override
  void onReady() {
    if(Get.arguments is String){
      getRequest(Get.arguments);
    }else{
      request.value=Get.arguments;
      status(Status.success);
    }

    // TODO: implement onReady
    super.onReady();
  }

}
