import 'dart:convert';
import 'dart:io';

import 'package:careqar/controllers/bike_controller.dart';
import 'package:careqar/controllers/home_controller.dart';
import 'package:careqar/controllers/my_bike_controller.dart';
import 'package:careqar/controllers/my_car_controller.dart';
import 'package:careqar/global_variables.dart';
import 'package:careqar/models/brand_model.dart';
import 'package:careqar/models/type_model.dart';
import 'package:careqar/routes.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import '../enums.dart';
import '../models/car_model.dart';
import '../models/city_model.dart';
import '../models/feature_model.dart';
import '../ui/widgets/alerts.dart';
import 'car_controller.dart';
import 'my_numberplate_controller.dart';

class VehicleController extends GetxController {


  var featuresStatus = Status.initial.obs;
  late CarController carController;
  late MyCarController myCarController;
  late MyBikeController myBikeController;
  late MyNumberPlateController myNumberPlateController;
  late BikeController bikeController;
  VehicleType? vehicleType;
  Rx<List<dynamic>> newImages=Rx<List<dynamic>>([]);
  var featuresFormKey = GlobalKey<FormState>().obs;
  final RxString priceInWords = ''.obs;
  int? carId;
  int? bikeId;
  int lang=2;
  String? purpose;
  String? paymentMethod;
  String? descriptionEn;
  String? descriptionAr;
  Type? type;
  City? city;
  double? price;
  String? modelYear;
  String? condition;
  String? origin;
  String? registrationYear;
  int? registrationCityId;
  int? locationId;
  String? province;
  String? registrationProvince;
  String? registrationProvinceName;
  Brand? brand;
  Model? model;
  String? fuelType;
  String? transmission;
  String? color;
  String? mileage;
  String? importYear;
  int? modelVariant;
  String? modelVariantName;
  int? seats;
  int? typeId;
  int? brandId;
  int? cityId;
  int? numberPlateId;
  int? modelId;
  String? engine;
  String? number;
  String? digits;
  String? privilege;
  String? plateType;
  List<bool>? expansionIndexes=[];
  List<VehicleFeature> vehicleFeatures=[];
  List<String> images=[];
  PhoneNumber phoneNumber = PhoneNumber(isoCode: gSelectedCountry?.isoCode);
  Rx<FeatureModel> featureModel= Rx<FeatureModel>(FeatureModel());
  var formKey=GlobalKey<FormState>();
  @override
  void onInit() async {
    carController =   Get.put(CarController(),permanent: true);
    bikeController =   Get.put(BikeController(),permanent: true);
    myCarController =   Get.put(MyCarController(),permanent: true);
    myBikeController =   Get.put(MyBikeController(),permanent: true);
    myNumberPlateController =   Get.put(MyNumberPlateController(),permanent: true);
    super.onInit();
  }
  Future<void> getFeatures() async {
    try {

      featuresStatus(Status.loading);


      var response =
      await gApiProvider.get(path: "feature/GetAllFeatureHeads?isVehicle=true&vehicleType=${EnumToString.convertToString(vehicleType)}");

      await response.fold((l) {
        showSnackBar(message: l.message!);
        featuresStatus(Status.error);
      }, (r) async {
        featuresStatus(Status.success);
        featureModel.value = FeatureModel.fromMap(r.data);
        expansionIndexes = List.generate(featureModel.value.featureHeads.length, (index) => false);

      });update();
    } catch (e) {
      showSnackBar(message: "Error");
      featuresStatus(Status.error);update();
    }
  }

  Future<void> uploadImages()async{
    if(Get.focusScope!=null){
      Get.focusScope?.unfocus();
    }

    // FilePickerResult result = await FilePicker.platform.pickFiles(allowMultiple: true,allowCompression: true,type: FileType.custom,
    // allowedExtensions: ["jpg","jpeg","png"]
    // );
    final ImagePicker _picker = ImagePicker();
    List<XFile?>? pickedImages = await _picker.pickMultiImage();

    if (pickedImages!=null) {
      for(var item in pickedImages){
        newImages.value.add(File(item!.path));
        update();
      }

    }
  }

