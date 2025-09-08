
import 'package:careqar/global_variables.dart';
import 'package:intl/intl.dart';

class OrderModel{

  List<Order> orders = [];

  OrderModel.fromJson({parsedJson}) {
    for (var item in parsedJson) {

      orders.add(Order(item));
    }
  }

}

class Order {
  int? orderId;
  String? invoiceNo;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? countryCode;
  String? email;
  String? deliveryAddress;
  String? createdAt;
  String? orderStatus;
  int? status;
  String? deliveryType;
  String? deliveryCoordinates;
  String? paymentStatus;
  double? totalPrice;
  double? deliveryFee;
  String? note;

  List<OrderItem> items = [];

  Order(order) {
    orderId = order["OrderId"];
    firstName = order["FirstName"];
    lastName = order["LastName"];
    phoneNumber = order["Contact"];
    countryCode = order["CountryCode"];
    email = order["Email"];
    deliveryAddress = order["ShippingAddress"];
    deliveryCoordinates = order["DeliveryCoordinates"];

    // Safely handle OrderDate
    if (order["OrderDate"] != null && order["OrderDate"].toString().isNotEmpty) {
      try {
        createdAt = DateFormat("dd-MM-yyyy")
            .format(DateTime.parse(order["OrderDate"]));
      } catch (e) {
        createdAt = "N/A"; // fallback if parsing fails
      }
    } else {
      createdAt = "N/A";
    }

    orderStatus = order["Status"] ?? "Unknown";
    status = order["OrderStatus"] ?? 0;
    note = order["Note"] ?? "";
    totalPrice = (order["Total"] ?? 0).toDouble();
    deliveryType = order["DeliveryType"];
    deliveryFee = (order["DeliveryFee"] ?? 0).toDouble();
    invoiceNo = order["InvoiceNo"] ?? "-";
  }
}

class OrderItem {
  String? supplierNameEn;
  String? supplierNameAr;
  List<String> images=[];
  String? productNameEn;
  String? productNameAr;
  String? detailsAr;
  String? detailsEn;
  int? quantity;
  double? price;
  double? totalPrice;
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

  OrderItem(item){

    categoryNameAr=item["CategoryAr"];
    categoryNameEn=item["Category"];
    subCategoryNameAr=item["SubCategoryAr"];
    subCategoryNameEn=item["SubCategory"];
    supplierNameAr=item["SupplierNameAr"];
    supplierNameEn=item["SupplierName"];
    productNameEn=item["ProductName"];
    productNameAr=item["ProductNameAr"];
    detailsEn=item["Details"];
    detailsAr=item["DetailsAr"];
    images.addAll(item["ImageUrl"].toString().split(",").toList());
    quantity=item["Qty"];
    price=item["Price"];
    totalPrice=item["Total"];

  }

}

