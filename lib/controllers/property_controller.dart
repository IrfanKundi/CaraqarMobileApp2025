import 'package:careqar/controllers/location_controller.dart';
import 'package:careqar/controllers/profile_controller.dart';
import 'package:careqar/controllers/type_controller.dart';
import 'package:careqar/models/city_model.dart';
import 'package:careqar/models/property_model.dart';
import 'package:careqar/models/type_model.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


import '../enums.dart';
import '../global_variables.dart';
import '../user_session.dart';

class PropertyController extends GetxController {
  var recomStatus = Status.initial.obs;
  var followedStatus = Status.initial.obs;
  var nearByStatus = Status.initial.obs;
  var status = Status.initial.obs;

  bool isGridView=true;

  Rx<List<Property>> recommendedProperties = Rx<List<Property>>([]);
  Rx<List<Property>>followedProperties = Rx<List<Property>>([]);
  Rx<List<Property>> nearByProperties = Rx<List<Property>>([]);
  Rx<List<Property>> properties = Rx<List<Property>>([]);

  Rx<dynamic> isBuyerMode=Rx<dynamic>(null); // bool
  int totalAds=0;

  Rx<City?> selectedCity = Rx(null);
  Rx<Location?> selectedLocation = Rx(null);
  late TypeController typeController;
  late LocationController locationController;
  var typeId = 0.obs;
  RxList<int> subTypes = RxList([]);
  var subTypeId = 0.obs;
  Type? selectedType;
  var furnished = "".obs;



  RangeValues price = RangeValues(0, 0);
  RangeValues rooms = RangeValues(0, 0);
  String? endPrice;
  String? startPrice;
  var bedroomFrom = 0;
  var bedroomTo = 0;
  String? startSize;
  String? endSize;
  var bedrooms = ''.obs;
  var baths = ''.obs;
  var page = 1.obs;
  var fetch = 10.obs;
  var loadMore= true.obs;
  var isLoadingMore=false.obs;

  resetFilters(){
    selectedType=null;
    selectedCity.value=null;
    selectedLocation.value=null;
    typeId.value=0;
    subTypeId.value=0;
    startSize=null;
    price = RangeValues(0, 0);rooms = RangeValues(0, 0);
    endSize=null;
    startPrice=null;
    endPrice=null;
    bedroomFrom=0;
    bedroomTo=0;
    bedrooms.value='';
    baths.value='';
    // isBuyerMode.value=null;
    page(1);
    subTypes.clear();
    loadMore.value=true;
    properties.value.clear();
    update(["filters"]);
  }


  @override
  void onInit() {

    typeController = Get.put(TypeController());
    locationController = Get.put(LocationController());
    // TODO: implement onInit
    super.onInit();
  }

  changeBuyerMode()async{
    EasyLoading.show();
    isBuyerMode(!isBuyerMode.value!);
    EasyLoading.dismiss();
  }

  Future<void> getProperties() async {
    try {
      recomStatus(Status.loading);
      update();
      // var response =
      //     await gApiProvider.get(path: "property/get?purpose=${isBuyerMode.value ? 'Sell':'Rent'}&cityId=${locationController.selectedCity.value !=null ? locationController.selectedCity.value.cityId : ''}", authorization: true);

      var userId;

      if(UserSession.isLoggedIn!){
        userId=Get.find<ProfileController>().user.value.userId;
      }else{
        userId=UserSession.guestUserId;
      }
      var response =
      await gApiProvider.get(path: "property/get?countryId=${gSelectedCountry?.countryId}&isRecommended=true&user=$userId");


   await   response.fold((l) {
        showSnackBar(message: l.message!);
        recomStatus(Status.error);
      }, (r) async {
        recomStatus(Status.success);
        recommendedProperties.value = PropertyModel.fromMap(r.data).properties;

      });
      update();
    } catch (e) {

      showSnackBar(message: "Error");
      recomStatus(Status.error); update();
    }
  }

  Future<void> getFollowedProperties() async {
    try {
      followedStatus(Status.loading);
      update();
      // var response =
      //     await gApiProvider.get(path: "property/get?purpose=${isBuyerMode.value ? 'Sell':'Rent'}&cityId=${locationController.selectedCity.value !=null ? locationController.selectedCity.value.cityId : ''}", authorization: true);


      var response =
      await gApiProvider.get(path: "property/get?countryId=${gSelectedCountry?.countryId}&followed=true", authorization: true);


      await   response.fold((l) {
        showSnackBar(message: l.message!);
        followedStatus(Status.error);
      }, (r) async {
        followedStatus(Status.success);
        followedProperties.value = PropertyModel.fromMap(r.data).properties;

      });
      update();
    } catch (e) {

      showSnackBar(message: "Error");
      followedStatus(Status.error); update();
    }
  }


