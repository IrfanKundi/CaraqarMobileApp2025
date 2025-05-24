

import 'package:careqar/controllers/add_request_controller.dart';
import 'package:careqar/models/request_model.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:get/get.dart';
import 'package:careqar/user_session.dart';

import '../enums.dart';
import '../global_variables.dart';

class MyRequestController extends GetxController {
  var status = Status.initial.obs;
  Rx<RequestModel> requestModel = Rx<RequestModel>(RequestModel());

  bool isGridView=true;
  @override
  void onInit() {
    Get.put(AddRequestController());
    // TODO: implement onInit
    super.onInit();
  }

  Future<void> getRequests() async {

      if(UserSession.isLoggedIn!){
        try {
        status(Status.loading);
        var response =
        await gApiProvider.get(path: "request/get", authorization: true);
        response.fold((l) {
          showSnackBar(message: l.message!);
          status(Status.error);
        }, (r) async {
          status(Status.success);
          requestModel.value = RequestModel.fromMap(r.data);
          update();
        });
      } catch (e) {

      showSnackBar(message: "Error");
      status(Status.error);
    }
      }

  }
}
