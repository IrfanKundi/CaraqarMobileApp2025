import 'package:careqar/controllers/type_controller.dart';
import 'package:careqar/models/city_model.dart';
import 'package:careqar/models/request_model.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:get/get.dart';

import '../enums.dart';
import '../global_variables.dart';
import '../routes.dart';
import 'location_controller.dart';

class RequestController extends GetxController {
  var status = Status.initial.obs;
  Rx<RequestModel> requestModel = Rx<RequestModel>(RequestModel());

  Rx<dynamic> isBuyerMode=Rx<dynamic>(null);

  Rx<City?> selectedCity = Rx(null);
  Rx<Location?> selectedLocation = Rx(null);
  late TypeController typeController;
  late LocationController locationController;
  var typeId = 0.obs;
  var subTypeId = 0.obs;

  var startPrice = 0.0;
  var endPrice = 0.0;
  var startSize = 0.0;
  var endSize = 0.0;
  var bedrooms = ''.obs;
  var baths = ''.obs;

bool isGridView=true;
  var page = 1.obs;
  var fetch = 10.obs;
  var loadMore= true.obs;
  var isLoadingMore=false.obs;

  @override
  void onInit() {

    typeController = Get.put(TypeController());
    locationController = Get.put(LocationController());

    // TODO: implement onInit
    super.onInit();
  }
  resetFilters(){
    selectedCity.value=null;
    selectedLocation.value=null;
    typeId.value=0;
    subTypeId.value=0;
    startSize=0;
    endSize=0;
    startPrice=0;
    endPrice=0;
    bedrooms.value='';
    baths.value='';
    isBuyerMode.value=true;
    page(1);
    loadMore.value=true;
    update(["filters"]);
  }

  Future<void> getRequests() async {
    try {

      if(Get.currentRoute==Routes.filtersScreen){
        Get.back();
      }
      if(page>1){

        isLoadingMore.value = true;
      }else{
        status(Status.loading);
      }


      isBuyerMode.value ??= true;

      var response =
          await gApiProvider.get(path: "request/get?countryId=${gSelectedCountry?.countryId}&isAgent=true&page=${page.value}&fetch=${fetch.value}&purpose=${isBuyerMode.value ? 'Sell':'Rent'}&cityId=${selectedCity.value !=null ? selectedCity.value?.cityId : ''}&locationId=${selectedLocation.value !=null ? selectedLocation.value?.locationId : ''}&typeId=${typeId.value > 0 ? typeId.value : ''}&subTypeId=${subTypeId.value > 0 ? subTypeId.value : ''}&bedrooms=${bedrooms.value.isNotEmpty ? bedrooms.value : ''}&baths=${baths.value.isNotEmpty ? baths.value : ''}&startPrice=${startPrice > 0 ? startPrice : ''}&endPrice=${endPrice > 0 ? endPrice : ''}&startSize=${startSize > 0 ? startSize : ''}&endSize=${endSize > 0 ? endSize : ''}",

              authorization: true);


      isLoadingMore.value =false;
      response.fold((l) {
        showSnackBar(message: l.message!);
        status(Status.error);
      }, (r) async {
        status(Status.success);
        if(page.value>1){
          var list =RequestModel.fromMap(r.data).requests;
          if(list.isEmpty){
            loadMore.value=false;
          }
          requestModel.value.requests.addAll(list);

        }else{
          requestModel.value = RequestModel.fromMap(r.data);
        }

        update();

      });
    } catch (e) {
      isLoadingMore.value =false;
      showSnackBar(message: "Error");
      status(Status.error);
    }
  }
}
