import 'package:careqar/models/brand_model.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:get/get.dart';

import '../enums.dart';
import '../global_variables.dart';

class BrandController extends GetxController {

  var searchText="";
  RxBool searchBoolean = false.obs;

  var brandsStatus = Status.loading.obs;
  var modelsStatus = Status.loading.obs;
  var engineStatus = Status.loading.obs;
  RxList<Brand> allBrands = RxList<Brand>([]);
  RxList<Model> allModels = RxList<Model>([]);
  RxList<Engine> allEngines = RxList<Engine>([]);
  RxList<Brand> searchedBrands = RxList<Brand>([]);
  RxList<Model> searchedModels = RxList<Model>([]);
  RxList<Engine> searchedEngines = RxList<Engine>([]);
  int totalAds=0;

  var selectedDate = DateTime.now().obs;
  var searched = false.obs;

  Rx<dynamic> modelId= Rx<dynamic>(null);
  Rx<dynamic> brandId= Rx<dynamic>(null);
  Rx<dynamic> engineId= Rx<dynamic>(null);

  var model="".obs;
  var brand="".obs;
  var engine="".obs;

  var year="".obs;

  updateDate(DateTime datetime){
    selectedDate.value = datetime;
    update();
  }
  updateSearchButton(val){
    searched.value = val;

    for (var element in allBrands) {
      if(element.brandId==brandId){
        brand.value = element.brandName!;
      }
    }

    for (var element in allModels) {
      if(element.modelId==modelId){
        model.value = element.modelName!;
      }
    }

    for (var element in allEngines) {
      if(element.engineId==engineId){
        engine.value = element.engineName!;
      }
    }

    print("Brand = ${brand.value}");
    print("Model = ${model.value}");
    print("Engine = ${engine.value}");

    update();
  }


  search(String text){
    searchedBrands.clear();
    searchedBrands.addAll(
      allBrands.where((b) => b.brandName!.toLowerCase().contains(text.trim().toLowerCase())).toList()
    );
    update();
  }
  searchModel(String text){
    searchedModels.clear();
    searchedModels.addAll(
        allModels.where((b) => b.modelName!.toLowerCase().contains(text.trim().toLowerCase())).toList()
    );
    update();
  }

  Future<void> getBrands(String vehicleType) async {
    try {
      brandsStatus(Status.loading);
     // update();

      var response = await gApiProvider.get(path: "vehicleBrand/Get?vehicleType=$vehicleType");

      await response.fold((l) {
        showSnackBar(message: l.message!);
        brandsStatus(Status.error);
      }, (r) async {
        brandsStatus(Status.success);
        searchedBrands.clear();
        allBrands.clear();
        totalAds=r.data["totalAds"];
        for(var item in r.data["brands"]){
          allBrands.add(Brand(item));
        }
        searchedBrands.addAll(allBrands);
      }); update();
    } catch (e) {
      showSnackBar(message: "Error");
      brandsStatus(Status.error);update();
    }
  }
  Future<void> getModels(int brandId) async {
    try {
      //modelsStatus(Status.loading);
      //update();

      var response = await gApiProvider.get(path: "vehicleBrand/GetModels?brandId=$brandId");

      await response.fold((l) {
        showSnackBar(message: l.message!);
        modelsStatus(Status.error);
      }, (r) async {
        modelsStatus(Status.success);
        allModels.clear();
        searchedModels.clear();
        for(var item in r.data){
          allModels.add(Model(item));
        }
        searchedModels.addAll(allModels);

      }); update();
    } catch (e) {
      showSnackBar(message: "Error");
      modelsStatus(Status.error);update();
    }
  }

  Future<void> getEngines(int brandId,int modelId) async {
    try {
      //engineStatus(Status.loading);
      //update();

      var response = await gApiProvider.get(path: "vehicleBrand/GetEngine?brandId=$brandId&modelId=$modelId");

      await response.fold((l) {
        showSnackBar(message: l.message!);
        engineStatus(Status.error);
      }, (r) async {
        engineStatus(Status.success);
        allEngines.clear();
        searchedEngines.clear();
        for(var item in r.data){
          allEngines.add(Engine(item));
        }
        searchedEngines.addAll(allEngines);

      }); update();
    } catch (e) {
      showSnackBar(message: "Error");
      engineStatus(Status.error);update();
    }
  }


  void showSearchIcon(bool val){
    searchBoolean.value = val;
    update(["search"]);
  }
}
