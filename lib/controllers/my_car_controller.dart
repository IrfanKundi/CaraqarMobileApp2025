import 'package:careqar/models/car_model.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:get/get.dart';

import '../enums.dart';
import '../global_variables.dart';

class MyCarController extends GetxController {
  var status = Status.initial.obs;
  Rx<CarModel> carModel= Rx<CarModel>(CarModel());
  CarModel searchedCarModel=CarModel();
bool isGridView=true;
  var page = 1.obs;
  var fetch = 10.obs;
  var loadMore= true.obs;
  var isLoadingMore=false.obs;

  var searchText="";

  resetFilters(){

    page(1);
    loadMore.value=true;
    carModel=Rx<CarModel>(CarModel());
    searchedCarModel=CarModel();
  }

  Future<void> getCars({bool reset=false}) async {
    try {
      if(reset){
        resetFilters();
      }
      if(page>1){

        isLoadingMore.value = true;
      }else{
        status(Status.loading);
      }

      update();



      var response =
      await gApiProvider.get(path: "car/get?isAgent=true&page=${page.value}&fetch=${fetch.value}&searchText=$searchText",authorization: true);


      isLoadingMore.value =false;
    await  response.fold((l) {
        showSnackBar(message: l.message!);
        status(Status.error);
        update();
      }, (r) async {
        status(Status.success);

          if(page.value>1){
            var list =CarModel.fromMap(r.data).cars;
            if(list.isEmpty){
              loadMore.value=false;
            }
            if(searchText!=""){

              searchedCarModel.cars.addAll(CarModel.fromMap(r.data).cars);
            }else{
              carModel.value.cars.addAll(list);
              searchedCarModel.cars =carModel.value.cars;
            }

          }else{

            if(searchText!=""){

              searchedCarModel.cars.clear();
              searchedCarModel.cars.addAll(CarModel.fromMap(r.data).cars);
            }else{
              carModel.value = CarModel.fromMap(r.data);
              searchedCarModel.cars.clear();
              searchedCarModel.cars.addAll(carModel.value.cars);
            }


          }
      });
      update();
    } catch (e) {
      isLoadingMore.value =false;

      showSnackBar(message: "Error");
      status(Status.error);
      update();
    }
  }



}
