
import '../global_variables.dart';

class ServiceModel {

  List<Service> services=[];

  ServiceModel();
  ServiceModel.fromMap(map) {
    for(var item in map){
      services.add(Service(item));
    }
  }
}

class Service{
  int? serviceId;
  String? serviceNameAr;
  String? serviceNameEn;
  String? image;

  String? get serviceName => gSelectedLocale?.locale?.languageCode=="ar"?serviceNameAr:serviceNameEn;

  Service(map){
    serviceId=map["ServiceId"];
    image=map["Image"];
    serviceNameAr=map["ServiceNameAr"];
    serviceNameEn=map["ServiceName"];
  }
}


class SubService{
  int? subServiceId;
  String? subServiceNameAr;
  String? subServiceNameEn;
  String? image;

  String? get subServiceName => gSelectedLocale?.locale?.languageCode=="ar"?subServiceNameAr:subServiceNameEn;

  SubService(map){
    subServiceId=map["SubServiceId"];
    image=map["Image"];
    subServiceNameAr=map["SubServiceNameAr"];
    subServiceNameEn=map["SubServiceName"];
  }
}

class ServiceProvider{
  int? serviceDetailId;
  int? subServiceId;
  String? companyNameAr;
  String? companyNameEn;
  String? subServiceNameAr;
  String? subServiceNameEn;
  String? image;
  String? coordinates;
  String? address;
  String? contactNo;
  int? serviceId;
  String? serviceNameAr;
  String? serviceNameEn;
  String? cityNameAr;
  String? cityNameEn;

  String? get serviceName => gSelectedLocale?.locale?.languageCode=="ar"?serviceNameAr:serviceNameEn;
  String? get subServiceName => gSelectedLocale?.locale?.languageCode=="ar"?subServiceNameAr:subServiceNameEn;
  String? get companyName => gSelectedLocale?.locale?.languageCode=="ar"?companyNameAr:companyNameEn;
  String? get cityName => gSelectedLocale?.locale?.languageCode=="ar"?cityNameAr:cityNameEn;
  ServiceProvider(map){
    subServiceId=map["SubServiceId"];
    serviceId=map["ServiceId"];
    serviceDetailId=map["ServiceDetailId"];
    image=map["Image"];
    address=map["Address"];
    contactNo=(map["CountryCode"]??'')+(map["ContactNo"]??'');
    coordinates=(map["Latitude"]??'')+(map["Longitude"]??'');
    subServiceNameAr=map["SubServiceNameAr"];
    subServiceNameEn=map["SubServiceName"];
    serviceNameAr=map["ServiceNameAr"];
    serviceNameEn=map["ServiceName"];
    companyNameAr=map["NameAr"];
    companyNameEn=map["Name"];

    cityNameAr=map["CityNameAr"];
    cityNameEn=map["CityName"];
  }
}