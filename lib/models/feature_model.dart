import '../global_variables.dart';

class FeatureModel {

  List<FeatureHead> featureHeads=[];
  List<Feature> features=[];

  FeatureModel();
  FeatureModel.fromMap(map) {
    for(var item in map){
      var head=FeatureHead.fromMap(item);
         featureHeads.add(head);
        features.addAll(head.features);
    }
  }
}

class FeatureHead{
  int? headId;
  String? titleAr;
  String? titleEn;
  List<Feature> features=[];
  FeatureHead();

  String? get title => gSelectedLocale?.locale?.languageCode=="ar"?titleAr:titleEn;

  FeatureHead.fromMap(map){
    headId=map["HeadId"];
    titleEn=map["Title"];
    titleAr=map["TitleAr"];
    for(var item in map["Features"]){
      features.add(Feature.fromMap(item));
    }
  }
}

class Feature{
  int? featureId;
  int? headId;
  String? titleAr;
  String? titleEn;
  String? image;
  String? options;
  bool? requireQty;
  int? quantity;
  String? featureOption;

  String? get title => gSelectedLocale?.locale?.languageCode=="ar"?titleAr:titleEn;

  Feature();
  Feature.fromMap(map){
    headId=map["HeadId"];
    featureId=map["FeatureId"];
    titleEn=map["Title"];
    titleAr=map["TitleAr"];
    options=map["Options"];
    requireQty=map["RequireQty"];
    image=map["Image"];
  }
}
