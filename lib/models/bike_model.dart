import 'package:careqar/models/feature_model.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../global_variables.dart';
import 'car_model.dart';

class BikeModel {

  List<Bike> bikes=[];

  BikeModel();
  BikeModel.fromMap(map) {
    for(var item in map){
      bikes.add(Bike.fromMap(item));
    }
  }
}

class Bike{
  Bike();

  int? bikeId;

  int? favoriteId;
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
  DateTime? createdAt;
  double? price;
  int? clicks;
  int? locationId;
  List<String> images=[];
  List<VehicleFeature> features=[];

  String? registrationCityAr;
  String? registrationCityEn;
  String? modelYear;

  int? brandId;
  String? brandNameEn;
  String? brandNameAr;
  String? color;
  String? mileage;
  int? seats;
  int? modelId;
  String? engine;
  bool? isUsed;
  String? referenceNo;
  String? condition;
  String? email;
  String? bodyType;
  int? stroke;
  List<FeatureHead> featureHeads=[];
  String? modelNameEn;
  String? modelNameAr;
  String? purpose;
  String? fuelType;
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
  Bike.fromMap(map){
    phoneNumber= map["PhoneNumber"]!=""?PhoneNumber(dialCode: map["CountryCode"],isoCode: map["IsoCode"]==""?gSelectedCountry?.isoCode:map["IsoCode"],
        phoneNumber: map["PhoneNumber"]
    ):phoneNumber;
    email=map["Email"]??"no email";
    isAgentAd=map["IsAgentAd"];
    purpose=map["Purpose"];
    paymentMethod=map["PaymentMethod"];
    modelId=map["ModelId"];
    modelYear=map["ModelYear"];
    modelNameAr=map["ModelNameAr"];
    modelNameEn=map["ModelName"];
    bodyType=map["BodyType"];
    stroke=map["Stroke"];
    referenceNo=map["RefferenceNo"];
    condition=map["Condition"];
    brandNameAr=map["BrandNameAr"];
    brandNameEn=map["BrandName"];
    registrationCityAr=map["RegistrationCityAr"];
    registrationCityEn=map["RegistrationCity"];
    isUsed=map["IsUsed"];
    engine=map["Engin"];
    mileage=map["Mileage"];
    color=map["Color"];
    brandId=map["BrandId"];
    isSold=map["IsSold"];
  createdAt=DateTime.parse(map["CreatedAt"]);
  companyId=map["CompanyId"]==0?null:map["CompanyId"];
  agentId=map["AgentId"]==0?null:map["AgentId"];
  agentImage=map["AgentImage"];
  agentImage=map["AgentImage"];
  coordinates=map["Coordinates"];
  contactNo=map["ContactNo"];
    agentName=map["AgentName"];
    clicks=map["Clicks"]; status=map["Status"];
    locationId=map["LocationId"];
    favoriteId=map["FavoriteId"];
    bikeId=map["BikeId"];
    titleAr=map["TitleAr"];
    titleEn=map["Title"];
    descriptionEn=map["Description"];
    descriptionAr=map["DescriptionAr"];
    typeEn=map["Type"];
    typeAr=map["TypeAr"];
    subTypeEn=map["SubType"];
    subTypeAr=map["SubTypeAr"];
    cityNameEn=map["CityName"];
    cityNameAr=map["CityNameAr"];
    locationEn=map["Location"];
    locationAr=map["LocationAr"];
    typeId=map["TypeId"];
    subTypeId=map["SubTypeId"];
    cityId=map["CityId"];
    price=map["Price"];
    fuelType=map["FuelType"];
    images.addAll(map["Images"].toString().split(",").toList());

    for(var item in map["BikeFeatures"]){
      features.add(VehicleFeature.fromMap(item));
    }

    FeatureHead? featureHead;
    for(var item in map["BikeFeatures"]){
      if (featureHead==null || featureHead.headId != item["HeadId"])
    {
    featureHead = FeatureHead();
    featureHead.headId =item["HeadId"];
    featureHead.titleEn = item["Head"];
    featureHead.titleAr = item["HeadAr"];
    featureHeads.add(featureHead);

    }

    Feature feature = Feature();
      feature.titleEn = item["Feature"];
      feature.titleAr = item["FeatureAr"];
    feature.featureId = item["FeatureId"];
    feature.quantity = item["Quantity"];
      feature.featureOption = item["FeatureOption"];
      feature.image = item["Image"];
    featureHead.features.add(feature);
    }
  }

}

class BikeFeature{
  int? bikeFeatureId;
  int? featureId;
  int? headId;
  String? featureOption;
  int? quantity;
  String? headAr;
  String? headEn;
  String? featureAr;
  String? featureEn;

  String? get feature => gSelectedLocale?.locale?.languageCode=="ar"?featureAr:featureEn;

  String? get head => gSelectedLocale?.locale?.languageCode=="ar"?headAr:headEn;
  BikeFeature();
  BikeFeature.fromMap(map){
    bikeFeatureId=map["BikeFeatureId"];
    featureId=map["FeatureId"];
    headId=map["HeadId"];
    featureOption=map["FeatureOption"];
    quantity=map["Quantity"];
    headEn=map["Head"];
    headAr=map["HeadAr"];
    featureAr=map["FeatureAr"];
    featureEn=map["Feature"];
  }
}


