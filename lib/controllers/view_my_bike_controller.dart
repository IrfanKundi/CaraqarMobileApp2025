import 'package:careqar/ui/widgets/alerts.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../enums.dart';
import '../global_variables.dart';
import '../models/bike_model.dart';
import 'my_bike_controller.dart';

class ViewMyBikeController extends GetxController {
  var status = Status.initial.obs;


  var sliderIndex=0.obs;

  Rx<Bike?> bike=Rx(null);

  var delStatus = Status.initial.obs;
  var refreshStatus = Status.initial.obs;
  @override
  void onInit() {
    status(Status.loading);

    // TODO: implement onInit
    super.onInit();
  }

  Future<void> refreshBike({Bike? bike}) async {
    try {
      refreshStatus(Status.loading);
      EasyLoading.show();

      var response =
      await gApiProvider.post(path: "bike/refreshBike?bikeId=${bike?.bikeId}",authorization: true);

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
  Future<void> soldOutBike({Bike? bike}) async {
    try {
      delStatus(Status.loading);
      EasyLoading.show();

      var response =
      await gApiProvider.post(path: "bike/soldOut?bikeId=${bike?.bikeId}",authorization: true);

      EasyLoading.dismiss();
      response.fold((l) {
        showSnackBar(message: l.message!);

      }, (r) async {

        Get.back();
        showSnackBar(message: r.message);
        var bikeController=Get.find<MyBikeController>();
        bike?.isSold=true;
        bikeController.update();

      });
    } catch (e) {

      EasyLoading.dismiss();
      showSnackBar(message: "Error");
      delStatus(Status.error);
    }
  }
  Future<void> deleteBike({Bike? bike}) async {
    try {
      delStatus(Status.loading);
      EasyLoading.show();

      var response =
      await gApiProvider.get(path: "bike/delete?bikeId=${bike?.bikeId}",authorization: true);

      EasyLoading.dismiss();
      response.fold((l) {
        showSnackBar(message: l.message!);
        delStatus(Status.error);
      }, (r) async {
        delStatus(Status.success);
        Get.back();
        showSnackBar(message: r.message);
        var bikeController=Get.find<MyBikeController>();
        bikeController.bikeModel.value.bikes.remove(bike);
        bikeController.update();

      });
    } catch (e) {

      EasyLoading.dismiss();
      showSnackBar(message: "Error");
      delStatus(Status.error);
    }
  }


  @override
  void onReady() {
    bike.value=Get.arguments;
    status(Status.success);

    // TODO: implement onReady
    super.onReady();
  }

}
