import 'dart:io';

import 'package:careqar/controllers/my_bike_controller.dart';
import 'package:careqar/controllers/type_controller.dart';
import 'package:careqar/models/bike_model.dart';
import 'package:careqar/models/feature_model.dart';
import 'package:careqar/models/type_model.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../enums.dart';
import '../global_variables.dart';
import 'location_controller.dart';

class AddBikeController extends GetxController {
  var status = Status.initial.obs;
  var typeStatus = Status.initial.obs;
  var featureStatus = Status.initial.obs;
  int lang=2;
  SubType? selectedSubtype;
  Type? selectedType;
  Bike bike = Bike();
  Rx<List<dynamic>> images=Rx<List<dynamic>>([]);
 // Rx<CityModel> cityModel= Rx<CityModel>(CityModel());
 // Rx<TypeModel> typeModel= Rx<TypeModel>(TypeModel());
  Rx<FeatureModel> featureModel= Rx<FeatureModel>(FeatureModel());
  late TypeController typeController;
  late LocationController? locationController;
  var delStatus = Status.initial.obs;
  var refreshStatus = Status.initial.obs;
  List<bool> expansionIndexes = [];

  @override
  void onInit() {
    typeController = Get.find<TypeController>();
    locationController = Get.find<LocationController>();
    // TODO: implement onInit
    super.onInit();
  }

  var formKey = GlobalKey<FormState>().obs;
  var featuresFormKey = GlobalKey<FormState>().obs;


  Future<void> refreshBike({required Bike bike}) async {
    try {
      refreshStatus(Status.loading);
      EasyLoading.show();

      var response =
      await gApiProvider.post(path: "bike/refreshBike?bikeId=${bike.bikeId}",authorization: true);

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

  Future<void> soldOutBike({required Bike bike}) async {
    try {
      delStatus(Status.loading);
      EasyLoading.show();

      var response =
      await gApiProvider.post(path: "bike/soldOut?bikeId=${bike.bikeId}",authorization: true);

      EasyLoading.dismiss();
      response.fold((l) {
        showSnackBar(message: l.message!);

      }, (r) async {

        Get.back();
        showSnackBar(message: r.message);
        var bikeController=Get.find<MyBikeController>();
        bike.isSold=true;
        bikeController.update();

      });
    } catch (e) {

      EasyLoading.dismiss();
      showSnackBar(message: "Error");
      delStatus(Status.error);
    }
  }

  Future<void> deleteBike({required Bike bike}) async {
    try {
      delStatus(Status.loading);
      EasyLoading.show();

      var response =
      await gApiProvider.get(path: "bike/delete?bikeId=${bike.bikeId}",authorization: true);

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

  Future<void> getFeatures() async {
    try {

      status(Status.loading);
      EasyLoading.show();
      var response =
      await gApiProvider.get(path: "feature/GetAllFeatureHeads?typeId=${bike.typeId}&subTypeId=${bike.subTypeId}");

      EasyLoading.dismiss();
      response.fold((l) {
        showSnackBar(message: l.message!);
        featureStatus(Status.error);
      }, (r) async {
        featureStatus(Status.success);
        featureModel.value = FeatureModel.fromMap(r.data);
        expansionIndexes = List.generate(featureModel.value.featureHeads.length, (index) => false);
        update();
      });
    } catch (e) {
      EasyLoading.dismiss();
      showSnackBar(message: "Error");
      featureStatus(Status.error);
    }
  }

  Future<void> uploadImages()async{

    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true,allowCompression: true,type: FileType.custom,
    allowedExtensions: ["jpg","jpeg","png"]
    );

    if (result != null) {
      for(var item in result.files){
        images.value.add(File(item.path!));
        update();
      }

    } else {
      // User canceled the picker
    }
  }
  //
  // Future<void> addBike() async {
  //   try {
  //
  //     if( bike.cityId==null){
  //       showSnackBar(message: "SelectCity");
  //     }else if(bike.location==null){
  //      showSnackBar(message: "SelectLocation");
  //     }else if(bike.typeId==null){
  //       showSnackBar(message: "SelectBikeType");
  // } else if(images.value.isEmpty){
  //       showSnackBar(message: "UploadBikeImages");
  //     }else
  //     if (formKey.value.currentState.validate()) {
  //       Get.focusScope.unfocus();
  //       formKey.value.currentState.save();
  //       status(Status.loading);
  //       EasyLoading.show(status: "ProcessingPleaseWait".tr);
  //       var response = await gApiProvider
  //           .post(path: "bike/save",
  //           authorization: true,
  //           body: {"bike": {
  //             "BodyType": bike.bodyType,
  //             "Stroke": bike.stroke,
  //             "RefferenceNo": bike.referenceNo,
  //             "registrationCityAr": bike.registrationCityAr,
  //             "registrationCity": bike.registrationCityEn,
  //             "modelYear": modelYear,
  //             "condition": bike.condition,
  //             "brandId": bike.brandId,
  //             "color": bike.color,
  //             "mileage": bike.mileage,
  //             "seats": bike.seats,
  //             "engin": bike.engine,
  //             "isUsed": bike.isUsed,
  //             "title": bike.titleEn,
  //             "titleAr": bike.titleAr,
  //             "description": bike.descriptionEn,
  //             "descriptionAr": bike.descriptionAr,
  //             "typeId": bike.typeId,
  //             "subTypeId": bike.subTypeId,
  //             "cityId": bike.cityId,
  //             "countryId": gSelectedCountry?.countryId,
  //             "price": bike.price,
  //             "bikeId":bike.bikeId,
  //             "locationId": bike.locationId,
  //             "createdAt":bike.createdAt ?? DateTime.now(),
  //             "images":bike.images.join(",")
  //           },
  //             "bikeFeatures":bike.features.map((e) => {
  //               "featureId":e.featureId,
  //               "headId":e.headId,
  //               "quantity":e.quantity,
  //               "featureOption":e.featureOption
  //             }).toList(),
  //       });
  //
  //
  //       response.fold((l) {
  //         showSnackBar(
  //             message: l.message!);
  //         status(Status.error);
  //       }, (r) async {
  //         var imagesResponse = await gApiProvider
  //             .post(path: "bike/SaveImages",isFormData: true,
  //             authorization: true,
  //             body: {
  //               "bikeId":r.data["bikeId"].toString(),
  //
  //             },files: images.value.whereType<File>().toList());
  //         EasyLoading.dismiss();
  //         imagesResponse.fold((l) {
  //           Get.find<BikeController>().getBikes();
  //           showSnackBar(
  //               message: l.message!);
  //           status(Status.error);
  //         }, (x) async {
  //
  //      await    showAlertDialog(title: "Success",message: r.message);
  //      Get.back();
  //     Get.find<MyBikeController>().getBikes();
  //         status(Status.success);
  //         });
  //
  //       });
  //     }
  //   } catch (e) {
  //     EasyLoading.dismiss();
  //     showSnackBar(message: "OperationFailed");
  //     status(Status.error);
  //   }
  // }
}