  void uploadNow(){
if(formKey.currentState!.validate()){
  if(vehicleType==VehicleType.Car){
    addCar();
  }else if(vehicleType==VehicleType.Bike){
    addBike();
  }else{
    addNumberPlate();
  }
}
  }

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

  Future<void> addNumberPlate() async {
    try {
      if (newImages.value.isEmpty) {
        showSnackBar(message: "UploadImages");
      } else {
        Get.focusScope?.unfocus();

        EasyLoading.show(status: "ProcessingPleaseWait".tr);

        var response = await gApiProvider.post(
            path: "numberPlate/save",
            authorization: true,
            body: {
              "numberPlateId": numberPlateId,
              "condition": digits,
              "description": descriptionEn,
              "descriptionAr": descriptionAr,
              "cityId": city?.cityId,
              "countryId": gSelectedCountry?.countryId,
              "RegistrationCity": registrationCityId,
              "LocationId":locationId,
              "price": price,
              "purpose": purpose,
              "number": number,
              "plateType": plateType,
              "digits": digits,
              "privilege": privilege,
              "phoneNumber": phoneNumber.parseNumber(),
              "countryCode": phoneNumber.dialCode,
              "isoCode": phoneNumber.isoCode,
              "createdAt": DateTime.now().toString(),
              "images": images.join(",")
            }
        );

        await response.fold((l) {
          EasyLoading.dismiss();
          showSnackBar(message: l.message!);
        }, (r) async {
          EasyLoading.show();

          // Compress images before uploading
          final originalImages = newImages.value.whereType<File>().toList();
          final compressedImages = await compressImages(originalImages);

          var imagesResponse = await gApiProvider.post(
            path: "numberPlate/SaveImages",
            isFormData: true,
            authorization: true,
            body: {
              "numberPlateId": r.data["numberPlateId"].toString(),
            },
            files: compressedImages, // Use compressed images
          );

          EasyLoading.dismiss();

          imagesResponse.fold((l) {
            showSnackBar(message: l.message!);
          }, (x) async {
            await showAlertDialog(title: "Success", message: r.message);
            reset();
            Get.offAllNamed(Routes.navigationScreen, arguments: {'initialTab': 2});
          });
        });
      }
    } catch (e) {
      EasyLoading.dismiss();
      showSnackBar(message: "OperationFailed");
    }
  }

