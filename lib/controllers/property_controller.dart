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

  // Add these new RangeValues for kitchen and washroom
  RangeValues kitchens = RangeValues(0, 0);
  RangeValues washrooms = RangeValues(0, 0);

  String? endPrice;
  String? startPrice;
  var bedroomFrom = 0;
  var bedroomTo = 0;

  // Add kitchen and washroom range variables
  var kitchenFrom = 0;
  var kitchenTo = 0;
  var washroomFrom = 0;
  var washroomTo = 0;

  String? startSize;
  String? endSize;
  var bedrooms = ''.obs;
  var baths = ''.obs;
  var page = 1.obs;
  var fetch = 10.obs;
  var loadMore= true.obs;
  var isLoadingMore=false.obs;

  // Add sort parameter
  var selectedSortBy = ''.obs;

  resetFilters(){
    selectedType=null;
    selectedCity.value=null;
    selectedLocation.value=null;
    typeId.value=0;
    subTypeId.value=0;
    startSize=null;
    price = RangeValues(0, 0);
    rooms = RangeValues(0, 0);

    // my changes
    kitchens = RangeValues(0, 0);
    washrooms = RangeValues(0, 0);

    endSize=null;
    startPrice=null;
    endPrice=null;
    bedroomFrom=0;
    bedroomTo=0;

    // Reset new range variables
    kitchenFrom=0;
    kitchenTo=0;
    washroomFrom=0;
    washroomTo=0;

    bedrooms.value='';
    baths.value='';
    // isBuyerMode.value=null;
    page(1);
    subTypes.clear();
    loadMore.value=true;
    properties.value.clear();

    // Reset sort parameter
    selectedSortBy.value = '';

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
        nearByStatus(Status.error);
      }, (r) async {
        nearByStatus(Status.success);
        nearByProperties.value = PropertyModel
            .fromMap(r.data["properties"])
            .properties;
      });
      update();
    } catch (e) {
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

      // Update bedroom range variables (using existing rooms)
      bedroomFrom = rooms.start.toInt();
      bedroomTo = rooms.end.toInt();

      // Update kitchen range variables
      kitchenFrom = kitchens.start.toInt();
      kitchenTo = kitchens.end.toInt();

      // Update washroom range variables
      washroomFrom = washrooms.start.toInt();
      washroomTo = washrooms.end.toInt();

      // Updated path with kitchen, washroom, and sortBy parameters
      String path =  "property/get?countryId=${gSelectedCountry!.countryId}&furnished=${furnished.value}&purpose=${isBuyerMode.value==null ? '': isBuyerMode.value==true?'Sell': 'Rent'}&page=${page.value}&fetch=${fetch.value}&cityId=${selectedCity.value !=null ? selectedCity.value!.cityId : ''}&locationId=${selectedLocation.value !=null ? selectedLocation.value?.locationId : ''}&subTypes=${subTypes.isNotEmpty  ? subTypes.join(",").toString() : ''}&subTypeId=${subTypeId.value > 0 ? subTypeId.value : ''}&bedroomFrom=${bedroomFrom > 0 ? bedroomFrom : ''}&bedroomTo=${bedroomTo > 0 ? bedroomTo : ''}&kitchenFrom=${kitchenFrom > 0 ? kitchenFrom : ''}&kitchenTo=${kitchenTo > 0 ? kitchenTo : ''}&washroomFrom=${washroomFrom > 0 ? washroomFrom : ''}&washroomTo=${washroomTo > 0 ? washroomTo : ''}&startPrice=${startPrice ?? ''}&endPrice=${endPrice ?? ''}&startSize=${startSize ?? ''}&endSize=${endSize ?? ''}&sortBy=${selectedSortBy.value}";

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
      });
      update();
    } catch (e) {
      isLoadingMore.value =false;
      showSnackBar(message: "Error");
      status(Status.error);
      update();
    }
  }
}

const List<String> furnished = ["Fully","Semi","Non"];