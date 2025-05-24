import 'package:careqar/models/bike_model.dart';
import 'package:careqar/models/car_model.dart';
import 'package:careqar/models/property_model.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:get/get.dart';

import '../enums.dart';
import '../global_variables.dart';
import '../models/number_plate_model.dart';

class AgentController extends GetxController {
  var status = Status.initial.obs;
  var adsStatus = Status.initial.obs;
  RxList<Property> ads = RxList<Property>([]);
  RxList<Car> cars = RxList<Car>([]);
  RxList<Bike> bikes = RxList<Bike>([]);
  RxList<NumberPlate> numberPlates = RxList<NumberPlate>([]);

  bool isGridView=true;


  Future<void> getCars(int agentId,bool agentAds) async {
    try {

      adsStatus(Status.loading);
      update();
      var response = await gApiProvider.get(path: "car/Get?${agentAds?"agent":"user"}=$agentId");

      await response.fold((l) {
        showSnackBar(message: l.message!);
        adsStatus(Status.error);

      }, (r) async {
        adsStatus(Status.success);
        cars.clear();
        for(var item in r.data["cars"]){
          cars.add(Car.fromMap(item));
        }


      });
      update();
    } catch (e) {
      showSnackBar(message: "Error");
      adsStatus(Status.error);  update();
    }
  }


  Future<void> getBikes(int agentId,bool agentAds) async {
    try {

      adsStatus(Status.loading);
      update();
      var response = await gApiProvider.get(path: "bike/Get?${agentAds?"agent":"user"}=$agentId");

      await response.fold((l) {
        showSnackBar(message: l.message!);
        adsStatus(Status.error);

      }, (r) async {
        adsStatus(Status.success);
        bikes.clear();
        for(var item in r.data["bikes"]){
          bikes.add(Bike.fromMap(item));
        }


      });
      update();
    } catch (e) {
      showSnackBar(message: "Error");
      adsStatus(Status.error);  update();
    }
  }


  Future<void> getNumberPlates(int agentId,bool agentAds) async {
    try {

      adsStatus(Status.loading);
      update();
      var response = await gApiProvider.get(path: "numberPlate/Get?${agentAds?"agent":"user"}=$agentId");

      await response.fold((l) {
        showSnackBar(message: l.message!);
        adsStatus(Status.error);

      }, (r) async {
        adsStatus(Status.success);
        numberPlates.clear();
        for(var item in r.data["numberPlates"]){
          numberPlates.add(NumberPlate.fromMap(item));
        }


      });
      update();
    } catch (e) {
      showSnackBar(message: "Error");
      adsStatus(Status.error);  update();
    }
  }

  Future<void> getAds(int agentId,bool agentAds) async {
    try {

      adsStatus(Status.loading);
      update();
      var response = await gApiProvider.get(path: "property/Get?${agentAds?"agent":"user"}=$agentId");

     await response.fold((l) {
        showSnackBar(message: l.message!);
        adsStatus(Status.error);

      }, (r) async {
       adsStatus(Status.success);
      ads.clear();
        for(var item in r.data["properties"]){
          ads.add(Property.fromMap(item));
          }
      });
      update();
    } catch (e) {
      showSnackBar(message: "Error");
      adsStatus(Status.error);  update();
    }
  }

}