  Future<void> addCar() async {
    try {
      print("SAHAR: Starting addCar function");
      print("SAHAR: newImages count: ${newImages.value.length}");

      if (newImages.value.isEmpty) {
        print("SAHAR: No images found, showing snackbar");
        showSnackBar(message: "UploadCarImages");
      } else {
        print("SAHAR: Images found, proceeding with car save");
        Get.focusScope?.unfocus();

        EasyLoading.show(status: "ProcessingPleaseWait".tr);

        print("SAHAR: Car data being sent:");
        print("SAHAR: - modelYear: $modelYear");
        print("SAHAR: - importYear: $importYear");
        print("SAHAR: - modelVariant: $modelVariant");
        print("SAHAR: - condition: $condition");
        print("SAHAR: - origin: $origin");
        print("SAHAR: - registrationYear: $registrationYear");
        print("SAHAR: - registrationCityId: $registrationCityId");
        print("SAHAR: - registrationProvince: $registrationProvince");
        print("SAHAR: - locationId: $locationId");
        print("SAHAR: - brandId: ${brand?.brandId}");
        print("SAHAR: - modelId: ${model?.modelId}");
        print("SAHAR: - fuelType: $fuelType");
        print("SAHAR: - transmission: $transmission");
        print("SAHAR: - color: $color");
        print("SAHAR: - mileage: $mileage");
        print("SAHAR: - seats: $seats");
        print("SAHAR: - engine: $engine");
        print("SAHAR: - descriptionEn: $descriptionEn");
        print("SAHAR: - descriptionAr: $descriptionAr");
        print("SAHAR: - typeId: ${type?.typeId}");
        print("SAHAR: - cityId: ${city?.cityId}");
        print("SAHAR: - countryId: ${gSelectedCountry?.countryId}");
        print("SAHAR: - price: $price");
        print("SAHAR: - carId: $carId");
        print("SAHAR: - purpose: $purpose");
        print("SAHAR: - paymentMethod: $paymentMethod");
        print("SAHAR: - phoneNumber: ${phoneNumber.parseNumber()}");
        print("SAHAR: - countryCode: ${phoneNumber.dialCode}");
        print("SAHAR: - isoCode: ${phoneNumber.isoCode}");
        print("SAHAR: - images: ${images.join(",")}");
        print("SAHAR: - vehicleFeatures count: ${vehicleFeatures.length}");

        // Create the request body
        final requestBody = {
          "car": {
            "modelYear": modelYear,
            "ImportYear": importYear,
            "ModelVariant": modelVariant,
            "condition": condition,
            "ImportedLocal": origin,
            "RegistrationYear": registrationYear,
            "RegistrationCityId": registrationCityId,
            "RegistrationCity": registrationCityId,
            "RegistrationProvince": registrationProvince.toString(),
            "LocationId":locationId,
            "brandId": brand?.brandId,
            "modelId": model?.modelId,
            "fuelType": fuelType,
            "transmission": transmission,
            "color": color,
            "mileage": mileage,
            "seats": seats,
            "engin": engine,
            "description": descriptionEn,
            "descriptionAr": descriptionAr,
            "typeId": type?.typeId,
            "cityId": city?.cityId,
            "countryId": gSelectedCountry?.countryId,
            "price": price,
            "carId": carId,
            "purpose": purpose,
            "paymentMethod": paymentMethod,
            "createdAt": DateTime.now().toString(),
            "images": images.join(","),
            "phoneNumber": phoneNumber.parseNumber(),
            "countryCode": phoneNumber.dialCode,
            "isoCode": phoneNumber.isoCode,
          },
          "carFeatures": vehicleFeatures.map((e) => {
            "featureId": e.featureId,
            "headId": e.headId,
            "quantity": e.quantity,
            "featureOption": e.featureOption
          }).toList(),
        };

        // Print the JSON encoded request body
        print("SAHAR: ===== FULL REQUEST BODY JSON START =====");
        try {
          final jsonString = jsonEncode(requestBody);
          print("SAHAR: Request Body JSON: $jsonString");
        } catch (jsonError) {
          print("SAHAR: Error encoding to JSON: $jsonError");
          print("SAHAR: Raw request body: $requestBody");
        }
        print("SAHAR: ===== FULL REQUEST BODY JSON END =====");

        // Print car features individually for better debugging
        print("SAHAR: ===== CAR FEATURES DETAILS START =====");
        for (int i = 0; i < vehicleFeatures.length; i++) {
          final feature = vehicleFeatures[i];
          print("SAHAR: Feature $i:");
          print("SAHAR: - featureId: ${feature.featureId}");
          print("SAHAR: - headId: ${feature.headId}");
          print("SAHAR: - quantity: ${feature.quantity}");
          print("SAHAR: - featureOption: ${feature.featureOption}");

          try {
            final featureJson = jsonEncode({
              "featureId": feature.featureId,
              "headId": feature.headId,
              "quantity": feature.quantity,
              "featureOption": feature.featureOption
            });
            print("SAHAR: - JSON: $featureJson");
          } catch (e) {
            print("SAHAR: - JSON encoding error: $e");
          }
        }
        print("SAHAR: ===== CAR FEATURES DETAILS END =====");

        var response = await gApiProvider.post(
            path: "car/save",
            authorization: true,
            body: requestBody
        );

        print("SAHAR: Car save API response received");

        await response.fold((l) {
          print("SAHAR: Car save API failed with error: ${l.message}");
          //print("SAHAR: Error details JSON: ${jsonEncode(l.toJson() ?? {})}");
          EasyLoading.dismiss();
          showSnackBar(message: l.message!);
        }, (r) async {
          print("SAHAR: Car save API successful");
          print("SAHAR: Response data: ${r.data}");
          print("SAHAR: Response data JSON: ${jsonEncode(r.data ?? {})}");
          print("SAHAR: Car ID from response: ${r.data["carId"]}");

          // Compress images before uploading
          final originalImages = newImages.value.whereType<File>().toList();
          print("SAHAR: Original images count for compression: ${originalImages.length}");

          final compressedImages = await compressImages(originalImages);
          print("SAHAR: Compressed images count: ${compressedImages.length}");

          // Print image upload request body
          final imageUploadBody = {
            "carId": r.data["carId"].toString(),
          };
          print("SAHAR: Image upload body JSON: ${jsonEncode(imageUploadBody)}");

          print("SAHAR: Starting image upload API call");
          var imagesResponse = await gApiProvider.post(
            path: "car/SaveImages",
            isFormData: true,
            authorization: true,
            body: imageUploadBody,
            files: compressedImages, // Use compressed images
          );

          print("SAHAR: Image upload API response received");
          EasyLoading.dismiss();

          imagesResponse.fold((l) {
            print("SAHAR: Image upload API failed with error: ${l.message}");
            //print("SAHAR: Image upload error JSON: ${jsonEncode(l.toJson() ?? {})}");
            showSnackBar(message: l.message!);
          }, (x) async {
            print("SAHAR: Image upload API successful");
            print("SAHAR: Success response: ${r.message}");
            print("SAHAR: Image upload response JSON: ${jsonEncode(x.data ?? {})}");
            await showAlertDialog(title: "Success", message: r.message);
            print("SAHAR: Calling reset function");
            reset();
            print("SAHAR: Navigating to navigation screen with tab 1");
            // update my car screen ali
            Get.offAllNamed(Routes.navigationScreen, arguments: {'initialTab': 1});
          });
        });
      }
    } catch (e) {
      print("SAHAR: Exception caught in addCar: $e");
      print("SAHAR: Exception type: ${e.runtimeType}");
      print("SAHAR: Exception stack trace: ${e.toString()}");
      EasyLoading.dismiss();
      showSnackBar(message: "OperationFailed");
    }
  }

