


import '../global_variables.dart';

class OrderDetailsModel{

  List<OrderItem> items=[];

  double? totalPrice;
  String? orderStatus;


  OrderDetailsModel.fromJson({parsedJson}){
    for(var item in parsedJson["orderDetails"]){
      items.add(OrderItem(item));
    }

    for(var item in parsedJson["summary"]){
      totalPrice=item["TotalPrice"];
      orderStatus=item["OrderStatus"];
    }

  }
}


class OrderItem {
  String? supplierNameEn;
  String? supplierNameAr;
  String? supplierLogoUrl;
  String? imageUrl;
  String? productNameEn;
  String? productNameAr;
  String? detailsAr;
  String? detailsEn;
  int? quantity;
  double? price;
  double? totalPrice;
  String? note;
  String? get productName => gSelectedLocale?.locale?.languageCode=="ar"?productNameAr==null || productNameAr=="" ? productNameEn :productNameAr : productNameEn==null || productNameEn=="" ?productNameAr:productNameEn;
  String? get supplierName => gSelectedLocale?.locale?.languageCode=="ar"?supplierNameAr==null || supplierNameAr=="" ? supplierNameEn :supplierNameAr : supplierNameEn==null || supplierNameEn=="" ?supplierNameAr:supplierNameEn;
  String? get details => gSelectedLocale?.locale?.languageCode=="ar"?detailsAr==null || detailsAr=="" ? detailsEn :detailsAr : detailsEn==null || detailsEn=="" ?detailsAr:detailsEn;

  OrderItem(item){

    supplierNameAr=item["SupplierNameAr"];
    supplierNameEn=item["SupplierNameEn"];
    productNameEn=item["ProductName"];
    productNameAr=item["ProductNameAr"];
    detailsEn=item["DetailsEn"];
    detailsAr=item["DetailsAr"];
    supplierLogoUrl=item["LogoUrl"];
    imageUrl=item["ImageUrl"];
    quantity=item["Quantity"];
    price=item["Price"];
  }

}


