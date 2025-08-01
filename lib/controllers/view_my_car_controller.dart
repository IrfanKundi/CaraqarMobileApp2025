
import 'package:cached_network_image/cached_network_image.dart';
import 'package:careqar/models/car_model.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:flutter/material.dart' show precacheImage;
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
  // Add these for preloading
  var isImagesPreloaded = false.obs;
  var preloadingProgress = 0.0.obs;

  @override
  void onReady() {
      car.value=Get.arguments;
      status(Status.success);
    // TODO: implement onReady
    super.onReady();
  }

  Future<void> preloadCarImages() async {
    if (car.value?.images.isEmpty ?? true) return;

    try {
      List<String> imageUrls = car.value!.images;
      int totalImages = imageUrls.length;
      int loadedImages = 0;

      // Preload all images
      List<Future> preloadTasks = imageUrls.map((imageUrl) async {
        try {
          await precacheImage(
            CachedNetworkImageProvider(imageUrl),
            Get.context!,
          );
          loadedImages++;
          preloadingProgress.value = loadedImages / totalImages;
        } catch (e) {
          print('Failed to preload image: $imageUrl - $e');
          loadedImages++; // Still count as processed
          preloadingProgress.value = loadedImages / totalImages;
        }
      }).toList();

      // Wait for all images to load
      await Future.wait(preloadTasks);
      isImagesPreloaded.value = true;

      print('Successfully preloaded ${imageUrls.length} images');
    } catch (e) {
      print('Error preloading images: $e');
      isImagesPreloaded.value = true; // Continue anyway
    }
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
