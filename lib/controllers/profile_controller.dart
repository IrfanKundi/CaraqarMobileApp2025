import 'dart:io';

import 'package:flutter/material.dart';
import 'package:careqar/controllers/auth_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/models/user_model.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../global_variables.dart';

class ProfileController extends GetxController {
  var status = Status.initial.obs;
  var user = UserModel().obs;
  UserModel userModel=UserModel();
  Rx<PickedFile?> image=Rx(null);
  Rx<CroppedFile?> croppedImage=Rx(null);
  PackageInfo? packageInfo;

  var formKey = GlobalKey<FormState>().obs;


  @override
  void onInit() {
   PackageInfo.fromPlatform().then((value) => packageInfo=value);
    super.onInit();
  }

  Future<void> updateImage(File image) async {
    try {

      EasyLoading.show(status: "PleaseWait".tr);
      var response = await gApiProvider.post(
          path: "user/updateProfileImage",
          authorization: true,
          isFormData: true,
          file: image);

      EasyLoading.dismiss();

      response.fold((l) {
        showSnackBar(message: l.message!);

      }, (r) async {


        showSnackBar(message:r.message);
        user.value.profileImage=r.data["image"];
        update(["profile"]);
      });
    } catch (e) {
      EasyLoading.dismiss();

      showSnackBar(message: "Failed");

    }
  }


  Future<void> updateProfile() async {
    try {
      if(formKey.value.currentState!.validate()) {
        Get.focusScope?.unfocus();
        status(Status.loading);
        EasyLoading.show(status: "PleaseWait".tr);

        var response = await gApiProvider.post(
          path: "user/updateProfile",
          body: {
            "email":userModel.email,
            "firstName":userModel.firstName,
           // "lastName":userModel.lastName

          },
          authorization: true,
          isFormData: true,);
        EasyLoading.dismiss();

        response.fold((l) {
          showSnackBar(message: l.message!);
          status(Status.error);
        }, (r) async {
          status(Status.success);
          showSnackBar(message: r.message);
          getProfile();
          update(["profile"]);

        });
      }
    } catch (e) {
      EasyLoading.dismiss();
      showSnackBar(message: "Failed");
      status(Status.error);
    }
  }
  Future<void> deleteAccount() async {
    try {

        EasyLoading.show(status: "PleaseWait".tr);

        var response = await gApiProvider.post(
          path: "user/deleteAccount",
          authorization: true,);
        EasyLoading.dismiss();

        response.fold((l) {
          showSnackBar(message: l.message!);
        }, (r) async {
          await showAlertDialog(title: "AccountDeleted",message: r.message);
          Get.find<AuthController>().logout();
        });
    } catch (e) {
      EasyLoading.dismiss();
      showSnackBar(message: "Failed");
    }
  }
  Future<void> getProfile() async {
    try {
      status(Status.loading);


      var response =
          await gApiProvider.get(path: "user/getProfile", authorization: true);


      response.fold((l) {
        showSnackBar(message: l.message!);
        status(Status.error);
      }, (r) async {
        status(Status.success);
        user.value = UserModel.fromMap(r.data);
        update(["profile"]);
      });
    } catch (e) {

      showSnackBar(message: "Error");
      status(Status.error);
    }
  }
}
