import 'dart:io';

import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/service_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:careqar/ui/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceProvidersScreen extends GetView<ServiceController> {


   ServiceProvidersScreen({Key? key}) : super(key: key);





  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: buildAppBar(context,title: "ServiceProviders"),
      body:    SafeArea(
        child:    GetBuilder<ServiceController>(builder: (controller)=> controller
            .providersStatus.value ==
            Status.loading
            ? CircularLoader():

        controller.providersStatus.value ==
            Status.error
            ? Center(
              child: Text(kCouldNotLoadData.tr,
              style: kTextStyle16),
            )
            :

        controller.serviceProviders.isEmpty?
        Center(
            child: Text("NoDataFound".tr,
            style: kTextStyle16)):


            ListView.separated(
              separatorBuilder: (context,index){
                return kVerticalSpace12;
              },
                physics: const PageScrollPhysics(),
                shrinkWrap: true,
                padding: kScreenPadding,
                itemCount: controller.serviceProviders.length,
                itemBuilder: (context, index) {

                  var item = controller.serviceProviders[index];
                  return InkWell(
                     onTap: (){
                       Get.toNamed(Routes.providerDetailScreen,arguments: item);
                     },
                    child: Card(
                      child: Column(
                        children: [
                          ImageWidget(item.image,fit: BoxFit.cover,width: double.infinity,height: 100.h,
                          ),
                          Padding(
                            padding:  EdgeInsets.all(8.w),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column( crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        item.companyName!.toUpperCase(),   maxLines: 1,
                                        style: TextStyle(
                                            color: kAccentColor, fontSize: 15.sp,fontWeight: FontWeight.w600),),

                                      Text(
                                        item.address!,   maxLines: 2,
                                        style: TextStyle(
                                            color: kGreyColor, fontSize: 13.sp),),
                                    ],
                                  )


                                ),

                                  Container(
                                    width: 40.w,
                                    child: OutlinedButton(onPressed: ()async{
                                    await  launch("tel://${item.contactNo}");
                                    },
                                      style: OutlinedButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          side: const BorderSide(color: Colors.transparent)
                                      ), child:Icon(MaterialCommunityIcons.phone,color: kAccentColor,size: 25.w),
                                    ),
                                  ),

                                SizedBox(
                                  width: 40.w,
                                  child: OutlinedButton(onPressed: ()async{
                                    String url;
                                    if (Platform.isIOS) {
                                      url =
                                      "whatsapp://wa.me/${item.contactNo}/?text=hello";
                                    } else {
                                      url =
                                      "whatsapp://send?phone=${item.contactNo}&text=Hello";
                                    }

                                    try{

                                      await launchUrl(Uri.parse(url),);

                                    }catch(e){
                                      showSnackBar(message: "CouldNotLaunchWhatsApp");
                                    }
                                  },
                                    style: OutlinedButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        side: const BorderSide(color: Colors.transparent)
                                    ), child: Image.asset("assets/images/whatsapp.png",width: 22.w,),
                                  ),
                                ),

                                SizedBox(
                                  width: 40.w,
                                  child: OutlinedButton(onPressed: ()async{
                                    var uri = Uri.parse("https://www.google.com/maps/search/?api=1&query=${item.coordinates}");
                                    if (await canLaunch(uri.toString())) {
                                      try{
                                        await launch(uri.toString());
                                      }catch(e){}

                                    } else {
                                      print('Could not launch ${uri.toString()}');
                                    }

                                  },
                                    style: OutlinedButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        side: const BorderSide(color: Colors.transparent)
                                    ), child:Icon(MaterialCommunityIcons.map_marker,color: kAccentColor,size: 25.w),
                                  ),
                                ),
                              ],
                            ),
                          )

                        ],
                      ),
                    ),
                  );


                })
        ),
      ),
    );
  }
}
