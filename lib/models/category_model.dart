

import 'package:careqar/models/product_model.dart';

import '../global_variables.dart';

class CategoryModel{

  List<Category> categories=[];

  CategoryModel.fromJson({parsedJson}){
    for(var item in parsedJson){
      categories.add(Category(item));
    }
  }
}


class Category {

  int? categoryId;
  String? categoryNameAr;
  String? categoryNameEn;
  late String imageUrl;
  String? imageTw0Url;


  String? get categoryName =>
      gSelectedLocale?.locale?.languageCode == "ar" ? categoryNameAr == null ||
          categoryNameAr == "" ? categoryNameEn : categoryNameAr :

      categoryNameEn == null || categoryNameEn == ""
          ? categoryNameAr
          : categoryNameEn;

  Category(category) {
    categoryId = category["CategoryId"];
    categoryNameAr = category["CategoryAr"];
    categoryNameEn = category["Category"];
    imageUrl = category["Image"];
    imageTw0Url = category["ImageTwo"];
  }
}

class CategoryAndProducts {

  late Category category;
  List<Product> products=[];

  CategoryAndProducts(Category cat,List<Product> prs) {

    category=cat;

    for (var item in prs) {
      if(item.categoryId==category.categoryId) {
        products.add(item);
      }
    }

  }
}