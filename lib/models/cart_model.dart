

import '../global_variables.dart';

class CartModel{

  List<CartItem> cart=[];

  double? totalPrice=0;
  double? shippingFee=0;
  int? totalItems=0;

  CartModel.fromJson(parsedJson){
    for(var item in parsedJson){
      CartItem c=CartItem(item);
      cart.add(c);
      totalPrice = (totalPrice!+c.subtotal!);
    }
  }



}

class CartItem{

  int? cartId;
  int? supplierId;
  String? supplierNameEn;
  String? supplierNameAr;
  String? supplierLogoUrl;
  List<String> images=[];
  String? productNameEn;
  String? productNameAr;
  String? detailsAr;
  String? detailsEn;
  int? quantity;
  double? price;
  double? subtotal;
  int? productId;
  double? productPrice;
  String? categoryNameAr;
  String? categoryNameEn;
  String? subCategoryNameAr;
  String? subCategoryNameEn;
  String? get productName => gSelectedLocale?.locale?.languageCode=="ar"?productNameAr==null || productNameAr=="" ? productNameEn :productNameAr : productNameEn==null || productNameEn=="" ?productNameAr:productNameEn;
  String? get supplierName => gSelectedLocale?.locale?.languageCode=="ar"?supplierNameAr==null || supplierNameAr=="" ? supplierNameEn :supplierNameAr : supplierNameEn==null || supplierNameEn=="" ?supplierNameAr:supplierNameEn;
  String? get details => gSelectedLocale?.locale?.languageCode=="ar"?detailsAr==null || detailsAr=="" ? detailsEn :detailsAr : detailsEn==null || detailsEn=="" ?detailsAr:detailsEn;
  String? get categoryName => gSelectedLocale?.locale?.languageCode=="ar"?categoryNameAr==null || categoryNameAr=="" ?categoryNameEn:categoryNameAr:

  categoryNameEn==null || categoryNameEn=="" ?categoryNameAr:categoryNameEn;
  String? get subCategoryName => gSelectedLocale?.locale?.languageCode=="ar"?subCategoryNameAr==null || subCategoryNameAr=="" ?subCategoryNameEn:subCategoryNameAr:

  subCategoryNameEn==null || subCategoryNameEn=="" ?subCategoryNameAr:subCategoryNameEn;

  CartItem(cart){
    categoryNameAr=cart["CategoryAr"];
    categoryNameEn=cart["Category"];
    subCategoryNameAr=cart["SubCategoryAr"];
    subCategoryNameEn=cart["SubCategory"];
    supplierNameAr=cart["SupplierNameAr"];
    supplierNameEn=cart["SupplierName"];
    cartId=cart["CartId"];
    supplierId=cart["SupplierId"];
    productNameEn=cart["ProductName"];
    productNameAr=cart["ProductNameAr"];
    detailsEn=cart["Details"];
    detailsAr=cart["DetailsAr"];
    images.addAll(cart["ImageUrl"].toString().split(",").toList());
    quantity=cart["Quantity"];
    price=cart["Price"];
    subtotal=cart["Subtotal"];
    productId=cart["ProductId"];
    productPrice=cart["ProductPrice"];

  }

}