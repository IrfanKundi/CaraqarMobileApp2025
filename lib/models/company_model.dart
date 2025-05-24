
import 'package:careqar/models/number_plate_model.dart';
import 'package:careqar/models/property_model.dart';

import '../global_variables.dart';
import 'bike_model.dart';
import 'car_model.dart';

class CompanyModel {

  List<Company> companies=[];

  CompanyModel();
  CompanyModel.fromMap(map) {
    for(var item in map){
      companies.add(Company(item));
    }
  }
}

class Company{
  int? companyId;
  int? followId;
  String? companyNameAr;
  String? companyNameEn;
  String? descriptionAr;
  String? descriptionEn;

  String? image;
  String? logo;
  String? address;
  String? contactNo;
  String? email;
  int? totalAds;
  int followers=0;
  int? totalViews;
  List<Property> ads=[];
  List<Car> cars=[];
  List<Bike> bikes=[];
  List<NumberPlate> numberPlates=[];

  String? get companyName => gSelectedLocale?.locale?.languageCode=="ar"?companyNameAr:companyNameEn;
  String? get description => gSelectedLocale?.locale?.languageCode=="ar"?descriptionAr:descriptionEn;

  Company(map){
    followId=map["FollowId"];
    totalAds=map["TotalAds"]??0;
    totalViews=map["TotalViews"]??0;
    followers=map["Followers"]??0;
    logo=map["Logo"];
    companyId=map["CompanyId"];
    image=map["Image"];
    companyNameAr=map["CompanyNameAr"];
    companyNameEn=map["CompanyName"];
    descriptionAr=map["DescriptionAr"];
    descriptionEn=map["Description"];
    image=map["Image"];
    address=map["Address"];
    contactNo=map["ContactNo"];
    email=map["Email"];
  }
}
