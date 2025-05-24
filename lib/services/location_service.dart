import 'dart:convert';
import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/models/error_model.dart';
import 'package:careqar/models/search_place_model.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:http/http.dart' as http;


class LocationService {

  static Future<Either<ErrorModel, SearchPlaceModel>> getAutocomplete(String search) async {
    try{
      var url =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&components=country:om|country:pk&key=$kGoogleApiKey';
      var response = await http.get(Uri.parse(url));
      var parsedBody = jsonDecode(response.body);


      if (response.statusCode == 200) {
        return right(SearchPlaceModel.fromJson(parsedBody['predictions']));
      } else {
        return left(ErrorModel(message: parsedBody["message"],
            title: "Error".tr,
            errorCode: response.statusCode));
      }
    } on SocketException {
      return left(ErrorModel(
          message: "NoInternetConnection".tr, title: "Error".tr, errorCode: 400));
    } on Exception {
      return left(ErrorModel(message: "SomethingWentWrong".tr,
          title: "Error".tr,
          errorCode: 400));
    }

  }

  static Future<Either<ErrorModel, Distance>> calculateDistance(String origin,String destination) async {
    try{
      var url =
          'https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=$origin&destinations=$destination&key=$kGoogleApiKey';
      var response = await http.get(Uri.parse(url));
      var parsedBody = jsonDecode(response.body);




      if (response.statusCode == 200) {
        return right(Distance(parsedBody["rows"][0]["elements"][0]));
      } else {
        return left(ErrorModel(message: parsedBody["message"],
            title: "Error".tr,
            errorCode: response.statusCode));
      }
    } on SocketException {
      return left(ErrorModel(
          message: "NoInternetConnection".tr, title: "Error".tr, errorCode: 400));
    } on Exception {
      return left(ErrorModel(message: "SomethingWentWrong".tr,
          title: "Error".tr,
          errorCode: 400));
    }

  }


  static Future<Either<ErrorModel, PlaceModel>> getPlace(String placeId) async {
    try{
      var url =
          'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$kGoogleApiKey';
      var response = await http.get(Uri.parse(url));
      var parsedBody = jsonDecode(response.body);


      if (response.statusCode == 200) {
        return right(PlaceModel.fromJson( parsedBody['result']));
      } else {
        return left(ErrorModel(message: parsedBody["message"],
            title: "Error".tr,
            errorCode: response.statusCode));
      }
    } on SocketException {
      return left(ErrorModel(
          message: "NoInternetConnection".tr, title: "Error".tr, errorCode: 400));
    } on Exception {
      return left(ErrorModel(message: "SomethingWentWrong".tr,
          title: "Error".tr,
          errorCode: 400));
    }

  }

  static Future<Position?> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Please enable location permission from app setting, Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }




}

