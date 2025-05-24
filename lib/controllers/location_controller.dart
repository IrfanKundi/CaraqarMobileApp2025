

import 'package:careqar/models/city_model.dart';
import 'package:careqar/models/search_place_model.dart';
import 'package:careqar/services/location_service.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:careqar/user_session.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart' as mapLocation;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../enums.dart';
import '../global_variables.dart';

class LocationController extends GetxController {
  var status = Status.initial.obs;
  var searchText = "".obs;
  Rx<SearchPlaceModel> searchPlaceModel =
      Rx<SearchPlaceModel>(SearchPlaceModel());
  Rx<PlaceModel> selectedPlace = Rx<PlaceModel>(PlaceModel());
  Rx<CityModel> cityModel = Rx<CityModel>(CityModel());

  Rx<City?> selectedCity = Rx<City?>(null);

  @override
  void onInit() {

   getCities();
    // TODO: implement onInit
    super.onInit();
  }


  // determinePosition() async {
  //   mapLocation.Location location =  mapLocation.Location();
  //
  //   bool _serviceEnabled;
  //   mapLocation.PermissionStatus _permissionGranted;
  //   mapLocation.LocationData _locationData;
  //
  //   _serviceEnabled = await location.serviceEnabled();
  //   if (!_serviceEnabled) {
  //     _serviceEnabled = await location.requestService();
  //     if (!_serviceEnabled) {
  //       if(Platform.isAndroid){
  //         showAlertDialog(title: "Location",message: "Enable location services.");
  //
  //       }
  //      return false;
  //     }
  //   }
  //
  //   _permissionGranted = await location.hasPermission();
  //   if (_permissionGranted != mapLocation.PermissionStatus.granted) {
  //     _permissionGranted = await location.requestPermission();
  //     if (_permissionGranted != mapLocation.PermissionStatus.granted) {
  //      // showAlertDialog(title: "Location Permission",message: "Location permissions are denied for this app, please grant permissions first to continue.");
  //       return false;
  //     }
  //   }
  //   return true;
  //
  //  // EasyLoading.show();
  //
  //  //  _locationData = await location.getLocation();
  //  // // EasyLoading.dismiss();
  //  //  gCurrentLocation=LatLng(_locationData.latitude, _locationData.longitude);
  // }


  determinePosition() async {
    bool serviceEnabled;
    mapLocation.LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await mapLocation.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showAlertDialog(title: "Location",message: "Enable location services.");
    }

    permission = await mapLocation.Geolocator.checkPermission();
    if (permission == mapLocation.LocationPermission.denied) {
      permission = await mapLocation.Geolocator.requestPermission();
      if (permission == mapLocation.LocationPermission.denied) {
        showAlertDialog(title: "Location Permission",message: "Location permissions are denied for this app, please grant permissions first to continue.");
      }
    }

    if (permission == mapLocation.LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      showAlertDialog(title: "Location Permission",message: "Location permissions are permanently denied, we cannot request permissions.");
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    var currentLocation = await mapLocation.Geolocator.getCurrentPosition();

    gCurrentLocation=LatLng(currentLocation.latitude,currentLocation.longitude);
    UserSession.saveCurrentLocation(lat:currentLocation.latitude,lng:currentLocation.longitude);
  }



  Future<void> getCities() async {
    try {
      status(Status.loading);

      var response = await gApiProvider.get(path: "city/GetAllCities?countryId=${gSelectedCountry?.countryId}");



     return response.fold((l) {
       showSnackBar(message: l.message!);
        status(Status.error);
      }, (r) async {
        status(Status.success);
        cityModel.value = CityModel.fromMap(r.data);
        selectedCity.value = cityModel.value.cities.first;
        update(["city"]);
      });
    } catch (e) {

      showSnackBar(message: "Error");
      status(Status.error);
    }
  }

  Future<void> searchPlaces() async {
    try {
      status(Status.loading);

      var response = await LocationService.getAutocomplete(searchText.value);

      response.fold((l) {
        showSnackBar(message: l.message!);
        status(Status.error);
      }, (r) async {
        status(Status.success);
        searchPlaceModel.value = r;
      });
    } catch (e) {
      showSnackBar(message: "Error");
      status(Status.error);
    }
  }
}
