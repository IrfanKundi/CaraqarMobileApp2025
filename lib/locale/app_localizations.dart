import 'dart:async';
import 'dart:convert';

import 'package:careqar/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../global_variables.dart';
import '../routes.dart';


const _appLocaleKey = "app-locale";

class AppLocale{
  int? langCode;
  Locale? locale;
  String? name;
  AppLocale(this.locale,this.langCode,this.name);

  AppLocale.fromCode(int code){
    langCode=supportedLocales[code].langCode;
    locale=supportedLocales[code].locale;
    name=supportedLocales[code].name;
  }
}

final supportedLocales=[AppLocale(const Locale("en","US"),0,"English"),AppLocale(const Locale("ar","OM"),1,"Arabic")];



class AppLocalizations {
  static bool isFirstLaunch=true;
 static Future? future;

  static Map<String, Map<String, String>> translationsKeys = {};


 static Future<void> setLocale(AppLocale locale) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt(_appLocaleKey, locale.langCode!);
    gSelectedLocale=locale;
    Get.updateLocale(gSelectedLocale!.locale!);
  }

  static Future<void> getLocale() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var lang=sharedPreferences.getInt(_appLocaleKey);
    gSelectedLocale = AppLocale.fromCode(lang??0);
    if(lang!=null){
      isFirstLaunch=false;
    }

  }

  static Future<void> load() async {
    translationsKeys.clear();




    for(var locale in supportedLocales){
      var response = await get(Uri.parse('$kFileBaseUrl/GetJson/JsonFile?fileName=${locale.locale?.languageCode}.json'), headers: {
        "content-type": "application/json",
        "accept": "application/json",}
      );
      if(response.statusCode==200){

        Map<String, dynamic> jsonMap = jsonDecode(utf8.decode(response.bodyBytes));

        Map<String, String>  localizedStrings = jsonMap.map((key, value) {
          return MapEntry(key.toString(), value.toString());
        });
        translationsKeys["${locale.locale?.languageCode}_${locale.locale?.countryCode}"]=localizedStrings;
        Get.addTranslations(translationsKeys);
        if(isFirstLaunch){
        await  setLocale(gSelectedLocale!);
        }else{
          Get.updateLocale(gSelectedLocale!.locale!);
        }
      }else{
        //await showAlertDialog(title: "Error",message: "Something went wrong");
        Get.offNamedUntil(Routes.chooseOptionScreen, (route) => false);
      }
    }
  }


  // Helper method to keep the code in the widgets concise
  // Localizations are accessed using an InheritedWidget "of" syntax
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(gNavigatorKey.currentContext!, AppLocalizations);
  }


  // This method will be called from every widget which needs a localized text
  String translate(String? key) {
    return key ?? "";
  }
}

