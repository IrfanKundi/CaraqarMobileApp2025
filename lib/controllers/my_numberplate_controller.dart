
import 'package:careqar/models/number_plate_model.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:get/get.dart';

import '../enums.dart';
import '../global_variables.dart';

class MyNumberPlateController extends GetxController {
  var status = Status.initial.obs;
  Rx<NumberPlateModel> numberPlateModel= Rx<NumberPlateModel>(NumberPlateModel());
  NumberPlateModel searchedNumberPlateModel=NumberPlateModel();
bool isGridView=true;
  var page = 1.obs;
  var fetch = 10.obs;
  var loadMore= true.obs;
  var isLoadingMore=false.obs;

  var searchText="";

  resetFilters(){

    page(1);
    loadMore.value=true;
    numberPlateModel=Rx<NumberPlateModel>(NumberPlateModel());
    searchedNumberPlateModel=NumberPlateModel();
  }

  Future<void> getNumberPlates({bool reset=false}) async {
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
      await gApiProvider.get(path: "numberPlate/get?isAgent=true&page=${page.value}&fetch=${fetch.value}&searchText=$searchText",authorization: true);


      isLoadingMore.value =false;
    await  response.fold((l) {
        showSnackBar(message: l.message!);
        status(Status.error);
        update();
      }, (r) async {
        status(Status.success);

          if(page.value>1){
            var list =NumberPlateModel.fromMap(r.data).numberPlates;
            if(list.isEmpty){
              loadMore.value=false;
            }
            if(searchText!=""){

              searchedNumberPlateModel.numberPlates.addAll(NumberPlateModel.fromMap(r.data).numberPlates);
            }else{
              numberPlateModel.value.numberPlates.addAll(list);
              searchedNumberPlateModel.numberPlates =numberPlateModel.value.numberPlates;
            }

          }else{

            if(searchText!=""){

              searchedNumberPlateModel.numberPlates.clear();
              searchedNumberPlateModel.numberPlates.addAll(NumberPlateModel.fromMap(r.data).numberPlates);
            }else{
              numberPlateModel.value = NumberPlateModel.fromMap(r.data);
              searchedNumberPlateModel.numberPlates.clear();
              searchedNumberPlateModel.numberPlates.addAll(numberPlateModel.value.numberPlates);
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
