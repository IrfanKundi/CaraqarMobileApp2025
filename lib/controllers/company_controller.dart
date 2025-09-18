import 'package:careqar/models/car_model.dart';
import 'package:careqar/models/city_model.dart';
import 'package:careqar/models/company_model.dart';
import 'package:careqar/models/number_plate_model.dart';
import 'package:careqar/models/property_model.dart';
import 'package:careqar/services/share_link_service.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:careqar/user_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';
import '../constants/style.dart';
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
  ShareService shareService = Get.find<ShareService>();

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

  // Share company functionality
  Future<void> shareCompany(Company company, String type) async {
    try {
      await shareService.shareCompany(
        companyId: company.companyId.toString(),
        companyName: company.companyName ?? 'Company',
        companyType: type,
        totalAds: company.totalAds.toString(),
        description: company.description,
        location: '', // Add location if available in company model
      );
    } catch (e) {
      showSnackBar(message: "SharingFailed".tr);
    }
  }

  // Share company via WhatsApp
  Future<void> shareCompanyToWhatsApp(Company company, String type) async {
    try {
      await shareService.shareCompanyToWhatsApp(
        companyId: company.companyId.toString(),
        phoneNumber: company.contactNo,
        companyName: company.companyName ?? 'Company',
        companyType: type,
        totalAds: company.totalAds.toString(),
        description: company.description,
        location: '', // Add location if available in company model
      );
    } catch (e) {
      showSnackBar(message: "CouldNotLaunchWhatsApp".tr);
    }
  }

  // Share company via Email
  Future<void> shareCompanyToEmail(Company company, String type) async {
    try {
      await shareService.shareCompanyToEmail(
        companyId: company.companyId.toString(),
        email: company.email ?? '',
        companyName: company.companyName ?? 'Company',
        companyType: type,
        totalAds: company.totalAds.toString(),
        description: company.description,
        location: '', // Add location if available in company model
      );
    } catch (e) {
      showSnackBar(message: "CouldNotSendEmail".tr);
    }
  }

  // Show share options bottom sheet
  void showShareOptions(Company company, String type) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 4,
              width: 40,
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'Share Company',
                    style: kTextStyle16,
                  ),
                  kVerticalSpace16,
                  ListTile(
                    leading: const Icon(Icons.share, color: kAccentColor),
                    title: Text('Share via Apps', style: kTextStyle14),
                    onTap: () {
                      Get.back();
                      shareCompany(company, type);
                    },
                  ),
                  ListTile(
                    leading: Image.asset("assets/images/whatsapp.png", width: 24),
                    title: Text('Share via WhatsApp', style: kTextStyle14),
                    onTap: () {
                      Get.back();
                      shareCompanyToWhatsApp(company, type);
                    },
                  ),
                  ListTile(
                    leading: const Icon(MaterialCommunityIcons.email, color: kAccentColor),
                    title: Text('Share via Email', style: kTextStyle14),
                    onTap: () {
                      Get.back();
                      shareCompanyToEmail(company, type);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
