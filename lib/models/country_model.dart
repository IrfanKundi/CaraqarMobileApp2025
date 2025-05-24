import '../global_variables.dart';

class CountryModel {

  List<Country> countries=[];

  CountryModel();
  CountryModel.fromMap(map) {
    for(var item in map){
      countries.add(Country(item));
    }
  }
}

class Country{
  int? countryId;
  String? nameAr;
  String? countryCode;
  String? isoCode;
  String? mapImage;
  String? currencyAr;
  String? currencyEn;
  String? nameEn;
  String? flag;

  String? get name => gSelectedLocale?.locale?.languageCode=="ar"?nameAr:nameEn;
  String? get currency => gSelectedLocale?.locale?.languageCode=="ar"?currencyAr:currencyEn;



  Country(map){
    String newMapImage = map["MapImage"] ?? '';
    isoCode=map["IsoCode"];
    mapImage=newMapImage.replaceAll('\r\n', '');
    flag=map["Flag"];
    currencyEn=map["Currency"];
    currencyAr=map["CurrencyAr"];
    countryCode=map["CountryCode"];
    countryId=map["CountryId"];
    nameEn=map["CountryName"];
    nameAr=map["CountryNameAr"];
  }
}

