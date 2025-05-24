
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:get/get.dart';

import '../enums.dart';
import '../global_variables.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../models/subcategory_model.dart';
import 'brand_controller.dart';

class CategoryController extends GetxController {
  var categoriesStatus = Status.loading.obs;
  var subCategoriesStatus = Status.loading.obs;
  var categoriesAndProductStatus = Status.loading.obs;
  RxList<CategoryAndProducts> allCategoriesAndProducts = RxList<CategoryAndProducts>([]);
  RxList<Category> allCategories = RxList<Category>([]);
  RxList<SubCategory> allSubCategories = RxList<SubCategory>([]);
  RxList<Category> searchedCategories = RxList<Category>([]);
  RxList<SubCategory> searchedSubCategories = RxList<SubCategory>([]);
  int totalAds=0;
  bool isGridView=true;

  BrandController  brandController = Get.put(BrandController());

  search(String text){
    searchedCategories.clear();
    searchedCategories.addAll(
      allCategories.where((b) => b.categoryName!.toLowerCase().contains(text.trim().toLowerCase())).toList()
    );
    update();
  }
  searchSubCategory(String text){
    searchedSubCategories.clear();
    searchedSubCategories.addAll(
        allSubCategories.where((b) => b.subCategoryName!.toLowerCase().contains(text.trim().toLowerCase())).toList()
    );
    update();
  }

  Future<void> getCategories() async {
    try {
      categoriesStatus(Status.loading);
     // update();

      var response = await gApiProvider.get(path: "category/Get");

      await response.fold((l) {
        showSnackBar(message: l.message!);
        categoriesStatus(Status.error);
      }, (r) async {
        categoriesStatus(Status.success);
        searchedCategories.clear();
        allCategories.clear();
        for(var item in r.data){
          allCategories.add(Category(item));
        }
        searchedCategories.addAll(allCategories);
      }); update();
    } catch (e) {
      showSnackBar(message: "Error");
      categoriesStatus(Status.error);update();
    }
  }
  Future<void> getSubCategories(int categoryId) async {
    try {
      //subCategorysStatus(Status.loading);
      //update();

      var response = await gApiProvider.get(path: "category/GetSubCategories?categoryId=$categoryId");

      await response.fold((l) {
        showSnackBar(message: l.message!);
        subCategoriesStatus(Status.error);
      }, (r) async {
        subCategoriesStatus(Status.success);
        allSubCategories.clear();
        searchedSubCategories.clear();
        for(var item in r.data){
          allSubCategories.add(SubCategory(item));
        }
        searchedSubCategories.addAll(allSubCategories);

      }); update();
    } catch (e) {
      showSnackBar(message: "Error");
      subCategoriesStatus(Status.error);update();
    }
  }


  Future<void> getCategoriesAndProducts() async {
    try {
      categoriesAndProductStatus(Status.loading);
      // update();

      var response = await gApiProvider.get(path: "product/GetCategoryAndProduct");

      await response.fold((l) {
        showSnackBar(message: l.message!);
        categoriesAndProductStatus(Status.error);
      }, (r) async {
        categoriesAndProductStatus(Status.success);
        allCategoriesAndProducts.clear();

        List<Category> categories=[];
        List<Product> products=[];

        for(var category in r.data["Table"]){
          categories.add(Category(category));
        }
        for(var product in r.data["Table1"]){
          products.add(Product.fromMap(product));
        }

        for (var category in categories) {
          allCategoriesAndProducts.add(CategoryAndProducts(category, products));
        }


      }); update();
    } catch (e) {
      showSnackBar(message: "Error");
      categoriesAndProductStatus(Status.error);update();
    }
  }
}
