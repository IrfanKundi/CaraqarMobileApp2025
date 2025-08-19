
import 'package:careqar/controllers/add_property_controller.dart';
import 'package:careqar/controllers/add_request_controller.dart';
import 'package:careqar/ui/screens/add_property_screen.dart';
import 'package:careqar/ui/screens/request_property_screen.dart';
import 'package:careqar/user_session.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewPropertyAdScreen extends StatefulWidget {

  NewPropertyAdScreen({Key? key}) : super(key: key){
      if(UserSession.isLoggedIn!){
        Get.put(AddPropertyController());
        Get.put(AddRequestController());
      }
  }

  @override
  State<NewPropertyAdScreen> createState() => _NewPropertyAdScreenState();
}

class _NewPropertyAdScreenState extends State<NewPropertyAdScreen> with TickerProviderStateMixin{


  late TabController tabController;

  @override
  void initState() {
    tabController=TabController(initialIndex: 0,length: 2,vsync: this);

    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          TabBar(
              controller: tabController,
              tabs: [
            Tab(text: "AddProperty".tr,),
            Tab(text: "AddRequest".tr,),
          ],dividerColor: Colors.transparent),
          Expanded(child: TabBarView(
              controller: tabController,
              children: [
                AddPropertyScreen(),
                RequestPropertyScreen()

      ])
          )],
      ),
    );
  }
}
