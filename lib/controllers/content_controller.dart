import 'package:careqar/models/content_model.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:get/get.dart';

import '../enums.dart';
import '../global_variables.dart';

class ContentController extends GetxController {
  var status = Status.initial.obs;
  var newsStatus = Status.initial.obs;

  var requirementsStatus = Status.initial.obs;
  var countryRequirementsStatus = Status.initial.obs;

  Content? homeContent;
  Content? newsContent;
  Content? foreignerContent;
  Content? splashContent;
  Content? eStoreContent;
  List<News> news=[];
  List<Requirement> requirements=[];
  List<CountryRequirement> countryRequirements=[];

  reset(){
    homeContent=null;
    newsContent=null;
    splashContent=null;
    foreignerContent=null;
  }
  Future<void> getContent() async {
    try {
      status(Status.loading);
      var response = await gApiProvider.get(path: "appContent/Get?countryId=${gSelectedCountry?.countryId}&type=${gIsVehicle?"Car":"Property"}");
      await response.fold((l) {
        showSnackBar(message: l.message!);
        status(Status.error);
        //exit(0);
      }, (r) async {
        status(Status.success);
        reset();
        for(var item in r.data){
          var content=Content(item);
          if(content.screen=="Home"){
            homeContent=content;
          }
          else if(content.screen=="News"){
            newsContent=content;
          }
          else if(content.screen=="Foreigner"){
            foreignerContent=content;
          }
          else if(content.screen=="Splash"){
            splashContent=content;
          }
          else if(content.screen=="Estore"){
            splashContent=content;
          }

        }

      });
      return;
    } catch (e) {
      showSnackBar(message: "Error");
      status(Status.error);
      // exit(0);
      return;
    }
  }
  Future<void> getNews() async {
    try {
      newsStatus(Status.loading);
      update();
      var response = await gApiProvider.get(path: "appContent/GetNews?countryId=${gSelectedCountry?.countryId}");

      await response.fold((l) {
        showSnackBar(message: l.message!);
        newsStatus(Status.error);

      }, (r) async {
        newsStatus(Status.success);
        news.clear();
        for(var item in r.data){
          news.add(News(item));
        }

      });
      update();

    } catch (e) {
     // showSnackBar(message: "Error");
      newsStatus(Status.error);
      update();

    }
  }
  Future<void> getRequirements() async {
    try {
      requirementsStatus(Status.loading);
      update();
      var response = await gApiProvider.get(path: "appContent/getRequirements?countryId=${gSelectedCountry?.countryId}&type=${gIsVehicle?"Car":"Property"}");

      await response.fold((l) {
        showSnackBar(message: l.message!);
        requirementsStatus(Status.error);

      }, (r) async {
        requirementsStatus(Status.success);
        requirements.clear();
        for(var item in r.data){
          requirements.add(Requirement(item));
        }

      });
      update();
    } catch (e) {
    //  showSnackBar(message: "Error");
      requirementsStatus(Status.error);

    }
  }

  Future<void> getRequirementsByCountry() async {
    try {
      countryRequirementsStatus(Status.loading);
      update();
      var response = await gApiProvider.get(path: "appContent/GetForeignerCategory?countryId=${gSelectedCountry?.countryId}");

      await response.fold((l) {
        showSnackBar(message: l.message!);
        countryRequirementsStatus(Status.error);

      }, (r) async {
        countryRequirementsStatus(Status.success);
        countryRequirements.clear();
        for(var item in r.data){
          countryRequirements.add(CountryRequirement(item));
        }

      });
      update();
    } catch (e) {
      //  showSnackBar(message: "Error");
      countryRequirementsStatus(Status.error);

    }
  }

}
