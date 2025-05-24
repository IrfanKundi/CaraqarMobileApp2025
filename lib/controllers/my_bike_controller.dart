import 'package:careqar/models/bike_model.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:get/get.dart';

import '../enums.dart';
import '../global_variables.dart';

class MyBikeController extends GetxController {
  var status = Status.initial.obs;
  Rx<BikeModel> bikeModel= Rx<BikeModel>(BikeModel());
  BikeModel searchedBikeModel=BikeModel();
bool isGridView=true;
  var page = 1.obs;
  var fetch = 10.obs;
  var loadMore= true.obs;
  var isLoadingMore=false.obs;

  var searchText="";
  resetFilters(){

    page(1);
    loadMore.value=true;
    bikeModel=Rx<BikeModel>(BikeModel());
    searchedBikeModel=BikeModel();
  }
  Future<void> getBikes({bool reset=false}) async {
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
      await gApiProvider.get(path: "bike/get?isAgent=true&page=${page.value}&fetch=${fetch.value}&searchText=$searchText",authorization: true);


      isLoadingMore.value =false;
    await  response.fold((l) {
        showSnackBar(message: l.message!);
        status(Status.error);
        update();
      }, (r) async {
        status(Status.success);

          if(page.value>1){
            var list =BikeModel.fromMap(r.data).bikes;
            if(list.isEmpty){
              loadMore.value=false;
            }
            if(searchText!=""){

              searchedBikeModel.bikes.addAll(BikeModel.fromMap(r.data).bikes);
            }else{
              bikeModel.value.bikes.addAll(list);
              searchedBikeModel.bikes =bikeModel.value.bikes;
            }

          }else{

            if(searchText!=""){

              searchedBikeModel.bikes.clear();
              searchedBikeModel.bikes.addAll(BikeModel.fromMap(r.data).bikes);
            }else{
              bikeModel.value = BikeModel.fromMap(r.data);
              searchedBikeModel.bikes.clear();
              searchedBikeModel.bikes.addAll(bikeModel.value.bikes);
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
