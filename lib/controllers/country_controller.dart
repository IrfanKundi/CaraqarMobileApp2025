import 'package:careqar/models/country_model.dart';
import 'package:careqar/user_session.dart';
import 'package:get/get.dart';

import '../enums.dart';
import '../global_variables.dart';

class CountryController extends GetxController {
  var status = Status.initial.obs;
  RxList<Country> countries = RxList<Country>([]);


  Future<void> getCountries() async {
    try {
      status(Status.loading);

      var response = await gApiProvider.get(path: "Country/Get");

     await response.fold((l) async{
       //Get.offNamedUntil(Routes.chooseOptionScreen, (route) => false);
        status(Status.error);
      },
             (r) async {
        status(Status.success);
        countries.clear();
        countries.addAll(CountryModel.fromMap(r.data).countries);
          await UserSession.getCountry();
          if(UserSession.country==null){
            gSelectedCountry= countries.first;
          }else{
            gSelectedCountry= countries.firstWhere((element) => element.countryId ==UserSession.country);
          }



      });
    } catch (e) {
      //await FlutterRestart.restartApp();
      status(Status.error);

    }
  }
}
