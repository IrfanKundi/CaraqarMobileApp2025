import 'package:cached_network_image/cached_network_image.dart';
import 'package:careqar/controllers/profile_controller.dart';
import 'package:careqar/models/car_model.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:careqar/user_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';
import '../enums.dart';
import '../global_variables.dart';
import '../models/comment_model.dart';
import '../routes.dart';

class ViewCarController extends GetxController {
  var status = Status.initial.obs;
  var commentsStatus = Status.initial.obs;
  var selectedTabIndex = 0.obs;
  var sliderIndex=0.obs;

  Rx<Car?> car=Rx(null);
  List<Comment> comments=[];

  // Add these for preloading
  var isImagesPreloaded = false.obs;
  var preloadingProgress = 0.0.obs;

  @override
  void onInit() {
    status(Status.loading);

    // TODO: implement onInit
    super.onInit();
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


  Future<void> getCar(var carId) async {
    try {
      status(Status.loading);

      var response =
      await gApiProvider.get(path: "car/get?carId=$carId", authorization: true);



     return response.fold((l) {
        showSnackBar(message: l.message!);
        status(Status.error);
      }, (r) async {
        status(Status.success);
        car.value = CarModel.fromMap(r.data["cars"]).cars.first;
        if (car.value != null && car.value!.images.isNotEmpty) {
          await preloadCarImages();
        }
        getComments(carId);
        updateClicks();
      });
    } catch (e) {

      showSnackBar(message: "Error");
      status(Status.error);
    }
  }
  Future<void> getComments(var carId) async {
    try {
      commentsStatus(Status.loading);

      var response =
      await gApiProvider.get(path: "car/getComments?carId=$carId", authorization: true);



      return response.fold((l) {
        showSnackBar(message: l.message!);
        commentsStatus(Status.error);
      }, (r) async {
        comments = CommentModel.fromMap(r.data).comments;
        update(["comments"]);
        commentsStatus(Status.success);
      });
    } catch (e) {

      showSnackBar(message: "Error");
      commentsStatus(Status.error);
    }
  }
  Future<bool> updateClicks({isEmail=false,isWhatsapp=false,isCall=false}) async {
    try {



      var userId;

      if(UserSession.isLoggedIn!){
      userId=Get.find<ProfileController>().user.value.userId;
      }else{
    userId=UserSession.guestUserId;
      }


      var response = await gApiProvider
          .post(
        path: "car/updateClicks?carId=${car.value?.carId}&userId=$userId&isEmail=$isEmail&isCall=$isCall&isWhatsapp=$isWhatsapp");


      return  response.fold((l) {
        return false;
      }, (r) async {
        return true;
      });

    } catch (e) {
      return false;
    }
  }
  var comment = "";

  Future<void> deleteComment(int commentId) async {
    try {

      EasyLoading.show(status: "PleaseWait".tr);
      var response = await gApiProvider
          .post(
          path: "car/deleteComment?commentId=$commentId",authorization: true);

      EasyLoading.dismiss();

      return response.fold((l) {

        showSnackBar(message: l.message!);


      }, (r) async {
        comments.removeWhere((element) => element.commentId==commentId);
        showSnackBar(
            message: r.message, color: kSuccessColor);
      });

    } catch (e) {
      EasyLoading.dismiss();
      showSnackBar(message: "Failed");
    }
  }
  var formKey;

  Future<void> saveComment() async {
    if(UserSession.isLoggedIn!){
      try {

        if (formKey.currentState.validate()) {
          Get.focusScope?.unfocus();
          formKey.currentState.save();

          EasyLoading.show(status: "PleaseWait".tr);

          var response = await gApiProvider.post(
              path: "car/saveComment",
              body: {
                "comment": comment,
                "createdAt": DateTime.now().toString(),
                "carId":car.value?.carId},authorization: true);
          EasyLoading.dismiss();

          return response.fold((l) {

            showSnackBar(message: l.message!);


          }, (r) async {
            comment="";
            formKey.currentState.reset();
            getComments(car.value?.carId);
            // showSnackBar(
            //     message: r.message, color: kSuccessColor);

          });
        }
      } catch (e) {
        EasyLoading.dismiss();
        showSnackBar(message: "Failed");

      }
    }else{
      Get.toNamed(Routes.loginScreen);
    }

  }

  @override
  void onReady() {
    if(Get.arguments is String){
      getCar(Get.arguments);
    }else{
      car.value=Get.arguments;
      getComments(car.value?.carId);
      updateClicks();
      status(Status.success);
    }

    // TODO: implement onReady
    super.onReady();
  }

}
