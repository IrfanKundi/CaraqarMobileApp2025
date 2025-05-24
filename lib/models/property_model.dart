import 'package:careqar/models/feature_model.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../global_variables.dart';

class PropertyModel {

  List<Property> properties=[];

  PropertyModel();
  PropertyModel.fromMap(map) {
    for(var item in map){
      properties.add(Property.fromMap(item));
    }
  }
}

class Property{
  int? propertyId;
  PhoneNumber phoneNumber = PhoneNumber(isoCode: gSelectedCountry?.isoCode);

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
  String? furnished;
  String? cityNameAr;
  String? cityNameEn;
  String? agentImage;
  late String coordinates;
  String? locationAr;
  String? locationEn;
  int? typeId;
  int? subTypeId;
  String? purpose;
  int? cityId;
  int? companyId;
  int? agentId;
  bool? isSold;
  String? contactNo;
  String? email;
  DateTime? createdAt;
  double? area;
  double? price;
  int? bedrooms;
  int? clicks;
  int? baths;
  int? kitchens;
  int? floors;
  int? locationId;
  List<String> images=[];
  List<PropertyFeature> features=[];

  List<FeatureHead> featureHeads=[];

  Property(){
    bedrooms=1;
    baths=1;
    kitchens=1;
    floors=1;
  }
  int? isAgentAd;
  String? get title => gSelectedLocale?.locale?.languageCode=="ar"?titleAr==null || titleAr=="" ? titleEn :titleAr : titleEn==null || titleEn=="" ?titleAr:titleEn;
  String? get description => gSelectedLocale?.locale?.languageCode=="ar"?descriptionAr==null || descriptionAr=="" ?descriptionEn:descriptionAr:

  descriptionEn==null || descriptionEn=="" ?descriptionAr:descriptionEn;

  String? get type => gSelectedLocale?.locale?.languageCode=="ar"?typeAr:typeEn;
  String? get subType => gSelectedLocale?.locale?.languageCode=="ar"?subTypeAr:subTypeEn;

  String? get cityName => gSelectedLocale?.locale?.languageCode=="ar"?cityNameAr:cityNameEn;

  String? get location => gSelectedLocale?.locale?.languageCode=="ar"?locationAr:locationEn;
  Property.fromMap(map){
    isAgentAd=map["IsAgentAd"];
    phoneNumber= map["PhoneNumber"]!=""?PhoneNumber(dialCode: map["CountryCode"],isoCode: map["IsoCode"]==""?gSelectedCountry?.isoCode:map["IsoCode"],
        phoneNumber: map["PhoneNumber"]
    ):phoneNumber;
    companyId=map["CompanyId"]==0?null:map["CompanyId"];
    isSold=map["IsSold"];
  createdAt=DateTime.parse(map["CreatedAt"]);
  // companyId=map["CompanyId"]==0?null:map["CompanyId"];
  agentId=map["AgentId"]==0?null:map["AgentId"];
  email=map["Email"]??"devirfankundi@gmail.com";
  agentImage=map["AgentImage"];
  floors=map["Floors"];
  coordinates=map["Coordinates"];
  contactNo=map["ContactNo"];
  furnished=map["Furnished"];
    agentName=map["AgentName"];
    clicks=map["Clicks"]; status=map["Status"];
    locationId=map["LocationId"];
    favoriteId=map["FavoriteId"];
    propertyId=map["PropertyId"];
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
    purpose=map["Purpose"];
    cityId=map["CityId"];
    area=map["Area"];
    purpose=map["Purpose"];
    price=map["Price"];
    bedrooms=map["Bedrooms"];
    baths=map["Baths"];
    kitchens=map["Kitchens"];
    images.addAll(map["Images"].toString().split(",").toList());

    for(var item in map["PropertyFeatures"]){
      features.add(PropertyFeature.fromMap(item));
    }

    FeatureHead? featureHead;
    for(var item in map["PropertyFeatures"]){
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

class PropertyFeature{
  int? propertyFeatureId;
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
  PropertyFeature();
  PropertyFeature.fromMap(map){
    propertyFeatureId=map["PropertyFeatureId"];
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


