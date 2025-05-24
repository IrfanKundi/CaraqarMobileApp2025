
import 'package:careqar/models/car_model.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../enums.dart';
import '../global_variables.dart';
import 'my_car_controller.dart';

class ViewMyCarController extends GetxController {
  var status = Status.initial.obs;
  var sliderIndex=0.obs;
  var delStatus = Status.initial.obs;
  var refreshStatus = Status.initial.obs;
  Rx<Car?> car=Rx(null);

  @override
  void onReady() {
      car.value=Get.arguments;
      status(Status.success);
    // TODO: implement onReady
    super.onReady();
  }



  Future<void> refreshCar({Car? car}) async {
    try {
      refreshStatus(Status.loading);
      EasyLoading.show();

      var response =
      await gApiProvider.post(path: "car/refreshCar?carId=${car?.carId}",authorization: true);

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
  Future<void> soldOutCar({Car? car}) async {
    try {
      delStatus(Status.loading);
      EasyLoading.show();

      var response =
      await gApiProvider.post(path: "car/soldOut?carId=${car?.carId}",authorization: true);

      EasyLoading.dismiss();
      response.fold((l) {
        showSnackBar(message: l.message!);

      }, (r) async {

        Get.back();
        showSnackBar(message: r.message);
        var carController=Get.find<MyCarController>();
        car?.isSold=true;
        carController.update();

      });
    } catch (e) {

      EasyLoading.dismiss();
      showSnackBar(message: "Error");
      delStatus(Status.error);
    }
  }
  Future<void> deleteCar({Car? car}) async {
    try {
      delStatus(Status.loading);
      EasyLoading.show();

      var response =
      await gApiProvider.get(path: "car/delete?carId=${car?.carId}",authorization: true);

      EasyLoading.dismiss();
      response.fold((l) {
        showSnackBar(message: l.message!);
        delStatus(Status.error);
      }, (r) async {
        delStatus(Status.success);
        Get.back();
        showSnackBar(message: r.message);
        var carController=Get.find<MyCarController>();
        carController.carModel.value.cars.remove(car);
        carController.update();

      });
    } catch (e) {

      EasyLoading.dismiss();
      showSnackBar(message: "Error");
      delStatus(Status.error);
    }
  }

}
