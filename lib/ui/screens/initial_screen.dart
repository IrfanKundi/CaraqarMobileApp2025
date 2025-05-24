import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/global_variables.dart';
import 'package:careqar/locale/app_localizations.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/services/location_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../user_session.dart';

class InitialScreen extends StatefulWidget{
  const InitialScreen({Key? key}) : super(key: key);

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {

  bool init=true;

  @override
  void didChangeDependencies() async {
    if (init) {
      init = false;

      if (!AppLocalizations.isFirstLaunch) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.offNamed(Routes.chooseOptionScreen);
        });
      }

      if (await UserSession.getCountry() == null) { // Check if country is not null in Session
        Position? currentLocation = await LocationService.determinePosition(); // Get Current Location
        if (currentLocation != null) {
          String? country = await getCountryFromCoordinates(currentLocation.longitude, currentLocation.latitude); // Get Country Name if not null
          if (country != null) {
            setCountry(country); // Setting country
          }
        }

      }

      super.didChangeDependencies();
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: kWhiteColor,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/images/${checkCountry(isName: false)}"),alignment: Alignment.center,fit: BoxFit.fitHeight)
          ),
          height:1.sh,
          width: 1.sw,
          child: Column(
            children: [
              Image.asset(
                gSelectedLocale?.langCode==0? "assets/images/logo-en.png":"assets/images/logo-ar.png",
                width: 220.w,
                height: 220.w,
              ),
              if(AppLocalizations.isFirstLaunch)
                SizedBox(height: 30.h,),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                  child: Text(
                    "${checkCountry(isName: true)}".tr,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                  SizedBox(
                width: 200.w,
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: ()async {
                          await AppLocalizations.future;
                          await AppLocalizations.setLocale(supportedLocales[0]);

                          Get.offNamed(Routes.chooseOptionScreen);

                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 35.w,
                          decoration: BoxDecoration(
                            color:   gSelectedLocale?.langCode==0
                                ? kPrimaryColor
                                : Colors.transparent,
                            border: Border.all(color: kPrimaryColor),
                            borderRadius: BorderRadiusDirectional.horizontal(start: Radius.circular(30.r)),
                          ),
                          child: Text(
                              "English",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color:   gSelectedLocale?.langCode==0
                                    ? kWhiteColor
                                    : kPrimaryColor,
                                fontSize: 16.sp,
                                fontWeight:
                                FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        child: GestureDetector(
                          onTap: () async{
                            await AppLocalizations.future;
                            await AppLocalizations.setLocale(supportedLocales[1]);
                              Get.offNamed(Routes.chooseOptionScreen);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 35.w,
                            decoration: BoxDecoration(  border: Border.all(color: kPrimaryColor),
                              color:gSelectedLocale?.langCode==1
                                  ? kPrimaryColor:Colors.transparent
                              ,
                              borderRadius: BorderRadiusDirectional.horizontal(end: Radius.circular(30.r)),
                            ),
                            child: Text(
                              "العربية",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color:   gSelectedLocale?.langCode==1
                                      ? kWhiteColor
                                      : kPrimaryColor,
                                  fontSize: 16.sp,
                                  fontWeight:
                                  FontWeight.w600),
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  // Change Country Globally
  Future<Function?> setCountry(String country) async {
    int? countryId;
      switch (country) {
        case "Egypt":
          countryId=12;
          break;
        case "Pakistan":
          countryId=11;
          break;
        case "Tunisia":
          countryId=10;
          break;
        case "Bahrain":
          countryId=9;
          break;
        case "Turkey":
          countryId=8;
          break;
        case "Oman":
          countryId=7;
          break;
        case "Kuwait":
          countryId=6;
          break;
        case "United Arab Emirates":
          countryId=5;
          break;
        case "Saudi Arabia":
          countryId=4;
          break;
        case "Qatar":
          countryId=1;
          break;
        default:
          countryId=11;
          break;
      }
    UserSession.changeCountry(countryId);
    return null;
  }

  String checkCountry({bool isName=true}) {
    int? countryId = UserSession.country;
    String countryName;
    String countryImage;
    switch (countryId) {
      case 12:
        countryName="WelcomeToEgypt";
        countryImage="Egypt.jpg";
        break;
      case 11:
        countryName="WelcomeToPakistan";
        countryImage="Pakistan.jpg";
        break;
      case 10:
        countryName="WelcomeToTunisia";
        countryImage="Pakistan.jpg";
        break;
      case 9:
        countryName="WelcomeToBahrain";
        countryImage="Pakistan.jpg";
        break;
      case 8:
        countryName="WelcomeToTurkey";
        countryImage="turkey.jpg";
        break;
      case 7:
        countryName="WelcomeToOman";
        countryImage="Pakistan.jpg";
        break;
      case 6:
        countryName="WelcomeToKuwait";
        countryImage="Pakistan.jpg";
        break;
      case 5:
        countryName="WelcomeToUnitedArabEmirates";
        countryImage="UnitedArabEmirates.jpg";
        break;
      case 4:
        countryName="WelcomeToSaudiArabia";
        countryImage="SaudiArabia.jpg";
        break;
      case 1:
        countryName="WelcomeToQatar";
        countryImage="Qatar.jpg";
        break;
      default:
        countryName="WelcomeToPakistan";
        countryImage="Pakistan.jpg";
        break;
    }
    if(isName) {
      return countryName;
    } else {
      return countryImage;
    }
  }


  // Get Country Name
  Future<String?> getCountryFromCoordinates(double longitude,double latitude) async {


    final String apiUrl = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$kGoogleApiKey';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'];

        if (results.isNotEmpty) {
          for (var result in results) {
            final List<dynamic> addressComponents = result['address_components'];
            for (var component in addressComponents) {
              final List<dynamic> types = component['types'];
              if (types.contains('country')) {
                return component['long_name'];
              }
            }
          }
        }
      }

      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting country: $e');
      }
      return null;
    }
  }


}

