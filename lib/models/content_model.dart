import 'dart:io';
import 'package:hive/hive.dart';

import '../global_variables.dart';

part 'content_model.g.dart';

class ContentModel {

  List<Content> content=[];

  ContentModel();
  ContentModel.fromMap(map) {
    for(var item in map){
      content.add(Content(item));
    }
  }
}


@HiveType(typeId: 0)
class AppContent extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? screen;

  @HiveField(2)
  var createAt;

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "screen": screen,
      "createAt": createAt.toString(), // make sure it's readable
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}



class Content{

  int? id;

  String? screen;

  DateTime? createAt;

  List<String> videos=[];

  List<String> gifs=[];

  List<String> images=[];

  List<File> files=[];


  Content(map){
    id=map["Id"];
    createAt = DateTime.parse(map["CreatedAt"]);
    screen=map["Screen"];
    List data = [];
    data = map["Videos"];
    if(data.isNotEmpty){
      for(var item in map["Videos"]){
        videos.add(item);
      }
    }
    data = map["Gifs"];
    if(data.isNotEmpty){
      for(var item in map["Gifs"]){
        gifs.add(item);
      }
    }
    data = map["Images"];
    if(data.isNotEmpty){
      for(var item in map["Images"]){
        images.add(item);
      }
    }


  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'screen': screen,
      'createAt': createAt,
      'videos': videos,
      'images': images,
      'files': files,
      'gifs': gifs


    };
  }
}


class News{

  String? titleEn;
  String? titleAr;
  String? descriptionEn;
  String? descriptionAr;
  List<String> images=[];
  List<String> pdfs=[];
  List<String> videoUrls=[];


  String? get title => gSelectedLocale?.locale?.languageCode=="ar"?titleAr:titleEn;
  String? get description => gSelectedLocale?.locale?.languageCode=="ar"?descriptionAr:descriptionEn;



  News(map) {
    titleEn = map["Title"];
    titleAr = map["TitleAr"];
    descriptionEn = map["Description"];
    descriptionAr = map["DescriptionAr"];

    if (map["Image"] != null || map["Image"] != "" || map["Image"] != "null") {
      for (var item in map["Image"].toString().split(",")) {
        images.add(item);
      }
    }
    if (map["pdf"] != "" && map["pdf"] != null) {
      for (var item in map["pdf"].toString().split(",")) {
        pdfs.add(item);
      }
    }
    if (map["videourl"] != null && map["videourl"] != "") {
      for (var item in map["videourl"].toString().split(",")) {
        videoUrls.add(item);
      }
    }
  }

}


class Requirement{

  String? titleEn;
  String? titleAr;
  String? descriptionEn;
  String? descriptionAr;
  List<String> images=[];
  List<String> pdfs=[];
  List<String> videoUrls=[];

  String? get title => gSelectedLocale?.locale?.languageCode=="ar"?titleAr:titleEn;
  String? get description => gSelectedLocale?.locale?.languageCode=="ar"?descriptionAr:descriptionEn;

  Requirement(map){
    titleEn=map["Title"];
    titleAr=map["TitleAr"];
    descriptionEn=map["Description"];
    descriptionAr=map["DescriptionAr"];

    if (map["Image"] != null || map["Image"] != "" || map["Image"] != "null") {
      for (var item in map["Image"].toString().split(",")) {
        images.add(item);
      }
    }
    if (map["pdf"] != "" && map["pdf"] != null) {
      for (var item in map["pdf"].toString().split(",")) {
        pdfs.add(item);
      }
    }
    if (map["videourl"] != null && map["videourl"] != "") {
      for (var item in map["videourl"].toString().split(",")) {
        videoUrls.add(item);
      }
    }

  }

}


class CountryRequirement{

  int? foreignerCategoryId;
  int? countryId;
  String? cityId;
  String? titleEn;
  String? titleAr;
  String? imageEn;
  String? imageAr;

  String? get title => gSelectedLocale?.locale?.languageCode=="ar"?titleAr:titleEn;
  String? get image => gSelectedLocale?.locale?.languageCode=="ar"?imageAr:imageEn;

  CountryRequirement(map){
    
    titleEn=map["CategoryTitle"];
    titleAr=map["CategoryTitleAr"];
    imageEn=map["ImageEn"];
    imageAr=map["ImageAr"];

    foreignerCategoryId=map["ForeignerCategoryId"];
    countryId=map["CountryId"];
    cityId=map["CityId"];

  }

}