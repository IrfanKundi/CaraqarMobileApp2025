
import 'package:careqar/global_variables.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class RequestModel {

  List<Request> requests=[];

  RequestModel();
  RequestModel.fromMap(map) {
    for(var item in map){
      requests.add(Request.fromMap(item));
    }
  }
}

class Request{
  int? requestId;
  int? locationId;

  int? typeId;
  int? subTypeId;
  String? purpose;
  int? cityId;
  String? typeEn;
  String? typeAr;
  String? subTypeAr;
  String? subTypeEn;
  String? cityNameAr;
  String? cityNameEn;
  PhoneNumber? phoneNumber = PhoneNumber(isoCode: gSelectedCountry?.isoCode);
  String? email;
  double? area;
  double? startPrice;
  double? endPrice;
  int? bedrooms;
  int? floors;
  int? baths;
  int? kitchens;
  String? status;
  String? furnished;

  String? locationAr;
  String? locationEn;

  String? customerName;
  String? customerImage;
  String? coordinates;
  Request();

  String? get type => gSelectedLocale?.locale?.languageCode=="ar"?typeAr:typeEn;
  String? get subType => gSelectedLocale?.locale?.languageCode=="ar"?subTypeAr:subTypeEn;

  String? get cityName => gSelectedLocale?.locale?.languageCode=="ar"?cityNameAr:cityNameEn;

  String? get location => gSelectedLocale?.locale?.languageCode=="ar"?locationAr:locationEn;
  Request.fromMap(map){
    coordinates=map["Coordinates"];
    furnished=map["Furnished"];
    floors=map["Floors"]??0;
    customerName=map["CustomerName"];
    customerImage=map["CustomerImage"];
    email=map["Email"];
    phoneNumber= map["PhoneNumber"]!=""?PhoneNumber(dialCode: map["CountryCode"],isoCode: map["IsoCode"]==""?gSelectedCountry?.isoCode:map["IsoCode"],
        phoneNumber: map["PhoneNumber"]
    ):phoneNumber;
    status=map["Status"];
    requestId=map["RequestId"];
    locationId=map["LocationId"];
    typeAr=map["TypeAr"];
    typeEn=map["Type"];

    subTypeAr=map["SubTypeAr"];
    subTypeEn=map["SubType"];

    cityNameAr=map["CityNameAr"];
    cityNameEn=map["CityName"];

    locationAr=map["LocationAr"];
    locationEn=map["Location"];
    typeId=map["TypeId"];
    subTypeId=map["SubTypeId"];
    purpose=map["Purpose"];
    cityId=map["CityId"];
    area=map["Area"];
    purpose=map["Purpose"];
    startPrice=map["StartPrice"];
    endPrice=map["EndPrice"];
    bedrooms=map["Bedrooms"];
    baths=map["Baths"];
    kitchens=map["Kitchens"];
  }

}



