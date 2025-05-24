import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/service_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:careqar/ui/widgets/image_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../global_variables.dart';
import 'coming_soon_screen.dart';

class ChooseServiceScreen extends GetView<ServiceController> {
  ChooseServiceScreen({Key? key}) : super(key: key){
  Get.put(ServiceController()).getServices();
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: buildAppBar(context,title: "ChooseService"),
      body: GetBuilder<ServiceController>(builder: (serviceController)=> serviceController
          .servicesStatus.value ==
          Status.loading
          ? const CircularLoader():

      serviceController.servicesStatus.value ==
          Status.error
          ? Center(
            child: Text(kCouldNotLoadData.tr,
            style: kTextStyle16),
          )
          :


      Column(
        children: [
          Padding(
            padding:kHorizontalScreenPadding,
            child: CupertinoSearchTextField(onChanged: (val) => serviceController.search(val),
            placeholder: "Search".tr),
          ),
        Expanded(
            child:   serviceController.searchedServices.isEmpty?
            Center(
              child: Text("NoDataFound".tr,
                  style: kTextStyle16),
            ):  ListView.separated(
              shrinkWrap: true,
              padding: kScreenPadding,
                itemCount: serviceController.searchedServices.length,
              separatorBuilder: (context,index){
                return kVerticalSpace12;
    },
              itemBuilder: (context, index) {
                  var item = serviceController.searchedServices[index];
                  return InkWell(
                    onTap: (){
                      if(item.serviceId==5){
                        // Get.toNamed(Routes.eStoreScreen);
                        Navigator.of(gNavigatorKey.currentContext!).push(MaterialPageRoute(builder: (context) => ComingSoonScreen(title: "Estore Screen",)),);

                      }else{
                        controller.serviceId = item.serviceId;
                        serviceController.getSubServices();
                        Get.toNamed(Routes.chooseSubServiceScreen);
                      }

                    },
                    child:   Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      ImageWidget(item.image,
                        fit: BoxFit.scaleDown,
                        width: 0.7.sw,
                        height: 0.2.sh,
                      ),
                      PositionedDirectional(
                        end: 0,
                        top:0,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 4.w, horizontal: 8.w),
                          decoration: BoxDecoration(
                            color: Colors.black38,
                            borderRadius: kBorderRadius4,
                          ),
                          child: Text(
                            "${item.serviceName}",
                            style: TextStyle(
                                color: kWhiteColor, fontSize: 17.sp,fontWeight: FontWeight.w600),),
                        ),
                      )
                    ],
                  ),);

                }
                ),
          ),
        ],
      ),
      ),
    );
  }
}
