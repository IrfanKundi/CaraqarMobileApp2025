import 'package:careqar/models/car_model.dart';
import 'package:careqar/models/city_model.dart';
import 'package:careqar/models/company_model.dart';
import 'package:careqar/models/number_plate_model.dart';
import 'package:careqar/models/property_model.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:careqar/user_session.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../enums.dart';
import '../global_variables.dart';
import '../models/bike_model.dart';
import '../routes.dart';
import 'content_controller.dart';

class CompanyController extends GetxController {
  var status = Status.initial.obs;
  var companyStatus = Status.initial.obs;
  var adsStatus = Status.initial.obs;
  late City selectedCity;
  RxList<Company> companies = RxList<Company>([]);

  RxList<Company> searchedCompanies =  RxList<Company>([]);

  var searchText="";

  Company? company;

  ContentController  contentController = Get.find<ContentController>();

  bool isGridView=true;


  Future<void> getCompany(int id,{type="Real State"}) async {
    try {
      companyStatus(Status.loading);
      update();


      var response = await gApiProvider.get(path: "company/Get?countryId=${gSelectedCountry?.countryId}&companyId=$id&type=$type",authorization: true);

      await response.fold((l) { companyStatus(Status.error);
        showSnackBar(message: l.message!);

      update();
      }, (r) async { companyStatus(Status.success);

      company=  CompanyModel.fromMap(r.data).companies.first; update();
      });

    } catch (e) {
      companyStatus(Status.error);
      showSnackBar(message: "Error");
      update();

    }
  }

  Future<void> getCompanies({type="Real State"}) async {
    try {
      status(Status.loading);
      update();

      var response = await gApiProvider.get(path: "company/Get?countryId=${gSelectedCountry?.countryId}&type=$type",authorization: true);

     await response.fold((l) {
        showSnackBar(message: l.message!);
        status(Status.error);
      }, (r) async {
        status(Status.success);
        companies.clear();
        searchedCompanies.clear();
        companies.addAll(CompanyModel.fromMap(r.data).companies);

        searchedCompanies.addAll(companies);





      });
      update();
    } catch (e) {
      showSnackBar(message: "Error");
      status(Status.error);
      update();
    }
  }

  search(String text){
    searchedCompanies.clear();
    searchedCompanies.addAll(
        companies.where((b) => b.companyName!.toLowerCase().contains(text.trim().toLowerCase())).toList()
    );
    update();
  }

  Future<void> getAds(Company company) async {
    try {

      adsStatus(Status.loading);
      update();
      var response = await gApiProvider.get(path: "property/Get?companyId=${company.companyId}");

     await response.fold((l) {
        showSnackBar(message: l.message!);
        adsStatus(Status.error);

      }, (r) async {
       adsStatus(Status.success);
       company.ads.clear();
        for(var item in r.data["properties"]){
          company.ads.add(Property.fromMap(item));
          }


      });
      update();
    } catch (e) {
      showSnackBar(message: "Error");
      adsStatus(Status.error);  update();
    }
  }
  Future<void> getCars(Company company) async {
    try {

      adsStatus(Status.loading);
      update();
      var response = await gApiProvider.get(path: "car/Get?companyId=${company.companyId}");

      await response.fold((l) {
        showSnackBar(message: l.message!);
        adsStatus(Status.error);

      }, (r) async {
        adsStatus(Status.success);
        company.cars.clear();
        for(var item in r.data["cars"]){
          company.cars.add(Car.fromMap(item));
        }


      });
      update();
    } catch (e) {
      showSnackBar(message: "Error");
      adsStatus(Status.error);  update();
    }
  }


  Future<void> getBikes(Company company) async {
    try {

      adsStatus(Status.loading);
      update();
      var response = await gApiProvider.get(path: "bike/Get?companyId=${company.companyId}");

      await response.fold((l) {
        showSnackBar(message: l.message!);
        adsStatus(Status.error);

      }, (r) async {
        adsStatus(Status.success);
        company.bikes.clear();
        for(var item in r.data["bikes"]){
          company.bikes.add(Bike.fromMap(item));
        }


      });
      update();
    } catch (e) {
      showSnackBar(message: "Error");
      adsStatus(Status.error);  update();
    }
  }


  Future<void> getNumberPlates(Company company) async {
    try {

      adsStatus(Status.loading);
      update();
      var response = await gApiProvider.get(path: "numberPlate/Get?companyId=${company.companyId}");

      await response.fold((l) {
        showSnackBar(message: l.message!);
        adsStatus(Status.error);

      }, (r) async {
        adsStatus(Status.success);
        company.numberPlates.clear();
        for(var item in r.data["numberPlates"]){
          company.numberPlates.add(NumberPlate.fromMap(item));
        }


      });
      update();
    } catch (e) {
      showSnackBar(message: "Error");
      adsStatus(Status.error);  update();
    }
  }

  Future<void> followUnfollow(Company? company) async {
    try {

      if(UserSession.isLoggedIn!){
        EasyLoading.show(status: "ProcessingPleaseWait".tr);

        var response = await gApiProvider
            .post(
          path: "follow/save?companyId=${company?.companyId}", authorization: true,);

        EasyLoading.dismiss();
        return  response.fold((l) {
          showSnackBar(message: l.message!);

        }, (r) async {
          if(company?.followId==null)
          {
            company?.followId=r.data["id"];
            company?.followers++;
          }else{
            company?.followId=null;
            company?.followers--;
          }
          update();

         // showSnackBar(message: r.message);


        });

      }else{
        Get.toNamed(Routes.loginScreen);

      }


    } catch (e) {
      EasyLoading.dismiss();
      showSnackBar(message: "OperationFailed");


    }
  }
}
