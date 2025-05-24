import 'package:careqar/models/property_model.dart';

import '../global_variables.dart';

class CityModel {

  List<City> cities=[];

  CityModel();
  CityModel.fromMap(map) {
    for(var item in map){
      cities.add(City(item));
    }
  }
}

class City{
  int? cityId;
  int? locationId;
  int? totalAds;
  String? nameAr;
  String? nameEn;
  List<Location> locations=[];
  List<Property> ads=[];

  String? get name => gSelectedLocale?.locale?.languageCode=="ar"?nameAr:nameEn;

  City(map){
    locationId=map["LocationId"];
    totalAds=map["TotalAds"];
    cityId=map["CityId"];
    nameEn=map["CityName"];
    nameAr=map["CityNameAr"];
    for(var item in map["Locations"]??[]){
      locations.add(Location(item));
    }
  }
}


class Location{
  int? locationId;
  String? titleAr;
  String? titleEn;

  String? get title => gSelectedLocale?.locale?.languageCode=="ar"?titleAr:titleEn;

  Location(map){
    locationId=map["LocationId"];
    titleEn=map["Title"];
    titleAr=map["TitleAr"];
  }
}


class ForeignerCity{
  int? locationId;
  int? cityId;
  String? titleAr;
  String? titleEn;
  List<Property> ads=[];

  String? get title => gSelectedLocale?.locale?.languageCode=="ar"?titleAr:titleEn;

  ForeignerCity(map){
    locationId=map["LocationId"];
    cityId=map["CityId"];
    titleEn=map["CityName"]??map["Title"];
    titleAr=map["CityNameAr"]??map["TitleAr"];
  }
}


