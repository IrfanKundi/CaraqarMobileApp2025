
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:get/get.dart';

import '../enums.dart';
import '../global_variables.dart';
import '../models/service_model.dart';

class ServiceController extends GetxController {
  var servicesStatus = Status.loading.obs;
  var subServicesStatus = Status.loading.obs;
  var providersStatus = Status.loading.obs;
  RxList<Service> allServices = RxList<Service>([]);
  RxList<Service> searchedServices = RxList<Service>([]);
  RxList<SubService> allSubServices = RxList<SubService>([]);
  RxList<SubService> searchedSubServices = RxList<SubService>([]);
  RxList<ServiceProvider> serviceProviders = RxList<ServiceProvider>([]);

  int? serviceId;
  int? subServiceId;


  search(String text){
    searchedServices.clear();
    searchedServices.addAll(
      allServices.where((b) => b.serviceName!.toLowerCase().contains(text.trim().toLowerCase())).toList()
    );
    update();
  }
  searchSubService(String text){
    searchedSubServices.clear();
    searchedSubServices.addAll(
        allSubServices.where((b) => b.subServiceName!.toLowerCase().contains(text.trim().toLowerCase())).toList()
    );
    update();
  }


  Future<void> getServices() async {
    try {
      servicesStatus(Status.loading);
     // update();

      var response = await gApiProvider.get(path: "service/Get?countryId=${gSelectedCountry?.countryId}");

      await response.fold((l) {
        showSnackBar(message: l.message!);
        servicesStatus(Status.error);
      }, (r) async {
        servicesStatus(Status.success);
        searchedServices.clear();
        allServices.clear();

        for(var item in r.data){
          allServices.add(Service(item));
        }
        searchedServices.addAll(allServices);
      }); update();
    } catch (e) {
      showSnackBar(message: "Error");
      servicesStatus(Status.error);update();
    }
  }
  Future<void> getSubServices() async {
    try {
      subServicesStatus(Status.loading);
      // update();

      var response = await gApiProvider.get(path: "service/getSubServices?serviceId=$serviceId&countryId=${gSelectedCountry?.countryId}");

      await response.fold((l) {
        showSnackBar(message: l.message!);
        subServicesStatus(Status.error);
      }, (r) async {
        subServicesStatus(Status.success);
        searchedSubServices.clear();
        allSubServices.clear();

        for(var item in r.data){
          allSubServices.add(SubService(item));
        }
        searchedSubServices.addAll(allSubServices);
      }); update();
    } catch (e) {
      showSnackBar(message: "Error");
      subServicesStatus(Status.error);update();
    }
  }
  Future<void> getProviders() async {
    try {
      providersStatus(Status.loading);
      // update();

      var response = await gApiProvider.get(path: "service/GetServiceDetails?serviceId=$serviceId&subServiceId=$subServiceId&countryId=${gSelectedCountry?.countryId}");

      await response.fold((l) {
        showSnackBar(message: l.message!);
        providersStatus(Status.error);
      }, (r) async {
        providersStatus(Status.success);

        serviceProviders.clear();

        for(var item in r.data){
          serviceProviders.add(ServiceProvider(item));
        }
      }); update();
    } catch (e) {
      showSnackBar(message: "Error");
      providersStatus(Status.error);update();
    }
  }

}
