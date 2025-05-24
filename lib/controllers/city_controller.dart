import 'package:careqar/models/city_model.dart';
import 'package:careqar/models/property_model.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:get/get.dart';

import '../enums.dart';
import '../global_variables.dart';
import 'content_controller.dart';

class CityController extends GetxController {
  var status = Status.initial.obs;
  RxList<ForeignerCity> foreignerCities = RxList<ForeignerCity>([]);
  RxList<City> searchedCities = RxList<City>([]);
  RxList<City> allCities = RxList<City>([]);

  bool isGridView=true;
  ContentController  contentController = Get.find<ContentController>();
  var adsStatus = Status.initial.obs;

  search(String text){
    searchedCities.clear();
    searchedCities.addAll(
        allCities.where((b) => b.name!.toLowerCase().contains(text.trim().toLowerCase())).toList()
    );
    update();
  }

  Future<void> getForeignerCities(bool isOpenArea, int? foreignerCategoryId) async {
    try {
      status(Status.loading);
      update();
      var response = await gApiProvider.get(
          path: "city/Get?isForeigner=true&countryId=${gSelectedCountry!.countryId}&isOpenArea=$isOpenArea&foreignerCategoryId=$foreignerCategoryId",authorization: true);

      response.fold((l) {
        showSnackBar(message: l.message!);
        status(Status.error);  update();
      }, (r) async {
        status(Status.success);
        foreignerCities.clear();
        for(var item in r.data["Table"]){
          foreignerCities.add(ForeignerCity(item));
        }
        for(var item in r.data["Table1"]){
          foreignerCities.add(ForeignerCity(item));
        }

        update();
      });
    } catch (e) {
      showSnackBar(message: "Error");
      status(Status.error);  update();
    }
  }

  Future<void> getAds(ForeignerCity city) async {
    try {

      adsStatus(Status.loading);
      update();
      var response = await gApiProvider.get(path: "property/Get?purpose=Sell&locationId=${city.locationId}&cityId=${city.cityId}");

      await response.fold((l) {
        showSnackBar(message: l.message!);
        adsStatus(Status.error);

      }, (r) async {
        adsStatus(Status.success);
        city.ads.clear();
        for(var item in r.data["properties"]){
          city.ads.add(Property.fromMap(item));
        }

      });
      update();
    } catch (e) {
      showSnackBar(message: "Error");
      adsStatus(Status.error);  update();
    }
  }
  Future<void> getCities() async {
    try {
      status(Status.loading);
      update();
      var response = await gApiProvider.get(path: "city/Get?countryId=${gSelectedCountry!.countryId}",authorization: true);

      response.fold((l) {
        showSnackBar(message: l.message!);
        status(Status.error);  update();
      }, (r) async {
        status(Status.success);
        allCities.clear();
        searchedCities.clear();

        allCities.addAll(CityModel.fromMap(r.data).cities);
        searchedCities.addAll(allCities);
        update();
      });
    } catch (e) {
      showSnackBar(message: "Error");
      status(Status.error);  update();
    }
  }
}
