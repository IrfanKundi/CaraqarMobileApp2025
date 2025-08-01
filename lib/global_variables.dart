import 'dart:io';

import 'package:careqar/locale/app_localizations.dart';
import 'package:careqar/models/country_model.dart';
import 'package:careqar/resources/api_provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import 'controllers/content_controller.dart';

const int gRoleId = 2;

final GlobalKey<NavigatorState> gNavigatorKey = GlobalKey<NavigatorState>();


GlobalKey<ScaffoldState>? gScaffoldStateKey;

final RouteObserver<PageRoute> gRouteObserver = RouteObserver<PageRoute>();
//final Repository gRepository = Repository();
//Uri gDeepLink;
//String gPopUntil;
AppLocale? gSelectedLocale;
String? gVehicleType;
bool gIsVehicle=false;
Country? gSelectedCountry;
//Address gSelectedAddress;
LatLng? gCurrentLocation;
final ApiProvider gApiProvider=ApiProvider();
var gBox;
var gContentController = Get.put(ContentController());
bool deepLinkHandled = false;
final priceFormat = NumberFormat("#,##0", "en_US");
String getPrice(double price){
  if (price == 0) {
    return "Call for Price".tr;
  }
  return "${gSelectedCountry?.currency} ${priceFormat.format(price)} ";
}



Future<String?> getDeviceId() async {
  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) { // import 'dart:io'
    var iosDeviceInfo = await deviceInfo.iosInfo;
    return iosDeviceInfo.identifierForVendor; // unique ID on iOS
  } else {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    return androidDeviceInfo.id; // unique ID on Android
  }
}

final gVehicleColors=[
  VehicleColor("White", Colors.white),
  VehicleColor("Black", Colors.black),
  VehicleColor("Red", Colors.red),
  VehicleColor("Green", Colors.green),
  VehicleColor("Orange", Colors.deepOrange),
  VehicleColor("Brown", Colors.brown),
  VehicleColor("Gold", Colors.orangeAccent),
  VehicleColor("Grey", Colors.grey),
  VehicleColor("Silver", Colors.grey.shade300),
  VehicleColor("DarkBlue", Colors.indigoAccent),
  VehicleColor("Silver", Colors.grey.shade300),
  VehicleColor("Grey", Colors.grey),
  VehicleColor("Blue", Colors.indigo[900]!),
  VehicleColor("Green", Colors.green[800]!),
  VehicleColor("Red", Colors.red),
  VehicleColor("Gold", Color(0xFFFFD700)), // Custom gold
  VehicleColor("Maroon", Colors.brown[900]!),
  VehicleColor("Beige", Color(0xFFF5F5DC)), // Custom beige
  VehicleColor("Pink", Colors.pink),
  VehicleColor("Brown", Colors.brown),
  VehicleColor("Burgundy", Color(0xFF800020)), // Custom burgundy
  VehicleColor("Yellow", Colors.yellow[700]!),
  VehicleColor("Bronze", Color(0xFFCD7F32)), // Custom bronze
  VehicleColor("Purple", Colors.purple[800]!),
  VehicleColor("Turquoise", Colors.cyanAccent[400]!),
  VehicleColor("Orange", Colors.orange),
  VehicleColor("Indigo", Colors.indigo),
  VehicleColor("Magenta", Color(0xFFFF00FF)), // Custom magenta
];

class VehicleColor{
  String name;
  Color color;
  VehicleColor(this.name,this.color);
}