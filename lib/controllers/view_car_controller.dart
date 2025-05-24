import 'package:careqar/controllers/profile_controller.dart';
import 'package:careqar/models/car_model.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:careqar/user_session.dart';
import 'package:get/get.dart';

import '../enums.dart';
import '../global_variables.dart';

class ViewCarController extends GetxController {
  var status = Status.initial.obs;

  var sliderIndex=0.obs;

  Rx<Car?> car=Rx(null);


  @override
  void onInit() {
    status(Status.loading);

    // TODO: implement onInit
    super.onInit();
  }


  Future<void> getCar(var carId) async {
    try {
      status(Status.loading);

      var response =
      await gApiProvider.get(path: "car/get?carId=$carId", authorization: true);



     return response.fold((l) {
        showSnackBar(message: l.message!);
        status(Status.error);
      }, (r) async {
        status(Status.success);
        car.value = CarModel.fromMap(r.data["cars"]).cars.first;
        updateClicks();
      });
    } catch (e) {

      showSnackBar(message: "Error");
      status(Status.error);
    }
  }

  Future<bool> updateClicks({isEmail=false,isWhatsapp=false,isCall=false}) async {
    try {



      var userId;

      if(UserSession.isLoggedIn!){
      userId=Get.find<ProfileController>().user.value.userId;
      }else{
    userId=UserSession.guestUserId;
      }


      var response = await gApiProvider
          .post(
        path: "car/updateClicks?carId=${car.value?.carId}&userId=$userId&isEmail=$isEmail&isCall=$isCall&isWhatsapp=$isWhatsapp");


      return  response.fold((l) {
        return false;
      }, (r) async {
        return true;
      });

    } catch (e) {
      return false;
    }
  }


  @override
  void onReady() {
    if(Get.arguments is String){
      getCar(Get.arguments);
    }else{
      car.value=Get.arguments;
      updateClicks();
      status(Status.success);
    }

    // TODO: implement onReady
    super.onReady();
  }

}
