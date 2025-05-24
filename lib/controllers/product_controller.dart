
import 'package:careqar/models/product_model.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:get/get.dart';

import '../enums.dart';
import '../global_variables.dart';

class ProductController extends GetxController {

  var status = Status.initial.obs;

  bool isGridView=true;

  Rx<List<Product>> products = Rx<List<Product>>([]);

  var categoryId = 0.obs;
  var subCategoryId = 0.obs;



  var endPrice;
  var startPrice;
  var page = 1.obs;
  var fetch = 10.obs;
  var loadMore= true.obs;
  var isLoadingMore=false.obs;

  resetFilters(){

    categoryId.value=0;
    subCategoryId.value=0;

    startPrice=null;
    endPrice=null;
    page(1);
    loadMore.value=true;
    products.value.clear();
    update(["filters"]);
  }


  Future<void> getProducts() async {
    try {
      if(Get.focusScope!.hasFocus){
        Get.focusScope?.unfocus();
      }
      if(page>1){

        isLoadingMore.value = true;
      }else{
        status(Status.loading);
      }

      update();



      String path =  "product/get?countryId=${gSelectedCountry!.countryId}&page=${page.value}&fetch=${fetch.value}&categoryId=${categoryId.value > 0 ? categoryId.value : ''}&subCategoryId=${subCategoryId.value > 0 ? subCategoryId.value : ''}&startPrice=${startPrice ?? ''}&endPrice=${endPrice ?? ''}";

      var response = await gApiProvider.get(
          path:path,
               authorization: true);

      isLoadingMore.value =false;

     await response.fold((l) {
        showSnackBar(message: l.message!);
        status(Status.error);
        update();
      }, (r) async {
        status(Status.success);


        if(page.value>1){
          var list =ProductModel.fromMap(r.data).products;
          if(list.isEmpty){
            loadMore.value=false;
          }
          products.value.addAll(list);


        }else{
          products.value = ProductModel.fromMap(r.data).products;


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