  Future<void> addBike() async {
    try {
      if (newImages.value.isEmpty) {
        showSnackBar(message: "UploadBikeImages");
      } else {
        Get.focusScope?.unfocus();

        EasyLoading.show(status: "ProcessingPleaseWait".tr);

        var response = await gApiProvider.post(
            path: "bike/save",
            authorization: true,
            body: {
              "bike": {
                "modelYear": modelYear,
                "condition": condition,
                "origin": origin,
                "registrationYear": registrationYear,
                "RegistrationCity": registrationCityId,
                "LocationId":locationId,
                "province": province,
                "RegistrationProvince ": registrationCityId.toString(),
                "ModelVariant": modelVariant,
                "ImportYear ": importYear,
                "brandId": brand?.brandId,
                "modelId": model?.modelId,
                "color": color,
                "mileage": mileage,
                "fuelType": fuelType,
                "engin": engine,
                "purpose": purpose,
                "paymentMethod": paymentMethod,
                "description": descriptionEn,
                "descriptionAr": descriptionAr,
                "typeId": type?.typeId,
                "cityId": city?.cityId,
                "countryId": gSelectedCountry?.countryId,
                "price": price,
                "bikeId": bikeId,
                "createdAt": DateTime.now().toString(),
                "images": images.join(","),
                "phoneNumber": phoneNumber.parseNumber(),
                "countryCode": phoneNumber.dialCode,
                "isoCode": phoneNumber.isoCode,
              },
              "bikeFeatures": vehicleFeatures.map((e) => {
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
        }, (r) async {

          // Compress images before uploading
          final originalImages = newImages.value.whereType<File>().toList();
          final compressedImages = await compressImages(originalImages);

          var imagesResponse = await gApiProvider.post(
            path: "bike/SaveImages",
            isFormData: true,
            authorization: true,
            body: {
              "bikeId": r.data["bikeId"].toString(),
            },
            files: compressedImages, // Use compressed images
          );

          EasyLoading.dismiss();

          imagesResponse.fold((l) {
            showSnackBar(message: l.message!);
          }, (x) async {
            await showAlertDialog(title: "Success", message: r.message);
            reset();
            Get.find<HomeController>().index.value = 0;
            Get.offAllNamed(Routes.navigationScreen, arguments: {'initialTab': 2});
          });
        });
      }
    } catch (e) {
      EasyLoading.dismiss();
      showSnackBar(message: "OperationFailed");
    }
  }

  void edit({vehicleType,dynamic data})async{
    reset();
    if(data!=null){
      phoneNumber=data.phoneNumber;
      this.vehicleType=vehicleType;
      lang=2;

      paymentMethod=data.paymentMethod;
      descriptionEn=data.descriptionEn;
      descriptionAr=data.descriptionAr;

      cityId=data.cityId;
      price=data.price;

      images=data.images;
      newImages.value.addAll(data.images);


    if(vehicleType==VehicleType.Car){
      carId=data.carId;
      transmission=data.transmission;
      seats=data.seats;
    }else  if(vehicleType==VehicleType.Bike){
      bikeId=data.bikeId;
    }

    if(vehicleType!=VehicleType.NumberPlate){
      purpose=data.purpose;
      typeId=data.typeId;
      modelYear=data.modelYear;
      condition=data.condition;
      origin=data.origin;
      registrationYear= data.registrationYear;
      registrationCityId= data.registrationCityId;
      locationId= data.locationId;
      province=data.province;
      registrationProvince=data.registrationCityId.toString();
      modelVariant=data.modelVariant;
      brandId=data.brandId;
      modelId=data.modelId;
      fuelType=data.fuelType;
      color=data.color;
      mileage=data.mileage;

      engine=data.engine;

      vehicleFeatures=data.features;
      Get.toNamed(Routes.chooseBrandScreen);
    }else{
      numberPlateId=data.numberPlateId;
      number=data.number;
      privilege=data.privilege;
      digits=data.digits;
      plateType=data.plateType;
      Get.toNamed(Routes.enterNumberScreen);
    }

    }
  }

  void reset(){
    phoneNumber = PhoneNumber(isoCode: gSelectedCountry?.isoCode);
    digits=null;
    number=null;
    plateType=null;
    privilege=null;
    vehicleType=null;
    carId=null;
    numberPlateId=null;
    bikeId=null;
    lang=2;
    purpose=null;
    paymentMethod=null;
    descriptionEn=null;
    descriptionAr=null;
    typeId=null;
    cityId=null;
    price=null;
    modelYear=null;
    condition=null;
    origin=null;
    registrationYear=null;
    registrationCityId=null;
    locationId=null;
    province=null;
    registrationProvince =null;
    registrationProvinceName =null;
    modelVariant =null;
    modelVariantName =null;
    importYear =null;
    brandId=null;
    modelId=null;
    fuelType=null;
    transmission=null;
    color=null;
    mileage=null;
    seats=null;
    engine=null;
    type=null;
    brand=null;
    model=null;
    city=null;
    vehicleFeatures.clear();
    images.clear();
    newImages.value.clear();
  }
}

final numberPlateTypes=[
  NumberPlateType("3","3 Digits","assets/images/3-digits.png"),
  NumberPlateType("4","4 Digits","assets/images/4-digits.png"),
  NumberPlateType("5","5 Digits","assets/images/5-digits.png"),
  NumberPlateType("6","6 Digits","assets/images/6-digits.png"),
  NumberPlateType("other","Other","assets/images/others.png"),
];

class NumberPlateType{
  String id;
  String title;
  String image;
  NumberPlateType(this.id,this.title,this.image);
}
