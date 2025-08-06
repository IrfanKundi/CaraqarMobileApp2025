import 'package:cached_network_image/cached_network_image.dart';
import 'package:careqar/controllers/profile_controller.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:careqar/user_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';
import '../enums.dart';
import '../global_variables.dart';
import '../models/bike_model.dart';
import '../models/comment_model.dart';
import '../routes.dart';

class ViewBikeController extends GetxController {
  var status = Status.initial.obs;
  var commentsStatus = Status.initial.obs;
  var selectedTabIndex = 0.obs;
  var sliderIndex=0.obs;

  Rx<Bike?> bike=Rx(null);
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
    if (bike.value?.images.isEmpty ?? true) return;

    try {
      List<String> imageUrls = bike.value!.images;
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

  Future<void> getBike(var bikeId) async {
    try {
      status(Status.loading);

      var response =
      await gApiProvider.get(path: "bike/get?bikeId=$bikeId", authorization: true);



     return response.fold((l) {
        showSnackBar(message: l.message!);
        status(Status.error);
      }, (r) async {
        status(Status.success);
        bike.value = BikeModel.fromMap(r.data["bikes"]).bikes.first;
        getComments(bikeId);
        updateClicks();
      });
    } catch (e) {

      showSnackBar(message: "Error");
      status(Status.error);
    }
  }
  Future<void> getComments(var bikeId) async {
    try {
      commentsStatus(Status.loading);

      var response =
      await gApiProvider.get(path: "bike/getComments?bikeId=$bikeId", authorization: true);



      return response.fold((l) {
        showSnackBar(message: l.message!);
        commentsStatus(Status.error);
      }, (r) async {
        comments = CommentModel.fromMap(r.data).comments;
        if (bike.value != null && bike.value!.images.isNotEmpty) {
          await preloadCarImages();
        }
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
        path: "bike/updateClicks?bikeId=${bike.value?.bikeId}&userId=$userId&isEmail=$isEmail&isCall=$isCall&isWhatsapp=$isWhatsapp");


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
          path: "bike/deleteComment?commentId=$commentId",authorization: true);

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
              path: "bike/saveComment",
              body: {
                "comment": comment,
                "createdAt": DateTime.now().toString(),
                "bikeId":bike.value?.bikeId},authorization: true);
          EasyLoading.dismiss();

          return response.fold((l) {

            showSnackBar(message: l.message!);


          }, (r) async {
            comment="";
            formKey.currentState.reset();
            getComments(bike.value?.bikeId);
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
      getBike(Get.arguments);
    }else{
      bike.value=Get.arguments;
      getComments(bike.value?.bikeId);
      updateClicks();
      status(Status.success);
    }

    // TODO: implement onReady
    super.onReady();
  }

}