  static Future<void> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar(
        "Disabled",
        'Location services are disabled.',
      );
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar(
          "Denied",
          'Location permissions are denied',
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
        "Permanently Denied",
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }
    Position position;
    position = await Geolocator.getCurrentPosition();

    gCurrentLocation = LatLng(position.latitude, position.longitude);

  }

  Future<void> getNearbyProperties() async {
    try {

      nearByStatus(Status.loading);
      update();
      if(gCurrentLocation==null){
        await determinePosition();
    }
      var response = await gApiProvider.get(path: "property/get?coordinates=${gCurrentLocation!.latitude},${gCurrentLocation!.longitude}", authorization: true);



      await  response.fold((l) {
       // showSnackBar(message: l.message!);
        nearByStatus(Status.error);
      }, (r) async {
        nearByStatus(Status.success);
        nearByProperties.value = PropertyModel
            .fromMap(r.data["properties"])
            .properties;
      });
        update();
      } catch (e) {
     // showSnackBar(message: "Error");
      nearByStatus(Status.error);
      update();

  }
  }


  Future<void> getFilteredProperties({nearBy=false}) async {
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

      // String path =  "property/get?purpose=${isBuyerMode.value ? 'Sell':'Rent'}&page=${page.value}&fetch=${fetch.value}&cityId=${selectedCity.value !=null ? selectedCity.value.cityId : ''}&locationId=${selectedLocation.value !=null ? selectedLocation.value.locationId : ''}&typeId=${typeId.value > 0 ? typeId.value : ''}&subTypeId=${subTypeId.value > 0 ? subTypeId.value : ''}&bedrooms=${bedrooms.value.isNotEmpty ? bedrooms.value : ''}&baths=${baths.value.isNotEmpty ? baths.value : ''}&startPrice=${startPrice > 0 ? startPrice : ''}&endPrice=${endPrice > 0 ? endPrice : ''}&startSize=${startSize > 0 ? startSize : ''}&endSize=${endSize > 0 ? endSize : ''}";


      String path =  "property/get?countryId=${gSelectedCountry!.countryId}&furnished=${furnished.value}&purpose=${isBuyerMode.value==null ? '': isBuyerMode.value==true?'Sell': 'Rent'}&page=${page.value}&fetch=${fetch.value}&cityId=${selectedCity.value !=null ? selectedCity.value!.cityId : ''}&locationId=${selectedLocation.value !=null ? selectedLocation.value?.locationId : ''}&subTypes=${subTypes.isNotEmpty  ? subTypes.join(",").toString() : ''}&subTypeId=${subTypeId.value > 0 ? subTypeId.value : ''}&bedroomFrom=${rooms.start > 0 ? rooms.start.toInt() : ''}&bedroomTo=${rooms.end > 0 ? rooms.end.toInt() : ''}&startPrice=${startPrice ?? ''}&endPrice=${endPrice ?? ''}&startSize=${startSize ?? ''}&endSize=${endSize ?? ''}";

      if (kDebugMode) {
        print("path: $path");
      }
    if(nearBy){
        path+="&coordinates=${gCurrentLocation?.latitude},${gCurrentLocation?.longitude}";
        if (kDebugMode) {
          print("path: $path");
        }
      }
      var response = await gApiProvider.get(
          path:path,
               authorization: true);

      if (kDebugMode) {
        print("response: $response");
      }

     // EasyLoading.dismiss();
      isLoadingMore.value =false;

     await response.fold((l) {
        showSnackBar(message: l.message!);
        status(Status.error);
        update();
      }, (r) async {
        status(Status.success);


        if(page.value>1){
          var list =PropertyModel.fromMap(r.data).properties;
          if(list.isEmpty){
            loadMore.value=false;
          }
          properties.value.addAll(list);


        }else{
          properties.value = PropertyModel.fromMap(r.data["properties"]).properties;
          totalAds=r.data["totalAds"];

        }

        // if(Get.currentRoute==Routes.filtersScreen){
        //   if(Get.find<HomeController>().index.value==1){
        //     Get.back();
        //   }else{
        //
        //     Get.find<HomeController>().index(1);
        //     Get.back();
        //   }
        //
        // }else{
        //   Get.toNamed(Routes.propertiesScreen,parameters: {"title":"Nearby Properties"});
        // }

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

const List<String> furnished = ["Fully","Semi","Non"];


