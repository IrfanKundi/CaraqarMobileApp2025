
import '../global_variables.dart';

class BrandModel {

  List<Brand> brands=[];

  BrandModel();
  BrandModel.fromMap(map) {
    for(var item in map){
      brands.add(Brand(item));
    }
  }
}

class Brand{
  int? brandId;
  String? brandNameAr;
  String? brandNameEn;
  String? image;

  String? get brandName => gSelectedLocale?.locale?.languageCode=="ar"?brandNameAr:brandNameEn;

  Brand(map){
    brandId=map["BrandId"];
    image=map["Image"];
    brandNameAr=map["BrandNameAr"];
    brandNameEn=map["BrandName"];
  }
}


class Model{
  int? modelId;
  String? modelNameAr;
  String? modelNameEn;

  String? get modelName => gSelectedLocale?.locale?.languageCode=="ar"?modelNameAr:modelNameEn;

  Model(map){
    modelId=map["ModelId"];
    modelNameAr=map["ModelNameAr"];
    modelNameEn=map["ModelName"];
  }
}

class Engine{
  int? engineId;
  String? engineNameAr;
  String? engineNameEn;

  String? get engineName => gSelectedLocale?.locale?.languageCode=="ar"?engineNameAr:engineNameEn;

  Engine(map){
    engineId=map["EngineId"];
    engineNameAr=map["EngineNameAr"];
    engineNameEn=map["EngineName"];
  }
}