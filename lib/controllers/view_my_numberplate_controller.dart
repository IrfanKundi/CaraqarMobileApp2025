import 'package:careqar/models/number_plate_model.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../enums.dart';
import '../global_variables.dart';
import 'my_numberplate_controller.dart';

class ViewMyNumberPlateController extends GetxController {
  var status = Status.initial.obs;


  var sliderIndex=0.obs;

  Rx<NumberPlate?> numberPlate=Rx<NumberPlate?>(null);

  var delStatus = Status.initial.obs;
  var refreshStatus = Status.initial.obs;
  @override
  void onInit() {
    status(Status.loading);

    // TODO: implement onInit
    super.onInit();
  }

  Future<void> refreshNumberPlate({NumberPlate? numberPlate}) async {
    try {
      refreshStatus(Status.loading);
      EasyLoading.show();

      var response =
      await gApiProvider.post(path: "numberPlate/refreshNumberPlate?numberPlateId=${numberPlate?.numberPlateId}",authorization: true);

      EasyLoading.dismiss();
      response.fold((l) {
        showSnackBar(message: l.message!);
        refreshStatus(Status.error);
      }, (r) async {
        refreshStatus(Status.success);
        showSnackBar(message: r.message);


      });
    } catch (e) {

      EasyLoading.dismiss();
      showSnackBar(message: "Error");
      refreshStatus(Status.error);
    }
  }
  Future<void> soldOutNumberPlate({NumberPlate? numberPlate}) async {
    try {
      delStatus(Status.loading);
      EasyLoading.show();

      var response =
      await gApiProvider.post(path: "numberPlate/soldOut?numberPlateId=${numberPlate?.numberPlateId}",authorization: true);

      EasyLoading.dismiss();
      response.fold((l) {
        showSnackBar(message: l.message!);

      }, (r) async {

        Get.back();
        showSnackBar(message: r.message);
        var numberPlateController=Get.find<MyNumberPlateController>();
        numberPlate?.isSold=true;
        numberPlateController.update();

      });
    } catch (e) {

      EasyLoading.dismiss();
      showSnackBar(message: "Error");
      delStatus(Status.error);
    }
  }
  Future<void> deleteNumberPlate({NumberPlate? numberPlate}) async {
    try {
      delStatus(Status.loading);
      EasyLoading.show();

      var response =
      await gApiProvider.get(path: "numberPlate/delete?numberPlateId=${numberPlate?.numberPlateId}",authorization: true);

      EasyLoading.dismiss();
      response.fold((l) {
        showSnackBar(message: l.message!);
        delStatus(Status.error);
      }, (r) async {
        delStatus(Status.success);
        Get.back();
        showSnackBar(message: r.message);
        var numberPlateController=Get.find<MyNumberPlateController>();
        numberPlateController.numberPlateModel.value.numberPlates.remove(numberPlate);
        numberPlateController.update();

      });
    } catch (e) {

      EasyLoading.dismiss();
      showSnackBar(message: "Error");
      delStatus(Status.error);
    }
  }


  @override
  void onReady() {
    numberPlate.value=Get.arguments;
    status(Status.success);

    // TODO: implement onReady
    super.onReady();
  }

}
