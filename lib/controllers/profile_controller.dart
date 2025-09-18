import 'dart:io';

import 'package:careqar/routes.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

import '../global_variables.dart';

class ProfileController extends GetxController {
  var status = Status.initial.obs;
  var user = UserModel().obs;
  UserModel userModel = UserModel();
  Rx<PickedFile?> image = Rx(null);
  Rx<CroppedFile?> croppedImage = Rx(null);
  PackageInfo? packageInfo;

  var formKey = GlobalKey<FormState>().obs;

  // City and location observables
  var selectedCityName = ''.obs;
  var selectedLocationName = ''.obs;

  @override
  void onInit() {
    PackageInfo.fromPlatform().then((value) => packageInfo = value);
    // Get profile data first to initialize with existing user data
    getProfile();
    super.onInit();
  }

  Future<void> selectCityAndLocation() async {
    try {
      // Navigate to city selection screen
      final result = await Get.toNamed(
        Routes.selectCityScreen, // Replace with your actual route
        arguments: true, // This tells the screen to return the selection
      );

      if (result != null && result is Map) {
        // Extract city and location data
        final cityData = result['city'];
        final locationData = result['location'];

        // Update userModel with selected data
        userModel.cityId = cityData.cityId?.toString();
        userModel.cityName = cityData.name;
        userModel.locationId = locationData.locationId?.toString();
        userModel.locationName = locationData.title;

        // Update observable values for UI
        selectedCityName.value = cityData.name ?? '';
        selectedLocationName.value = locationData.title ?? '';

        print("SAHAr Selected City: ${userModel.cityName} (ID: ${userModel.cityId})");
        print("SAHAr Selected Location: ${userModel.locationName} (ID: ${userModel.locationId})");
      }
    } catch (e) {
      showSnackBar(message: "Failed to select location");
      print(" SAHAr Error selecting city/location: $e");
    }
  }

  Future<void> updateProfile() async {
    try {
      // Validate that city and location are selected
      if (userModel.cityId == null || userModel.cityId!.isEmpty) {
        showSnackBar(message: "Please select a city");
        return;
      }

      if (userModel.locationId == null || userModel.locationId!.isEmpty) {
        showSnackBar(message: "Please select a location");
        return;
      }

      if (formKey.value.currentState!.validate()) {
        Get.focusScope?.unfocus();
        status(Status.loading);
        EasyLoading.show(status: "PleaseWait".tr);

        var response = await gApiProvider.post(
          path: "user/updateProfile",
          body: {
            "email": userModel.email,
            "firstName": userModel.firstName,
            "cityId": userModel.cityId,
            "cityName": userModel.cityName,
            "locationId": userModel.locationId,
            "locationName": userModel.locationName,
          },
          authorization: true,
          isFormData: true,
        );
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
        showSnackBar(message: r.message);
        user.value.profileImage = r.data["image"];
        update(["profile"]);
      });
    } catch (e) {
      EasyLoading.dismiss();
      showSnackBar(message: "Failed");
    }
  }

  Future<void> deleteAccount() async {
    try {
      EasyLoading.show(status: "PleaseWait".tr);

      var response = await gApiProvider.post(
        path: "user/deleteAccount",
        authorization: true,
      );
      EasyLoading.dismiss();

      response.fold((l) {
        showSnackBar(message: l.message!);
      }, (r) async {
        // Clear local data before logout
        await _clearLocalData();

        await showAlertDialog(
            title: "AccountDeleted".tr,
            message: r.message ?? "Your account has been permanently deleted.".tr
        );

        Get.find<AuthController>().logout();
      });
    } catch (e) {
      EasyLoading.dismiss();
      showSnackBar(message: "DeleteAccountFailed".tr);
    }
  }

  Future<void> _clearLocalData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      print('Error clearing local data: $e');
    }
  }

  Future<void> getProfile() async {
    try {
      status(Status.loading);
      print(" SAHAr Starting getProfile API call...");

      var response = await gApiProvider.get(path: "user/getProfile", authorization: true);

      response.fold((l) {
        print(" SAHAr API Error: ${l.message}");
        showSnackBar(message: l.message!);
        status(Status.error);
      }, (r) async {
        print(" SAHAr API Success - Raw response data: ${r.data}");
        print(" SAHAr Response data type: ${r.data.runtimeType}");

        status(Status.success);

        // Create UserModel from API response
        user.value = UserModel.fromMap(r.data);
        userModel = user.value;

        // Update UI observables with loaded data
        if (user.value.cityName != null && user.value.cityName!.isNotEmpty) {
          selectedCityName.value = user.value.cityName!;
        } else {
          print(" SAHAr Warning: cityName is null or empty");
        }

        if (user.value.locationName != null && user.value.locationName!.isNotEmpty) {
          selectedLocationName.value = user.value.locationName!;
        } else {
          print(" SAHAr Warning: locationName is null or empty");
        }

        print(" SAHAr Profile loaded - City: ${selectedCityName.value}, Location: ${selectedLocationName.value}");
        print(" SAHAr UserModel state - First Name: ${user.value.firstName}, Email: ${user.value.email}");
        update(["profile"]);
      });
    } catch (e) {
      showSnackBar(message: "Error: $e");
      status(Status.error);
      print(" SAHAr getProfile error: $e");
    }
  }


}
