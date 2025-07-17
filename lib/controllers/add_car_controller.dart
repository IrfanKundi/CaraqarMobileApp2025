import 'dart:io';

import 'package:careqar/controllers/car_controller.dart';
import 'package:careqar/controllers/type_controller.dart';
import 'package:careqar/models/car_model.dart';
import 'package:careqar/models/feature_model.dart';
import 'package:careqar/models/type_model.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import '../enums.dart';
import '../global_variables.dart';
import 'location_controller.dart';
import 'my_car_controller.dart';

class AddCarController extends GetxController {
  var status = Status.initial.obs;
  var typeStatus = Status.initial.obs;
  var featureStatus = Status.initial.obs;
  int lang=2;
  SubType? selectedSubtype;
  Type? selectedType;
  Car car = Car();
  Rx<List<dynamic>> images=Rx<List<dynamic>>([]);
 // Rx<CityModel> cityModel= Rx<CityModel>(CityModel());
 // Rx<TypeModel> typeModel= Rx<TypeModel>(TypeModel());
  Rx<FeatureModel> featureModel= Rx<FeatureModel>(FeatureModel());
  late TypeController typeController;
  late LocationController locationController;
  var delStatus = Status.initial.obs;
  var refreshStatus = Status.initial.obs;
  List<bool> expansionIndexes = [];

  @override
  void onInit() {
    typeController = Get.find<TypeController>();
    gVehicleType=EnumToString.convertToString(VehicleType.Car);
    typeController.getTypes();
    locationController = Get.find<LocationController>();
   // Get.find<BrandController>().getBrands(EnumToString.convertToString(VehicleType.Car));
    // TODO: implement onInit
    super.onInit();
  }

  var formKey = GlobalKey<FormState>().obs;
  var featuresFormKey = GlobalKey<FormState>().obs;


  Future<void> refreshCar({required Car car}) async {
    try {
      refreshStatus(Status.loading);
      EasyLoading.show();

      var response =
      await gApiProvider.post(path: "car/refreshCar?carId=${car.carId}",authorization: true);

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

  Future<void> soldOutCar({required Car car}) async {
    try {
      delStatus(Status.loading);
      EasyLoading.show();

      var response =
      await gApiProvider.post(path: "car/soldOut?carId=${car.carId}",authorization: true);

      EasyLoading.dismiss();
      response.fold((l) {
        showSnackBar(message: l.message!);

      }, (r) async {

        Get.back();
        showSnackBar(message: r.message);
        var carController=Get.find<MyCarController>();
        car.isSold=true;
        carController.update();

      });
    } catch (e) {

      EasyLoading.dismiss();
      showSnackBar(message: "Error");
      delStatus(Status.error);
    }
  }

  Future<void> deleteCar({required Car car}) async {
    try {
      delStatus(Status.loading);
      EasyLoading.show();

      var response =
      await gApiProvider.get(path: "car/delete?carId=${car.carId}",authorization: true);

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

  Future<void> getFeatures() async {
    try {

      status(Status.loading);
      EasyLoading.show();
      var response =
      await gApiProvider.get(path: "feature/GetAllFeatureHeads?typeId=${car.typeId}&isVehicle=true");

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

// Add this compression function to your class
// Add this compression function to your class
  Future<File?> compressAndConvertToWebP(File originalFile) async {
    try {
      // Read original image bytes
      final bytes = await originalFile.readAsBytes();

      // Decode image (jpg, png, etc.)
      final image = img.decodeImage(bytes);
      if (image == null) return null;

      // Encode to JPEG with quality control (quality: 40)
      final compressedBytes = img.encodeJpg(image, quality: 40);

      // Get temp directory
      final dir = await getTemporaryDirectory();

      // Generate new file path
      final filename = path.basenameWithoutExtension(originalFile.path);
      final compressedPath = path.join(dir.path, '${filename}.jpg');

      // Write to file
      final compressedFile = File(compressedPath);
      await compressedFile.writeAsBytes(compressedBytes);

      return compressedFile;
    } catch (e) {
      print('Compression error: $e');
      return null;
    }
  }

// Compress multiple images
  Future<List<File>> compressImages(List<File> originalImages) async {
    List<File> compressedImages = [];

    for (File image in originalImages) {
      final compressedImage = await compressAndConvertToWebP(image);
      if (compressedImage != null) {
        compressedImages.add(compressedImage);
      }
    }

    return compressedImages;
  }

  Future<void> uploadImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        allowCompression: true,
        type: FileType.custom,
        allowedExtensions: ["jpg", "jpeg", "png"]
    );

    if (result != null) {
      for (var item in result.files) {
        images.value.add(File(item.path!));
        update();
      }
    } else {
      // User canceled the picker
    }
  }

  Future<void> addCar() async {
    try {
      if (car.cityId == null) {
        showSnackBar(message: "SelectCity");
      } else if (car.typeId == null) {
        showSnackBar(message: "SelectCarType");
      } else if (images.value.isEmpty) {
        showSnackBar(message: "UploadCarImages");
      } else if (formKey.value.currentState!.validate()) {
        Get.focusScope?.unfocus();
        formKey.value.currentState?.save();
        status(Status.loading);
        EasyLoading.show(status: "ProcessingPleaseWait".tr);

        var response = await gApiProvider.post(
            path: "car/save",
            authorization: true,
            body: {
              "car": {
                "model": car.modelYear,
                "condition": car.condition,
                "brandId": car.brandId,
                "fuelType": car.fuelType,
                "transmission": car.transmission,
                "color": car.color,
                "mileage": car.mileage,
                "seats": car.seats,
                "engin": car.engine,
                "title": car.titleEn,
                "titleAr": car.titleAr,
                "description": car.descriptionEn,
                "descriptionAr": car.descriptionAr,
                "typeId": car.typeId,
                "cityId": car.cityId,
                "countryId": gSelectedCountry?.countryId,
                "price": car.price,
                "carId": car.carId,
                "createdAt": car.createdAt ?? DateTime.now().toString(),
                "images": car.images.join(",")
              },
              "carFeatures": car.features.map((e) => {
                "featureId": e.featureId,
                "headId": e.headId,
                "quantity": e.quantity,
                "featureOption": e.featureOption
              }).toList(),
            }
        );

        response.fold((l) {
          EasyLoading.dismiss();
          showSnackBar(message: l.message!);
          status(Status.error);
        }, (r) async {

          // Compress images before uploading
          final originalImages = images.value.whereType<File>().toList();
          final compressedImages = await compressImages(originalImages);

          var imagesResponse = await gApiProvider.post(
            path: "car/SaveImages",
            isFormData: true,
            authorization: true,
            body: {
              "carId": r.data["carId"].toString(),
            },
            files: compressedImages, // Use compressed images
          );

          EasyLoading.dismiss();

          imagesResponse.fold((l) {
            Get.find<CarController>().getCars();
            showSnackBar(message: l.message!);
            status(Status.error);
          }, (x) async {
            await showAlertDialog(title: "Success", message: r.message);
            Get.back();
            Get.find<MyCarController>().getCars();
            status(Status.success);
          });
        });
      }
    } catch (e) {
      EasyLoading.dismiss();
      showSnackBar(message: "OperationFailed");
      status(Status.error);
    }
  }
}


