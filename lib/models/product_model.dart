

import '../global_variables.dart';

class ProductModel {

  List<Product> products=[];

  ProductModel();
  ProductModel.fromMap(map) {
    for(var item in map){
      products.add(Product.fromMap(item));
    }
  }
}

class Product{
  Product();
  int? productId;

  int? favoriteId;
  String? productNameEn;
  String? productNameAr;
  String? descriptionEn;
  String? descriptionAr;
  String? categoryNameAr;
  String? categoryNameEn;
  String? subCategoryNameAr;
  String? subCategoryNameEn;
  String? supplierNameEn;
  String? supplierNameAr;
  int? categoryId;
  int? subCategoryId;
  int? supplierId;
  DateTime? createdAt;
  double? price;
  List<String> images=[];
  String? get productName => gSelectedLocale?.locale?.languageCode=="ar"?productNameAr==null || productNameAr=="" ? productNameEn :productNameAr : productNameEn==null || productNameEn=="" ?productNameAr:productNameEn;
  String? get description => gSelectedLocale?.locale?.languageCode=="ar"?descriptionAr==null || descriptionAr=="" ?descriptionEn:descriptionAr:

  descriptionEn==null || descriptionEn=="" ?descriptionAr:descriptionEn;

  String? get categoryName => gSelectedLocale?.locale?.languageCode=="ar"?categoryNameAr==null || categoryNameAr=="" ?categoryNameEn:categoryNameAr:

  categoryNameEn==null || categoryNameEn=="" ?categoryNameAr:categoryNameEn;
  String? get subCategoryName => gSelectedLocale?.locale?.languageCode=="ar"?subCategoryNameAr==null || subCategoryNameAr=="" ?subCategoryNameEn:subCategoryNameAr:

  subCategoryNameEn==null || subCategoryNameEn=="" ?subCategoryNameAr:subCategoryNameEn;
  String? get supplierName => gSelectedLocale?.locale?.languageCode=="ar"?supplierNameAr==null || supplierNameAr=="" ? supplierNameEn :supplierNameAr : supplierNameEn==null || supplierNameEn=="" ?supplierNameAr:supplierNameEn;

  Product.fromMap(map){
  createdAt=DateTime.parse(map["CreatedAt"]);
    favoriteId=map["FavoriteId"]??0;
     productId=map["ProductId"];
    descriptionEn=map["Description"];
    descriptionAr=map["DescriptionAr"];
  productNameEn=map["ProductName"];
  productNameAr=map["ProductNameAr"];
  categoryNameAr=map["CategoryAr"];
  categoryNameEn=map["Category"];
  subCategoryNameAr=map["SubCategoryAr"];
  subCategoryNameEn=map["SubCategory"];
  supplierNameAr=map["SupplierNameAr"];
  supplierNameEn=map["SupplierName"];
  categoryId=map["CategoryId"];
  subCategoryId=map["SubCategoryId"];
  supplierId=map["SupplierId"];
  price=map["Price"];
    images.addAll(map["ImageUrl"].toString().split(",").toList());

  }

}


class ProductChoiceModel{

  List<ProductChoice> productChoices=[];

  ProductChoiceModel.fromJson({parsedJson}){
    for(var item in parsedJson){

      productChoices.add(ProductChoice(item));
    }
  }

}


class ProductChoice{

  int? choiceId;
  String? choice;
  bool? allowMultiple;
  List<Option> options=[];

  ProductChoice(map){
    choiceId=map["ChoiceId"];
    choice=map["Choice"];
    allowMultiple=map["AllowMultiple"];
    for(var item in map["Options"]){
      options.add(Option(item));
    }


  }

}

class Option{
  int? optionId;
  double? price;
  String? optionText;

  Option(option){
    optionId=option["OptionId"];
    price=option["Price"];
    optionText=option["OptionText"];
  }

}