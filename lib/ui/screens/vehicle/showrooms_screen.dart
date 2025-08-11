import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/company_controller.dart';
import 'package:careqar/ui/screens/vehicle/showroom_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/app_bar.dart';

class ShowroomsScreen extends StatefulWidget {

  const ShowroomsScreen({Key? key}) : super(key: key);

  @override
  State<ShowroomsScreen> createState() => _ShowroomsScreenState();
}

class _ShowroomsScreenState extends State<ShowroomsScreen> with TickerProviderStateMixin{


  late TabController tabController;
  late CompanyController companyController;

  @override
  void initState() {
    companyController = Get.put(CompanyController());
    companyController.getCompanies(type: "Car");

    tabController=TabController(initialIndex: 0,length: 3,vsync: this);

    tabController.addListener(() {
      if(tabController.index==0){
        companyController.getCompanies(type: "Car");
      }
      else if(tabController.index==1) {
        companyController.getCompanies(type: "Bike");
      }
      else{
        companyController.getCompanies(type: "NumberPlate");
      }

    });
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: buildAppBar(context,title: "Showrooms",),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: kWhiteColor,
              child: TabBar(
                labelStyle: kTextStyle16,
                  controller: tabController,
                  dividerColor: kWhiteColor,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: [
                Tab(text: "Car".tr,),
                    Tab(text: "Bike".tr,),
                    Tab(text: "No.Plate".tr,),
              ]),
            ),
            Expanded(child: TabBarView(
                controller: tabController,
                children: [
                  ShowroomScreen("Car"),
                  ShowroomScreen("Bike"),
                  Center(child: Text("ComingSoon".tr.toUpperCase(), style: kTextStyle16,))
                  // Commented the below code due to coming soon option
                  // ShowroomScreen("NumberPlate")


        ])
            )],
        ),
      ),
    );
  }
}

