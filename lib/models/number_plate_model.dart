import 'package:careqar/models/feature_model.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../global_variables.dart';

class NumberPlateModel {

  List<NumberPlate> numberPlates=[];

  NumberPlateModel();
  NumberPlateModel.fromMap(map) {
    for(var item in map){
      numberPlates.add(NumberPlate.fromMap(item));
    }
  }
}

class NumberPlate{
  NumberPlate();

  int? numberPlateId;

  late int favoriteId;
  String? agentName;



  String? titleAr;
  String? status;
  String? titleEn;
  String? descriptionEn;
  String? descriptionAr;
  String? typeAr;
  String? typeEn;
  String? subTypeAr;
  String? subTypeEn;
  String? cityNameAr;
  String? cityNameEn;
  String? agentImage;
  String? coordinates;
  String? locationAr;
  String? locationEn;
  int? typeId;
  int? subTypeId;
  int? cityId;
  int? companyId;
  int? agentId;
  bool? isSold;
  String? contactNo;
  var createdAt;
  late double price;
  int? clicks;
  int? locationId;
  List<String> images=[];

  String? registrationCityAr;
  String? registrationCityEn;
  String? modelYear;

  int? brandId;
  String? brandNameEn;
  String? brandNameAr;
  String? color;
  String? number;
  int? mileage;
  int? seats;
  int? modelId;
  String? engine;
  bool? isUsed;
  String? digits;
  String? privilege;
  String? plateType;
  int? stroke;
  List<FeatureHead> featureHeads=[];
  String? modelNameEn;
  String? modelNameAr;
  String? purpose;
  String? paymentMethod;
  String? get title => gSelectedLocale?.locale?.languageCode=="ar"?titleAr==null || titleAr=="" ? titleEn :titleAr : titleEn==null || titleEn=="" ?titleAr:titleEn;
  String? get description => gSelectedLocale?.locale?.languageCode=="ar"?descriptionAr==null || descriptionAr=="" ?descriptionEn:descriptionAr:

  descriptionEn==null || descriptionEn=="" ?descriptionAr:descriptionEn;
  String? get modelName => gSelectedLocale?.locale?.languageCode=="ar"?modelNameAr:modelNameEn;
  String? get type => gSelectedLocale?.locale?.languageCode=="ar"?typeAr:typeEn;
  String? get registrationCity => gSelectedLocale?.locale?.languageCode=="ar"?registrationCityAr:registrationCityEn;
  String? get brandName => gSelectedLocale?.locale?.languageCode=="ar"?brandNameAr:brandNameEn;
  String? get subType => gSelectedLocale?.locale?.languageCode=="ar"?subTypeAr:subTypeEn;

  String? get cityName => gSelectedLocale?.locale?.languageCode=="ar"?cityNameAr:cityNameEn;

  String? get location => gSelectedLocale?.locale?.languageCode=="ar"?locationAr:locationEn;
  PhoneNumber phoneNumber = PhoneNumber(isoCode: gSelectedCountry?.isoCode);
  int? isAgentAd;
  NumberPlate.fromMap(map){
    phoneNumber= map["PhoneNumber"]!=""?PhoneNumber(dialCode: map["CountryCode"],isoCode: map["IsoCode"]==""?gSelectedCountry?.isoCode:map["IsoCode"],
        phoneNumber: map["PhoneNumber"]
    ):phoneNumber;
    number=map["Number"];
    digits=map["Digits"];
    privilege=map["Privilege"];
    plateType=map["PlateType"];
    isSold=map["IsSold"];
  createdAt=DateTime.parse(map["CreatedAt"]);
  companyId=map["CompanyId"]==0?null:map["CompanyId"];
  agentId=map["AgentId"]==0?null:map["AgentId"];
    isAgentAd=map["IsAgentAd"];
  agentImage=map["AgentImage"];
  contactNo=map["ContactNo"];
    agentName=map["AgentName"];
    clicks=map["Clicks"]; status=map["Status"];
    favoriteId=map["FavoriteId"];
    numberPlateId=map["NumberPlateId"];
    descriptionEn=map["Description"];
    descriptionAr=map["DescriptionAr"];
    cityNameEn=map["CityName"];
    cityNameAr=map["CityNameAr"];
    cityId=map["CityId"];
    price=map["Price"];
    images.addAll(map["Images"].toString().split(",").toList());

  }

}



