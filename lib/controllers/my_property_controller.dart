import 'package:careqar/models/property_model.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:get/get.dart';

import '../enums.dart';
import '../global_variables.dart';

class MyPropertyController extends GetxController {
  var status = Status.initial.obs;
  Rx<PropertyModel> propertyModel= Rx<PropertyModel>(PropertyModel());
  PropertyModel searchedPropertyModel=PropertyModel();
bool isGridView=true;
  var page = 1.obs;
  var fetch = 10.obs;
  var loadMore= true.obs;
  var isLoadingMore=false.obs;

  var searchText="";

  @override
  void onInit() {

    // TODO: implement onInit
    super.onInit();
  }

  Future<void> getProperties() async {
    try {
      if(page>1){

        isLoadingMore.value = true;
      }else{
        status(Status.loading);
      }

      update();



      var response =
      await gApiProvider.get(path: "property/get?isAgent=true&page=${page.value}&fetch=${fetch.value}&searchText=$searchText",authorization: true);


      isLoadingMore.value =false;
    await  response.fold((l) {
        showSnackBar(message: l.message!);
        status(Status.error);
        update();
      }, (r) async {
        status(Status.success);

          if(page.value>1){
            var list =PropertyModel.fromMap(r.data).properties;
            if(list.isEmpty){
              loadMore.value=false;
            }
            if(searchText!=""){

              searchedPropertyModel.properties.addAll(PropertyModel.fromMap(r.data).properties);
            }else{
              propertyModel.value.properties.addAll(list);
              searchedPropertyModel.properties =propertyModel.value.properties;
            }

          }else{

            if(searchText!=""){

              searchedPropertyModel.properties.clear();
              searchedPropertyModel.properties.addAll(PropertyModel.fromMap(r.data).properties);
            }else{
              propertyModel.value = PropertyModel.fromMap(r.data);
              searchedPropertyModel.properties.clear();
              searchedPropertyModel.properties.addAll(propertyModel.value.properties);
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
