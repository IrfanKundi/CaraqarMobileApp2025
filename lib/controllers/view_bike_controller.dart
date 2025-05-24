import 'package:careqar/controllers/profile_controller.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:careqar/user_session.dart';
import 'package:get/get.dart';

import '../enums.dart';
import '../global_variables.dart';
import '../models/bike_model.dart';

class ViewBikeController extends GetxController {
  var status = Status.initial.obs;


  var sliderIndex=0.obs;

  Rx<Bike?> bike=Rx(null);

  @override
  void onInit() {
    status(Status.loading);

    // TODO: implement onInit
    super.onInit();
  }


  Future<void> getBike(var bikeId) async {
    try {
      status(Status.loading);

      var response =
      await gApiProvider.get(path: "bike/get?bikeId=$bikeId", authorization: true);



     return response.fold((l) {
        showSnackBar(message: l.message!);
        status(Status.error);
      }, (r) async {
        status(Status.success);
        bike.value = BikeModel.fromMap(r.data["bikes"]).bikes.first;
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
        path: "bike/updateClicks?bikeId=${bike.value?.bikeId}&userId=$userId&isEmail=$isEmail&isCall=$isCall&isWhatsapp=$isWhatsapp");


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
      getBike(Get.arguments);
    }else{
      bike.value=Get.arguments;
      updateClicks();
      status(Status.success);
    }

    // TODO: implement onReady
    super.onReady();
  }

}
