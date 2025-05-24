import 'package:careqar/models/city_model.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../enums.dart';
import '../global_variables.dart';
import '../models/number_plate_model.dart';
import '../routes.dart';

class NumberPlateController extends GetxController {

  var status = Status.initial.obs;

  bool isGridView=true;

  Rx<List<NumberPlate>> numberPlates = Rx<List<NumberPlate>>([]);

  int totalAds=0;
  String? digits;
  City? selectedCity;

  String? endPrice;
  String? startPrice;

  RangeValues price = RangeValues(0, 0);

  var page = 1.obs;
  var fetch = 10.obs;
  var loadMore= true.obs;
  var isLoadingMore=false.obs;
  bool personalAds=false;
  bool companyAds=false;
  resetFilters(){
    personalAds=false;
    companyAds=false;
    selectedCity=null;
    digits=null;

    price = RangeValues(0, 0);

    startPrice=null;
    endPrice=null;
    page(1);
    loadMore.value=true;
    numberPlates.value.clear();
    update(["filters"]);
  }



  Future<void> getFilteredNumberPlates({nearBy=false}) async {
    try {
      if(Get.focusScope!.hasFocus){
        Get.focusScope?.unfocus();
      }
      if(page>1){

        isLoadingMore.value = true;
      }else{status(Status.loading);
      }

      update();

      String path =  "numberPlate/get?companyAds=$companyAds&personalAds=$personalAds&countryId=${gSelectedCountry!.countryId}&page=${page.value}&fetch=${fetch.value}&digits=${digits ?? ''}&cityId=${selectedCity?.cityId ?? ''}&startPrice=${startPrice ?? ''}&endPrice=${endPrice ?? ''}";

    if(nearBy){
        path+="&coordinates=${gCurrentLocation?.latitude},${gCurrentLocation?.longitude}";
      }
      var response = await gApiProvider.get(
          path:path,
               authorization: true);

     // EasyLoading.dismiss();
      isLoadingMore.value =false;

     await response.fold((l) {
        showSnackBar(message: l.message!);
        status(Status.error);

      }, (r) async {
        status(Status.success);


        if(page.value>1){
          var list =NumberPlateModel.fromMap(r.data).numberPlates;
          if(list.isEmpty){
            loadMore.value=false;
          }
          numberPlates.value.addAll(list);


        }else{
          numberPlates.value = NumberPlateModel.fromMap(r.data["numberPlates"]).numberPlates;
          totalAds=r.data["totalAds"];

        }


        if(Get.currentRoute==Routes.numberPlateFilterScreen){
          Get.back();
        }

      });
      update();
    } catch (e) {
      isLoadingMore.value =false;
     // EasyLoading.dismiss();
      showSnackBar(message: "Error");
      status(Status.error);
      update();
    }
  }
}


