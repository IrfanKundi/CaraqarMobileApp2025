import 'package:careqar/controllers/profile_controller.dart';
import 'package:careqar/models/car_model.dart';
import 'package:careqar/models/city_model.dart';
import 'package:careqar/models/type_model.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:geolocator/geolocator.dart' as mapLocation;

import '../enums.dart';
import '../global_variables.dart';
import '../models/brand_model.dart';
import '../routes.dart';
import '../user_session.dart';

class CarController extends GetxController {
  var recomStatus = Status.initial.obs;
  var followedStatus = Status.initial.obs;
  var nearByStatus = Status.initial.obs;
  var status = Status.initial.obs;

  bool personalAds=false;
  bool companyAds=false;
  bool isGridView=true;


  Rx<List<Car>> recommendedCars = Rx<List<Car>>([]);
  Rx<List<Car>>followedCars = Rx<List<Car>>([]);
  Rx<List<Car>> nearByCars = Rx<List<Car>>([]);
  Rx<List<Car>> cars = Rx<List<Car>>([]);

  Rx<dynamic> isBuyerMode=Rx<dynamic>(null);  // bool
  int totalAds=0;


  Location? selectedLocation;
  City? selectedCity;
  int? typeId;
  int? cityId;
  int? brandId;
  Brand? brand;
  Type? type;
  Model? model;
  int? modelId;
  Transmission? transmission;
  FuelType? fuelType;
  VehicleCondition? condition;
  VehicleColor? color;
  RangeValues? price = RangeValues(0, 0);
  RangeValues? modelYear = RangeValues(1960, DateTime.now().year.toDouble());
  var page = 1.obs;
  var fetch = 10.obs;
  var loadMore= true.obs;
  var isLoadingMore=false.obs;
  String? endPrice;
  String? startYear;
  String? endYear;
  String? startPrice;

  resetFilters(){
     personalAds=false;
     companyAds=false;
    selectedCity=null;
     selectedLocation=null;
    fuelType=null;
    brand=null;
    type=null;
    model=null;
    color=null;
    transmission=null;
    typeId=null;
    brandId=null; condition=null;
    modelId=null;
    endPrice=null;
     startPrice=null;
     startYear=null;
     endYear=null;
    price = RangeValues(0, 0);
    modelYear = RangeValues(1960, DateTime.now().year.toDouble());
    isBuyerMode.value=null;
    page(1);
    loadMore.value=true;
    cars.value.clear();
    update(["filter"]);
  }


  changeBuyerMode()async{
    EasyLoading.show();
    isBuyerMode(!isBuyerMode.value!);
    EasyLoading.dismiss();
  }

  Future<void> getCars() async {
    try {
      recomStatus(Status.loading);
      update();
      // var response =
      //     await gApiProvider.get(path: "car/get?purpose=${isBuyerMode.value ? 'Sell':'Rent'}&cityId=${locationController.selectedCity.value !=null ? locationController.selectedCity.value.cityId : ''}", authorization: true);

      var userId;

      if(UserSession.isLoggedIn!){
        userId=Get.find<ProfileController>().user.value.userId;
      }else{
        userId=UserSession.guestUserId;
      }
      var response =
      await gApiProvider.get(path: "car/get?countryId=${gSelectedCountry!.countryId}&isRecommended=true&user=$userId");


   await   response.fold((l) {
        showSnackBar(message: l.message!);
        recomStatus(Status.error);
      }, (r) async {
        recomStatus(Status.success);
        recommendedCars.value = CarModel.fromMap(r.data).cars;

      });
      update();
    } catch (e) {

      showSnackBar(message: "Error");
      recomStatus(Status.error); update();
    }
  }

  Future<void> getFollowedCars() async {
    try {
      followedStatus(Status.loading);
      update();
      // var response =
      //     await gApiProvider.get(path: "car/get?purpose=${isBuyerMode.value ? 'Sell':'Rent'}&cityId=${locationController.selectedCity.value !=null ? locationController.selectedCity.value.cityId : ''}", authorization: true);


      var response =
      await gApiProvider.get(path: "car/get?countryId=${gSelectedCountry!.countryId}&followed=true", authorization: true);


      await   response.fold((l) {
        showSnackBar(message: l.message!);
        followedStatus(Status.error);
      }, (r) async {
        followedStatus(Status.success);
        followedCars.value = CarModel.fromMap(r.data).cars;

      });
      update();
    } catch (e) {

      showSnackBar(message: "Error");
      followedStatus(Status.error); update();
    }
  }
  Future<void> getNearbyCars() async {
    try {
      nearByStatus(Status.loading);
      update();
      if(gCurrentLocation==null){
        mapLocation.Position   locationData = await mapLocation.Geolocator.getCurrentPosition();
        gCurrentLocation=LatLng(locationData.latitude, locationData.longitude);
        // gCurrentLocation=const LatLng(25.387255,51.523644);

    }
      var response =
      await gApiProvider.get(path: "car/get?countryId=${gSelectedCountry!.countryId}&coordinates=${gCurrentLocation?.latitude},${gCurrentLocation?.longitude}", authorization: true);



      await  response.fold((l) {
        showSnackBar(message: l.message!);
        nearByStatus(Status.error);
      }, (r) async {
        nearByStatus(Status.success);
        nearByCars.value = CarModel.fromMap(r.data["cars"]).cars;

      });
      update();
    } catch (e) {

      showSnackBar(message: "Error");
      nearByStatus(Status.error);  update();
    }
  }


  Future<void> getFilteredCars({nearBy=false,}) async {
    try {
      if(Get.focusScope!.hasFocus){
        Get.focusScope?.unfocus();
      }
      if(page>1){

        isLoadingMore.value = true;
      }else{
        status(Status.loading);
      }

      update();
      //EasyLoading.show();

      String path =  "car/get?companyAds=$companyAds&personalAds=$personalAds&condition=${condition!=null?EnumToString.convertToString(condition):''}&fuelType=${fuelType!=null?EnumToString.convertToString(fuelType):''}&transmission=${transmission!=null?EnumToString.convertToString(transmission):''}&color=${color?.name??''}&modelId=${model?.modelId??""}&brandId=${brand?.brandId??""}&typeId=${type?.typeId??""}&countryId=${gSelectedCountry!.countryId}&page=${page.value}&fetch=${fetch.value}&cityId=${selectedCity?.cityId ?? ''}&locationId=${selectedLocation?.locationId ?? ''}&startPrice=${startPrice ?? ''}&endPrice=${endPrice ?? ''}&startModelYear=${startYear ?? ''}&endModelYear=${endYear ?? ''}";

    if(nearBy){
        path+="&coordinates=${gCurrentLocation!.latitude},${gCurrentLocation?.longitude}";
      }
      var response = await gApiProvider.get(
          path:path,
               authorization: true);

     // EasyLoading.dismiss();
      isLoadingMore.value =false;

     await response.fold((l) {
        showSnackBar(message: l.message!);
        status(Status.error);

      }, (r) async {
        status(Status.success);


        if(page.value>1){
          var list =CarModel.fromMap(r.data).cars;
          if(list.isEmpty){
            loadMore.value=false;
          }
          cars.value.addAll(list);


        }else{
          cars.value = CarModel.fromMap(r.data["cars"]).cars;
          totalAds=r.data["totalAds"];

        }

        if(Get.currentRoute==Routes.carFilterScreen){
            Get.back();
        }
      });
      update();
    } catch (e) {
      isLoadingMore.value =false;
     // EasyLoading.dismiss();
      showSnackBar(message: "Error");
      status(Status.error);
      update();
    }
  }
}


