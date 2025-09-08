import 'dart:io';
import 'package:careqar/controllers/property_controller.dart';
import 'package:careqar/controllers/type_controller.dart';
import 'package:careqar/models/feature_model.dart';
import 'package:careqar/models/property_model.dart';
import 'package:careqar/models/type_model.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import '../enums.dart';
import '../global_variables.dart';
import 'location_controller.dart';
import 'my_property_controller.dart';

class AddPropertyController extends GetxController {
  var status = Status.initial.obs;
  var typeStatus = Status.initial.obs;
  var featureStatus = Status.initial.obs;
  final RxString priceInWords = ''.obs;
  final RxString selectedPlotSize = ''.obs;
  int lang=2;
  SubType? selectedSubtype;
  Type? selectedType;
  Property property = Property();
  Rx<List<dynamic>> images=Rx<List<dynamic>>([]);
 // Rx<CityModel> cityModel= Rx<CityModel>(CityModel());
 // Rx<TypeModel> typeModel= Rx<TypeModel>(TypeModel());
  Rx<FeatureModel> featureModel= Rx<FeatureModel>(FeatureModel());
  late TypeController typeController;
  late LocationController locationController;
  var delStatus = Status.initial.obs;
  var refreshStatus = Status.initial.obs;
  List<bool> expansionIndexes=[];

  @override
  void onInit() {
    property.purpose=EnumToString.convertToString(Purpose.Sell);
    typeController = Get.put(TypeController());
    locationController = Get.put(LocationController());  
    // TODO: implement onInit
    super.onInit();
  }

  var formKey = GlobalKey<FormState>().obs;
  var featuresFormKey = GlobalKey<FormState>().obs;


  Future<void> refreshProperty({required Property property}) async {
    try {
      refreshStatus(Status.loading);
      EasyLoading.show();

      var response =
      await gApiProvider.post(path: "property/refreshProperty?propertyId=${property.propertyId}",authorization: true);

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
  Future<void> soldOutProperty({required Property property}) async {
    try {
      delStatus(Status.loading);
      EasyLoading.show();

      var response =
      await gApiProvider.post(path: "property/soldOut?propertyId=${property.propertyId}",authorization: true);

      EasyLoading.dismiss();
      response.fold((l) {
        showSnackBar(message: l.message!);

      }, (r) async {

        Get.back();
        showSnackBar(message: r.message);
        var propertyController=Get.find<MyPropertyController>();
        property.isSold=true;
        propertyController.update();

      });
    } catch (e) {

      EasyLoading.dismiss();
      showSnackBar(message: "Error");
      delStatus(Status.error);
    }
  }
  Future<void> deleteProperty({required Property property}) async {
    try {
      delStatus(Status.loading);
      EasyLoading.show();

      var response =
      await gApiProvider.get(path: "property/delete?propertyId=${property.propertyId}",authorization: true);

EasyLoading.dismiss();
      response.fold((l) {
        showSnackBar(message: l.message!);
        delStatus(Status.error);
      }, (r) async {
        delStatus(Status.success);
        Get.back();
        showSnackBar(message: r.message);
        var propertyController=Get.find<MyPropertyController>();
        propertyController.propertyModel.value.properties.remove(property);
        propertyController.update();

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
      await gApiProvider.get(path: "feature/GetAllFeatureHeads?typeId=${property.typeId}&subTypeId=${property.subTypeId}");

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
    if(Get.focusScope!=null){
      Get.focusScope?.unfocus();
    }
    // FilePickerResult result = await FilePicker.platform.pickFiles(allowMultiple: true,allowCompression: true,type: FileType.custom,
    // allowedExtensions: ["jpg","jpeg","png"]
    // );
    final ImagePicker picker = ImagePicker();
    List<XFile> pickedImages = [];
    pickedImages = await picker.pickMultiImage();

    if (pickedImages.isNotEmpty) {
      for(var item in pickedImages){
        images.value.add(File(item.path));
        update();
      }

    }
  }
  Future<File?> compressAndConvertToWebP(File originalFile) async {
    try {
      final bytes = await originalFile.readAsBytes();
      final image = img.decodeImage(bytes);
      if (image == null) return null;

      final compressedBytes = img.encodeJpg(image, quality: 40);
      final dir = await getTemporaryDirectory();
      final filename = path.basenameWithoutExtension(originalFile.path);
      final compressedPath = path.join(dir.path, '$filename.jpg');

      final compressedFile = File(compressedPath);
      await compressedFile.writeAsBytes(compressedBytes);

      return compressedFile;
    } catch (e) {
      print('Compression error: $e');
      return null;
    }
  }

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

  Future<void> addProperty() async {
    try {
      if (property.cityId == null) {
        showSnackBar(message: "SelectCity");
      } else if (property.location == null) {
        showSnackBar(message: "SelectLocation");
      } else if (property.typeId == null) {
        showSnackBar(message: "SelectPropertyType");
      } else if (images.value.isEmpty) {
        showSnackBar(message: "UploadPropertyImages");
      } else if (formKey.value.currentState!.validate()) {
        Get.focusScope?.unfocus();
        formKey.value.currentState?.save();
        status(Status.loading);
        EasyLoading.show(status: "ProcessingPleaseWait".tr);

        var response = await gApiProvider.post(
          path: "property/save",
          authorization: true,
          body: {
            "property": {
              "title": property.titleEn,
              "titleAr": property.titleAr,
              "description": property.descriptionEn,
              "descriptionAr": property.descriptionAr,
              "kitchens": property.typeId! > 2 ? null : property.kitchens,
              "bedrooms": property.typeId! > 2 ? null : property.bedrooms,
              "baths": property.typeId! > 2 ? null : property.baths,
              "floors": property.typeId! > 2 ? null : property.floors,
              "typeId": property.typeId,
              "subTypeId": property.subTypeId,
              "purpose": property.purpose,
              "cityId": property.cityId,
              "countryId": gSelectedCountry?.countryId,
              "price": property.price,
              "area": property.area,
              "furnished": property.typeId! > 2 ? null : property.furnished,
              "propertyId": property.propertyId,
              "locationId": property.locationId,
              "createdAt": property.createdAt?.toString() ?? DateTime.now().toString(),
              "images": property.images.join(","),
              "phoneNumber": property.phoneNumber.parseNumber(),
              "countryCode": property.phoneNumber.dialCode,
              "isoCode": property.phoneNumber.isoCode,
            },
            "propertyFeatures": property.features.map((e) => {
              "featureId": e.featureId,
              "headId": e.headId,
              "quantity": e.quantity,
              "featureOption": e.featureOption,
            }).toList(),
          },
        );

        response.fold((l) {
          EasyLoading.dismiss();
          showSnackBar(message: l.message!);
          status(Status.error);
        }, (r) async {

          final originalImages = images.value.whereType<File>().toList();
          final compressedImages = await compressImages(originalImages);

          var imagesResponse = await gApiProvider.post(
            path: "property/SaveImages",
            isFormData: true,
            authorization: true,
            body: {
              "propertyId": r.data["propertyId"].toString(),
            },
            files: compressedImages,
          );

          EasyLoading.dismiss();

          imagesResponse.fold((l) {
            Get.find<PropertyController>().getProperties();
            showSnackBar(message: l.message!);
            status(Status.error);
          }, (x) async {
            await showAlertDialog(title: "Success", message: r.message);
            Get.back();
            Get.find<MyPropertyController>().getProperties();
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


