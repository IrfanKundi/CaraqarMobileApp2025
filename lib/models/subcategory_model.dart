

import '../global_variables.dart';

class SubCategoryModel{

  List<SubCategory> subCategories=[];

  SubCategoryModel.fromJson({parsedJson}){
    for(var item in parsedJson){
      subCategories.add(SubCategory(item));
    }
  }
}


class SubCategory {

  int? subCategoryId;
  int? categoryId;
  String? subCategoryNameAr;
  String? subCategoryNameEn;
  String? imageUrl;

  String? get subCategoryName =>
      gSelectedLocale?.locale?.languageCode == "ar" ? subCategoryNameAr == null ||
          subCategoryNameAr == "" ? subCategoryNameEn : subCategoryNameAr :

      subCategoryNameEn == null || subCategoryNameEn == ""
          ? subCategoryNameAr
          : subCategoryNameEn;

  SubCategory(subCategory) {
    subCategoryId = subCategory["SubCategoryId"];
    categoryId = subCategory["CategoryId"];
    subCategoryNameAr = subCategory["SubCategoryAr"];
    subCategoryNameEn = subCategory["SubCategory"];
    imageUrl = subCategory["Image"];
  }
}