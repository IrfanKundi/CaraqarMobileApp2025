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

class CountriesSplashScreen extends StatefulWidget{
  const CountriesSplashScreen({Key? key}) : super(key: key);

  @override
  State<CountriesSplashScreen> createState() => _CountriesSplashScreenState();
}

class _CountriesSplashScreenState extends State<CountriesSplashScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
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
              const SizedBox(height: 30,),
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
            ],
          ),
        ),
      ),
    );
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
        countryImage="pakistan.jpg";
        break;
      case 10:
        countryName="WelcomeToTunisia";
        countryImage="pakistan.jpg";
        break;
      case 9:
        countryName="WelcomeToBahrain";
        countryImage="pakistan.jpg";
        break;
      case 8:
        countryName="WelcomeToTurkey";
        countryImage="turkey.jpg";
        break;
      case 7:
        countryName="WelcomeToOman";
        countryImage="pakistan.jpg";
        break;
      case 6:
        countryName="WelcomeToKuwait";
        countryImage="pakistan.jpg";
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
        countryImage="pakistan.jpg";
        break;
    }
    if(isName) {
      return countryName;
    } else {
      return countryImage;
    }
  }



}

