import 'package:careqar/models/type_model.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:get/get.dart';
import '../enums.dart';
import '../global_variables.dart';

class TypeController extends GetxController {
  var status = Status.initial.obs;
  var typesStatus = Status.initial.obs;
  var subTypesStatus = Status.initial.obs;
  Rx<TypeModel> typeModel = Rx<TypeModel>(TypeModel());
  RxList<Type> searchedTypes = RxList<Type>([]);
  RxList<Type> allTypes = RxList<Type>([]);
  RxList<SubType> subTypes = RxList<SubType>([]);

  int totalAds=0;

  search(String text){
    searchedTypes.clear();
    searchedTypes.addAll(
        allTypes.where((b) => b.type!.toLowerCase().contains(text.trim().toLowerCase())).toList()
    );
    update();
  }

  @override
  void onInit() {
    getTypes();
    getTypesWithSubTypes();
    // TODO: implement onInit
    super.onInit();
  }

  Future<void> getTypes({vehicleType}) async {
    try {
      typesStatus(Status.loading);
      update();
      var path = "type/GetTypes?isVehicle=$gIsVehicle&vehicleType=$vehicleType";
      var response = await gApiProvider.get(path: path);


     await  response.fold((l) {
        showSnackBar(message: l.message!);
        typesStatus(Status.error);
      }, (r) async {
        typesStatus(Status.success);
        searchedTypes.clear();
        allTypes.clear();
        allTypes.addAll(TypeModel.fromMap(r.data).types);
        searchedTypes.addAll(allTypes);
      });
     update();
    } catch (e) {
      showSnackBar(message: "Error");
      typesStatus(Status.error); update();
    }
  }

  Future<void> getSubTypes(Type type) async {
    try {
      subTypesStatus(Status.loading);

      var response = await gApiProvider.get(path: "type/GetSubTypes?typeId=${type.typeId}&isVehicle=$gIsVehicle&vehicleType=$gVehicleType&countryid=${gSelectedCountry?.countryId}");

     return response.fold((l) {
        showSnackBar(message: l.message!);
        subTypesStatus(Status.error);  update();
      }, (r) async {
        subTypesStatus(Status.success);
        subTypes.clear();
        totalAds=r.data["totalAds"];
        for(var item in r.data["subtypes"]){
            subTypes.add(SubType(item));
          }
        type.subTypes=subTypes;
          update();

      });
    } catch (e) {
      showSnackBar(message: "Error");
      subTypesStatus(Status.error);  update();
    }
  }

  Future<void> getTypesWithSubTypes() async {
    try {
      status(Status.loading);

      var response = await gApiProvider.get(path: "type/GetAllTypes");

      response.fold((l) {
        showSnackBar(message: l.message!);
        status(Status.error);
      }, (r) async {
        status(Status.success);
        typeModel.value = TypeModel.fromMap(r.data);
      });
    } catch (e) {
      showSnackBar(message: "Error");
      status(Status.error);
    }
  }

}
