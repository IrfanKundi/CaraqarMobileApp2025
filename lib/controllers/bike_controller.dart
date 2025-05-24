import 'package:careqar/controllers/profile_controller.dart';
import 'package:careqar/models/bike_model.dart';
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

class BikeController extends GetxController {
  var recomStatus = Status.initial.obs;
  var followedStatus = Status.initial.obs;
  var nearByStatus = Status.initial.obs;
  var status = Status.initial.obs;

  bool isGridView=true;

  Rx<List<Bike>> recommendedBikes = Rx<List<Bike>>([]);
  Rx<List<Bike>>followedBikes = Rx<List<Bike>>([]);
  Rx<List<Bike>> nearByBikes = Rx<List<Bike>>([]);
  Rx<List<Bike>> bikes = Rx<List<Bike>>([]);

  Rx<dynamic> isBuyerMode=Rx<dynamic>(null);  // bool

  int totalAds=0;
  City? selectedCity;
  int? typeId;
  int? cityId;
  int? brandId;
  Brand? brand;
  Type? type;
  Model? model;
  String? endYear;
  String? startYear;
  int? modelId;
  bool personalAds=false;
  bool companyAds=false;
  VehicleCondition? condition;
  VehicleColor? color;
  RangeValues price = RangeValues(0, 0);
  RangeValues modelYear = RangeValues(1960, DateTime.now().year.toDouble());
  var page = 1.obs;
  var fetch = 10.obs;
  var loadMore= true.obs;
  var isLoadingMore=false.obs;
  String? endPrice;
  String? startPrice;

  resetFilters(){
    personalAds=false;
    companyAds=false;
    selectedCity=null;
    startPrice=null;
    endPrice=null;
    startYear=null;
    endYear=null;
    color=null;
    condition=null;
    typeId=null;
    brandId=null;
    modelId=null;
    brand=null;
    type=null;
    model=null;
    price = RangeValues(0, 0);
    modelYear = RangeValues(1960, DateTime.now().year.toDouble());
    isBuyerMode.value=null;
    page(1);
    loadMore.value=true;
    bikes.value.clear();
    update(["filter"]);
  }

  changeBuyerMode()async{
    EasyLoading.show();
    isBuyerMode(!isBuyerMode.value!);
    EasyLoading.dismiss();
  }

  Future<void> getBikes() async {
    try {
      recomStatus(Status.loading);
      update();
      // var response =
      //     await gApiProvider.get(path: "bike/get?purpose=${isBuyerMode.value ? 'Sell':'Rent'}&cityId=${locationController.selectedCity.value !=null ? locationController.selectedCity.value.cityId : ''}", authorization: true);

      var userId;

      if(UserSession.isLoggedIn!){
        userId=Get.find<ProfileController>().user.value.userId;
      }else{
        userId=UserSession.guestUserId;
      }
      var response =
      await gApiProvider.get(path: "bike/get?countryId=${gSelectedCountry!.countryId}&isRecommended=true&user=$userId");


   await   response.fold((l) {
        showSnackBar(message: l.message!);
        recomStatus(Status.error);
      }, (r) async {
        recomStatus(Status.success);
        recommendedBikes.value = BikeModel.fromMap(r.data).bikes;

      });
      update();
    } catch (e) {

      showSnackBar(message: "Error");
      recomStatus(Status.error); update();
    }
  }

  Future<void> getFollowedBikes() async {
    try {
      followedStatus(Status.loading);
      update();
      // var response =
      //     await gApiProvider.get(path: "bike/get?purpose=${isBuyerMode.value ? 'Sell':'Rent'}&cityId=${locationController.selectedCity.value !=null ? locationController.selectedCity.value.cityId : ''}", authorization: true);


      var response =
      await gApiProvider.get(path: "bike/get?countryId=${gSelectedCountry!.countryId}&followed=true", authorization: true);


      await   response.fold((l) {
        showSnackBar(message: l.message!);
        followedStatus(Status.error);
      }, (r) async {
        followedStatus(Status.success);
        followedBikes.value = BikeModel.fromMap(r.data).bikes;

      });
      update();
    } catch (e) {

      showSnackBar(message: "Error");
      followedStatus(Status.error); update();
    }
  }
  Future<void> getNearbyBikes() async {
    try {
      nearByStatus(Status.loading);
      update();
      if(gCurrentLocation==null){
        mapLocation.Position   locationData = await mapLocation.Geolocator.getCurrentPosition();
        gCurrentLocation=LatLng(locationData.latitude, locationData.longitude);
        // gCurrentLocation=const LatLng(25.387255,51.523644);
    }
      var response =
      await gApiProvider.get(path: "bike/get?countryId=${gSelectedCountry?.countryId}&coordinates=${gCurrentLocation?.latitude},${gCurrentLocation?.longitude}", authorization: true);



      await  response.fold((l) {
        showSnackBar(message: l.message!);
        nearByStatus(Status.error);
      }, (r) async {
        nearByStatus(Status.success);
        nearByBikes.value = BikeModel.fromMap(r.data["bikes"]).bikes;

      });
      update();
    } catch (e) {

      showSnackBar(message: "Error");
      nearByStatus(Status.error);  update();
    }
  }


  Future<void> getFilteredBikes({nearBy=false}) async {
    try {
      if(Get.focusScope!.hasFocus){
        Get.focusScope?.unfocus();
      }
      if(page>1){

        isLoadingMore.value = true;
      }else{status(Status.loading);
      }

      update();
      //EasyLoading.show();

      // String path =  "bike/get?purpose=${isBuyerMode.value ? 'Sell':'Rent'}&page=${page.value}&fetch=${fetch.value}&cityId=${selectedCity.value !=null ? selectedCity.value.cityId : ''}&locationId=${selectedLocation.value !=null ? selectedLocation.value.locationId : ''}&typeId=${typeId.value > 0 ? typeId.value : ''}&subTypeId=${subTypeId.value > 0 ? subTypeId.value : ''}&bedrooms=${bedrooms.value.isNotEmpty ? bedrooms.value : ''}&baths=${baths.value.isNotEmpty ? baths.value : ''}&startPrice=${startPrice > 0 ? startPrice : ''}&endPrice=${endPrice > 0 ? endPrice : ''}&startSize=${startSize > 0 ? startSize : ''}&endSize=${endSize > 0 ? endSize : ''}";


      String path =  "bike/get?companyAds=$companyAds&personalAds=$personalAds&condition=${condition!=null?EnumToString.convertToString(condition):''}&color=${color?.name??''}&modelId=${model?.modelId}&brandId=${brand?.brandId}&typeId=${type?.typeId}&countryId=${gSelectedCountry!.countryId}&page=${page.value}&fetch=${fetch.value}&cityId=${selectedCity?.cityId ?? ''}&startPrice=${startPrice ?? ''}&endPrice=${endPrice ?? ''}&startModelYear=${startYear ?? ''}&endModelYear=${endYear ?? ''}";

      if(nearBy){
        path+="&coordinates=${gCurrentLocation?.latitude},${gCurrentLocation?.longitude}";
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
          var list =BikeModel.fromMap(r.data).bikes;
          if(list.isEmpty){
            loadMore.value=false;
          }
          bikes.value.addAll(list);


        }else{
          bikes.value = BikeModel.fromMap(r.data["bikes"]).bikes;
          //totalAds= bikes.value.length;
          totalAds=r.data["totalAds"];
        }

        if(Get.currentRoute==Routes.bikeFilterScreen){
          Navigator.pop(Get.context!);
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


