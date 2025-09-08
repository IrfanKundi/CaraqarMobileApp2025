import 'package:careqar/models/brand_model.dart';
import 'package:careqar/models/model_variant.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:get/get.dart';

import '../enums.dart';
import '../global_variables.dart';

class BrandController extends GetxController {
  var searchText = "";
  RxBool searchBoolean = false.obs;
  var variantsStatus = Status.initial.obs;
  List<ModelVariant> variants = [];
  List<ModelVariant> searchedVariants = [];
  var brandsStatus = Status.loading.obs;
  var modelsStatus = Status.loading.obs;
  var engineStatus = Status.loading.obs;

  RxList<Brand> allBrands = RxList<Brand>([]);
  RxList<Model> allModels = RxList<Model>([]);
  RxList<Engine> allEngines = RxList<Engine>([]);

  RxList<Brand> searchedBrands = RxList<Brand>([]);
  RxList<Model> searchedModels = RxList<Model>([]);
  RxList<Engine> searchedEngines = RxList<Engine>([]);

  int totalAds = 0;

  var selectedDate = DateTime.now().obs;
  var searched = false.obs;

  Rx<dynamic> modelId = Rx<dynamic>(null);
  Rx<dynamic> brandId = Rx<dynamic>(null);
  Rx<dynamic> engineId = Rx<dynamic>(null);

  var model = "".obs;
  var brand = "".obs;
  var engine = "".obs;
  var year = "".obs;

  final List<String> priorityBrands = ['Toyota', 'Honda', 'Suzuki', 'Hyundai' , 'KIA', 'Changan Auto', 'MG', 'Prince'];

  Future<void> getVariants(int? modelId) async {
    try {
      if (modelId == null) return;

      variantsStatus(Status.loading);

      var response = await gApiProvider.get(
          path: "vehicleBrand/GetVariants?modelId=$modelId"
      );

      await response.fold((l) {
        showSnackBar(message: l.message!);
        variantsStatus(Status.error);
      }, (r) async {
        variantsStatus(Status.success);
        variants = (r.data as List)
            .map((x) => ModelVariant.fromMap(x))
            .toList();
        searchedVariants = variants;
      });
      update();
    } catch (e) {
      showSnackBar(message: "Error");
      variantsStatus(Status.error);
      update();
    }
  }

  void searchVariant(String query) {
    if (query.isEmpty) {
      searchedVariants = variants;
    } else {
      searchedVariants = variants
          .where((variant) =>
      variant.variantName!.toLowerCase().contains(query.toLowerCase()) ||
          variant.variantNameAr!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    update();
  }

  void updateDate(DateTime datetime) {
    selectedDate.value = datetime;
    update();
  }

  void updateSearchButton(val) {
    searched.value = val;

    for (var element in allBrands) {
      if (element.brandId == brandId) {
        brand.value = element.brandName!;
      }
    }

    for (var element in allModels) {
      if (element.modelId == modelId) {
        model.value = element.modelName!;
      }
    }

    for (var element in allEngines) {
      if (element.engineId == engineId) {
        engine.value = element.engineName!;
      }
    }

    print("Brand = ${brand.value}");
    print("Model = ${model.value}");
    print("Engine = ${engine.value}");

    update();
  }

  /// Search with prioritized brands
  void search(String text) {
    final lowerText = text.trim().toLowerCase();

    final filtered = allBrands
        .where((b) =>
    b.brandName != null &&
        b.brandName!.toLowerCase().contains(lowerText))
        .toList();

    final prioritized = filtered
        .where((b) => priorityBrands.any(
            (p) => b.brandName!.toLowerCase().contains(p.toLowerCase())))
        .toList();

    final rest = filtered
        .where((b) => !priorityBrands.any(
            (p) => b.brandName!.toLowerCase().contains(p.toLowerCase())))
        .toList();

    // Optional: sort both
    prioritized.sort((a, b) => a.brandName!.compareTo(b.brandName!));
    rest.sort((a, b) => a.brandName!.compareTo(b.brandName!));

    searchedBrands.assignAll([...prioritized, ...rest]);
    update();
  }

  /// Search for models
  void searchModel(String text) {
    searchedModels.clear();
    searchedModels.addAll(allModels
        .where((b) => b.modelName!
        .toLowerCase()
        .contains(text.trim().toLowerCase()))
        .toList());
    update();
  }

  /// Load brands and apply priority sort initially
  Future<void> getBrands(String vehicleType) async {
    try {
      brandsStatus(Status.loading);

      var response = await gApiProvider.get(
          path: "vehicleBrand/Get?vehicleType=$vehicleType");

      await response.fold((l) {
        showSnackBar(message: l.message!);
        brandsStatus(Status.error);
      }, (r) async {
        brandsStatus(Status.success);
        searchedBrands.clear();
        allBrands.clear();
        totalAds = r.data["totalAds"];

        for (var item in r.data["brands"]) {
          allBrands.add(Brand(item));
        }

        // Prioritize top brands on initial load
        final prioritized = allBrands
            .where((b) => priorityBrands.any((p) =>
            b.brandName!.toLowerCase().contains(p.toLowerCase())))
            .toList();

        final rest = allBrands
            .where((b) => !priorityBrands.any((p) =>
            b.brandName!.toLowerCase().contains(p.toLowerCase())))
            .toList();

        prioritized.sort((a, b) => a.brandName!.compareTo(b.brandName!));
        rest.sort((a, b) => a.brandName!.compareTo(b.brandName!));

        searchedBrands.assignAll([...prioritized, ...rest]);
      });

      update();
    } catch (e) {
      showSnackBar(message: "Error");
      brandsStatus(Status.error);
      update();
    }
  }

  Future<void> getModels(int brandId) async {
    try {
      var response = await gApiProvider.get(
          path: "vehicleBrand/GetModels?brandId=$brandId");

      await response.fold((l) {
        showSnackBar(message: l.message!);
        modelsStatus(Status.error);
      }, (r) async {
        modelsStatus(Status.success);
        allModels.clear();
        searchedModels.clear();
        for (var item in r.data) {
          allModels.add(Model(item));
        }
        searchedModels.addAll(allModels);
      });

      update();
    } catch (e) {
      showSnackBar(message: "Error");
      modelsStatus(Status.error);
      update();
    }
  }

  Future<void> getEngines(int brandId, int modelId) async {
    try {
      var response = await gApiProvider.get(
          path: "vehicleBrand/GetEngine?brandId=$brandId&modelId=$modelId");

      await response.fold((l) {
        showSnackBar(message: l.message!);
        engineStatus(Status.error);
      }, (r) async {
        engineStatus(Status.success);
        allEngines.clear();
        searchedEngines.clear();
        for (var item in r.data) {
          allEngines.add(Engine(item));
        }
        searchedEngines.addAll(allEngines);
      });

      update();
    } catch (e) {
      showSnackBar(message: "Error");
      engineStatus(Status.error);
      update();
    }
  }

  void showSearchIcon(bool val) {
    searchBoolean.value = val;
    update(["search"]);
  }
}

