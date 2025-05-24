import 'package:careqar/controllers/property_controller.dart';
import 'package:careqar/models/number_plate_model.dart';
import 'package:careqar/models/property_model.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../enums.dart';
import '../global_variables.dart';
import '../models/bike_model.dart';
import '../models/car_model.dart';
import '../routes.dart';

class FavoriteController extends GetxController {
  var status = Status.initial.obs;
  var actionStatus = Status.initial.obs;
  Rx<List<Property>> properties = Rx<List<Property>>([]);
  Rx<List<Car>> cars = Rx<List<Car>>([]);
  Rx<List<Bike>> bikes= Rx<List<Bike>>([]);
  Rx<List<NumberPlate>> numberPlates = Rx<List<NumberPlate>>([]);

  bool isGridView=true;

  Future<void> getCars() async {
    try {
      status(Status.loading);
      update();
      var response =
      await gApiProvider.get(path: "favorite/get?type=Car", authorization: true);



      await  response.fold((l) {
        showSnackBar(message: l.message!);
        status(Status.error);
      }, (r) async {
        status(Status.success);
        cars.value = CarModel.fromMap(r.data).cars;

      });  update();
    } catch (e) {

      showSnackBar(message: "Error");
      status(Status.error);  update();
    }
  }
  Future<void> getBikes() async {
    try {
      status(Status.loading);
      update();
      var response =
      await gApiProvider.get(path: "favorite/get?type=Bike", authorization: true);



      await  response.fold((l) {
        showSnackBar(message: l.message!);
        status(Status.error);
      }, (r) async {
        status(Status.success);
        bikes.value = BikeModel.fromMap(r.data).bikes;

      });  update();
    } catch (e) {

      showSnackBar(message: "Error");
      status(Status.error);  update();
    }
  }
  Future<void> getNumberPlates() async {
    try {
      status(Status.loading);
      update();
      var response =
      await gApiProvider.get(path: "favorite/get?type=NumberPlate", authorization: true);



    await  response.fold((l) {
        showSnackBar(message: l.message!);
        status(Status.error);
      }, (r) async {
      status(Status.success);
        numberPlates.value = NumberPlateModel.fromMap(r.data).numberPlates;

      });  update();
    } catch (e) {

      showSnackBar(message: "Error");
      status(Status.error);  update();
    }
  }
  Future<void> getProperties() async {
    try {
      status(Status.loading);

      var response =
      await gApiProvider.get(path: "favorite/get?type=Property", authorization: true);



      response.fold((l) {
        showSnackBar(message: l.message!);
        status(Status.error);
      }, (r) async {
        status(Status.success);
        properties.value = PropertyModel.fromMap(r.data).properties;
        update();
      });
    } catch (e) {

      showSnackBar(message: "Error");
      status(Status.error);
    }
  }

  Future<bool> deleteFavorite({Property? property,Car? car,Bike? bike,NumberPlate? numberPlate,removeFav=false}) async {
    try {
      actionStatus(Status.loading);
      EasyLoading.show();

      var response = await gApiProvider.get(
          path: "favorite/delete?favoriteId=${ property!=null? property.favoriteId:car!=null?car.favoriteId:bike!=null?bike.favoriteId:numberPlate?.favoriteId}",
          authorization: true);

      EasyLoading.dismiss();
     return response.fold((l) {
        showSnackBar(message: l.message!);
        actionStatus(Status.error);
        return false;
      }, (r) async {
        actionStatus(Status.success);
        showSnackBar(message: r.message);
        if(property!=null) {
          if (removeFav) {
            var propertyController = Get.put(PropertyController());

            List<Property> list = propertyController.nearByProperties.value
                .where((element) => element.propertyId == property.propertyId)
                .toList();
            if (list.isNotEmpty) {
              list.first.favoriteId = 0;
            }
            list = propertyController.recommendedProperties.value.where((
                element) => element.propertyId == property.propertyId).toList();
            if (list.isNotEmpty) {
              list.first.favoriteId = 0;
            }

            list = propertyController.followedProperties.value.where((
                element) => element.propertyId == property.propertyId).toList();
            if (list.isNotEmpty) {
              list.first.favoriteId = 0;
            }
            properties.value.remove(property);
          } else {
            property.favoriteId = 0;
            properties.value.remove(property);
          }
        }else if(car !=null){
          car.favoriteId=0;    cars.value.remove(car);
        }else if(bike!=null){
          bike.favoriteId=0;    bikes.value.remove(bike);
        }else{
          numberPlate?.favoriteId=0;
          numberPlates.value.remove(numberPlate);
        }
        update();
        return true;
      });
    } catch (e) {
      EasyLoading.dismiss();
      showSnackBar(message: "Error");
      actionStatus(Status.error);
      return false;
    }
  }

  Future<bool> addToFavorites({Property? property,Car? car,Bike? bike,NumberPlate? numberPlate}) async {
    try {
      status(Status.loading);
      EasyLoading.show(status: "ProcessingPleaseWait".tr);
      //is tey kam krny
      var response = await gApiProvider
          .post(
        path: "favorite/save?propertyId=${property==null?'':property.propertyId}&carId=${car==null?'':car.carId}&bikeId=${bike==null?'':bike.bikeId}&numberPlateId=${numberPlate==null?'':numberPlate.numberPlateId}", authorization: true,);

      EasyLoading.dismiss();
      return  response.fold((l) {
        if(l.errorCode == 401){
          showSnackBar(message: "Please login first");
          Get.toNamed(Routes.loginScreen);
          status(Status.error);
        }
        else{
          showSnackBar(message: l.message!.toString());
          status(Status.error);
        }
        return false;
      }, (r) async {
        if(property!=null){
          property.favoriteId=r.data["id"];
        }else if(car!=null){
          car.favoriteId=r.data["id"];
        }else if(bike!=null){
          bike.favoriteId=r.data["id"];
        }else {
          numberPlate?.favoriteId=r.data["id"];
        }
        showSnackBar(message: r.message.toString());
        status(Status.success);
        return true;
      });

    } catch (e) {
      EasyLoading.dismiss();
      showSnackBar(message: "OperationFailed");
      status(Status.error);
      return false;
    }
  }
}
