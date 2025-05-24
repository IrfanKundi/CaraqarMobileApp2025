
import 'package:careqar/models/city_model.dart';

import '../global_variables.dart';

class TypeModel {

  List<Type> types=[];

  TypeModel();
  TypeModel.fromMap(map) {
    for(var item in map){
      types.add(Type(item));
    }
  }
}

class Type{
  int? typeId;
  String? typeAr;
  String? typeEn;
  String? image;
  String? color;
  String? color2;
  List<SubType> subTypes=[];
  List<AreaSize> areaSizes=[];
  List<Location> locations=[];

  String? get type => gSelectedLocale?.locale?.languageCode=="ar"?typeAr:typeEn;

  Type(map){
    typeId=map["TypeId"];
    image=map["Image"];
    typeEn=map["Type"];
    typeAr=map["TypeAr"];
    color=map["Color"];
    color2=map["Color2"];

    for(var item in map["SubTypes"]??[]){
      subTypes.add(SubType(item));
    }
    for(var item in map["AreaSizes"]??[]){
      areaSizes.add(AreaSize(item));
    }

    for(var item in map["Locations"]??[]){
      locations.add(Location(item));
    }
  }
}

class SubType{
  int? subTypeId;
  String? image;
  String? subTypeEn;
  String? subTypeAr;
  bool? rooms;
  bool? bathrooms;
  bool? kitchens;
  bool? floors;
  bool? furnish;

  String? get subType => gSelectedLocale?.locale?.languageCode=="ar"?subTypeAr:subTypeEn;

  SubType(map){
    subTypeId=map["SubTypeId"];
    subTypeEn=map["SubType"];
    subTypeAr=map["SubTypeAr"];
    image=map["Image"];
    rooms=map["Rooms"];
    bathrooms=map["Bathrooms"];
    kitchens=map["Kitchens"];
    floors=map["Floors"];
    furnish=map["Furnish"];

  }
}

class AreaSize{
  int? areaSizeId;
  double? startSize;
  double? endSize;

  AreaSize(map){
    areaSizeId=map["AreaSizeId"];
    startSize=map["StartSize"];
    endSize=map["EndSize"];
  }
}