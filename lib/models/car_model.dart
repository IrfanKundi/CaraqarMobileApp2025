import 'package:careqar/models/feature_model.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../global_variables.dart';

class CarModel {

  List<Car> cars=[];

  CarModel();
  CarModel.fromMap(map) {
    for(var item in map){
      cars.add(Car.fromMap(item));
    }
  }
}

class Car{
  Car();
  int? carId;
  int? favoriteId;
  String? agentName;
  String? titleAr;
  String? status;
  String? purpose;
  String? paymentMethod;
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
  String? condition;
  String? registrationProvince;
  String? importedLocal;
  String? registrationYear;
  int? brandId;
  int? modelId;
  String? brandNameEn;
  String? brandNameAr;
  String? modelNameEn;
  String? modelNameAr;
  String? fuelType;
  String? transmission;
  String? color;
  String? mileage;
  int? seats;
  String? engine;
  bool? isUsed;
  List<FeatureHead> featureHeads=[];

  String? email;
  String? get title => gSelectedLocale?.locale?.languageCode=="ar"?titleAr==null || titleAr=="" ? titleEn :titleAr : titleEn==null || titleEn=="" ?titleAr:titleEn;
  String? get description => gSelectedLocale?.locale?.languageCode=="ar"?descriptionAr==null || descriptionAr=="" ?descriptionEn:descriptionAr:

  descriptionEn==null || descriptionEn=="" ?descriptionAr:descriptionEn;

  String? get type => gSelectedLocale?.locale?.languageCode=="ar"?typeAr:typeEn;
  String? get registrationCity => gSelectedLocale?.locale?.languageCode=="ar"?registrationCityAr:registrationCityEn;
  String? get brandName => gSelectedLocale?.locale?.languageCode=="ar"?brandNameAr:brandNameEn;
  String? get modelName => gSelectedLocale?.locale?.languageCode=="ar"?modelNameAr:modelNameEn;
  String? get subType => gSelectedLocale?.locale?.languageCode=="ar"?subTypeAr:subTypeEn;

  String? get cityName => gSelectedLocale?.locale?.languageCode=="ar"?cityNameAr:cityNameEn;

  String? get location => gSelectedLocale?.locale?.languageCode=="ar"?locationAr:locationEn;
  PhoneNumber phoneNumber = PhoneNumber(isoCode: gSelectedCountry?.isoCode);
  int? isAgentAd;
  Car.fromMap(map){
    phoneNumber= map["PhoneNumber"]!=""?PhoneNumber(dialCode: map["CountryCode"],isoCode: map["IsoCode"]==""?gSelectedCountry?.isoCode:map["IsoCode"],
        phoneNumber: map["PhoneNumber"]
    ):phoneNumber;
    email=map["Email"]?? "no email";
    purpose=map["Purpose"];
    isAgentAd=map["IsAgentAd"];
    paymentMethod=map["PaymentMethod"];
    modelNameAr=map["ModelNameAr"];
    modelNameEn=map["ModelName"];
    brandNameAr=map["BrandNameAr"];
    brandNameEn=map["BrandName"];
    registrationCityAr=map["RegistrationCityAr"];
    registrationCityEn=map["RegistrationCity"];
    modelYear=map["ModelYear"];
    isUsed=map["IsUsed"];
    seats=map["Seats"];
    engine=map["Engin"];
    mileage=map["Mileage"];
    color=map["Color"];
    transmission=map["Transmission"];
    fuelType=map["FuelType"];
    brandId=map["BrandId"];
    modelId=map["ModelId"];
    condition=map["Condition"];
    registrationProvince=map["RegistrationProvince"];
    importedLocal=map["ImportedLocal"];
    registrationYear=map["RegistrationYear"];
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
    carId=map["CarId"];
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
    images.addAll(map["Images"].toString().split(",").toList());

    for(var item in map["CarFeatures"]){
      features.add(VehicleFeature.fromMap(item));
    }

    FeatureHead? featureHead;
    for(var item in map["CarFeatures"]){
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

class VehicleFeature{
  int? carFeatureId;
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
  VehicleFeature();
  VehicleFeature.fromMap(map){
    carFeatureId=map["CarFeatureId"];
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


