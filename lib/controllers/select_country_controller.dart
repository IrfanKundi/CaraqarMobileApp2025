import 'package:get/get.dart';

import '../enums.dart';
import '../global_variables.dart';
import '../models/country_model.dart';
import '../routes.dart';
import '../user_session.dart';

class SelectCountryController extends GetxController {
  var status = Status.loading.obs;
  var countries = <Country>[].obs;
  var selectedCountry = Rxn<Country>();

  @override
  void onInit() {
    super.onInit();
    loadCountries();
  }

  void loadCountries() async {
    try {
      status.value = Status.loading;
      // Add your API call here
      // var response = await CountryService.getCountries();
      // countries.value = response;
      status.value = Status.success;
    } catch (e) {
      status.value = Status.error;
    }
  }

  void selectCountry(Country country) async {
    selectedCountry.value = country;
    gSelectedCountry = country;

    if (!deepLinkHandled) {
      await UserSession.changeCountry(country.countryId!);
      Get.offNamedUntil(Routes.chooseOptionScreenNew, (route) => false);
    }
  }
}