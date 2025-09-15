import 'dart:io';

import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/view_request_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:careqar/ui/widgets/icon_button_widget.dart';
import 'package:careqar/ui/widgets/image_widget.dart';
import 'package:careqar/ui/widgets/remove_splash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../global_variables.dart';

class ViewRequestScreen extends GetView<ViewRequestController> {
   ViewRequestScreen({Key? key}) : super(key: key){
    //print(Get.arguments);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: kWhiteColor,
      body: Obx(() {
        var request = controller.request.value;
        return controller.status.value==Status.success? NestedScrollView(
            headerSliverBuilder: (BuildContext context,
                bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                    backgroundColor: kWhiteColor,
                    iconTheme: const IconThemeData(color: kBlackColor),
                    expandedHeight: 0.6.sh,
                    pinned: true,
                    title: Row(
                      children: [
                        Expanded(child: Text("Details".tr.toUpperCase(),textAlign: TextAlign.center,maxLines: 1,style: kAppBarStyle,))
                        ,

                        kHorizontalSpace12,
                        IconButtonWidget(icon: MaterialCommunityIcons
                            .share_variant,
                          color: kBlackColor,
                          onPressed: () async {
                            // String url = await DynamicLink.createDynamicLink(
                            //   false,
                            //     uri: "/request?requestId=${request.requestId}",
                            //     metaTag: false,
                            // );
                            // Share.share(url);
                          },),
                      ],
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      background: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            gSelectedLocale?.langCode==0? "assets/images/logo-en.png":"assets/images/logo-ar.png",
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.scaleDown,

                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                            height:20.h,width: 1.sw,
                            decoration: const BoxDecoration(
                                boxShadow:[ BoxShadow(
                                    color: Colors.white,
                                  spreadRadius: 15,
                                  blurRadius: 15,
                                  offset: Offset(0, 15),

                                )]
                            ),
                          ),),
                          Positioned(
                              bottom: 40.h,
                              child: Container(width: 1.sw,
                                padding: kScreenPadding.copyWith(top: 8.w,bottom: 8.w),

                                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 8),
                                      decoration: BoxDecoration(
                                        color: request.purpose=="Sell"?  kAccentColor:kLightBlueColor,
                                        borderRadius: kBorderRadius30,
                                      ),
                                      child: Text(
                                        "For ${request.purpose}".tr.toUpperCase(),
                                        style: TextStyle(
                                            color: kWhiteColor, fontSize: 10.sp),),
                                    ),
                                    kVerticalSpace8,
                                    Row(
                                      children: [ Icon(  MaterialCommunityIcons.map_marker_outline,    size: 16.sp,
                                        color: kAccentColor,),
                                        Expanded(
                                          child: Text(
                                              "${request.location}, ${request.cityName}", style: kTextStyle14.copyWith(color: kAccentColor)),
                                        ),
kHorizontalSpace12,
                                        Icon(  CupertinoIcons.map_pin_ellipse,    size: 16.sp,
                                          color: kAccentColor,),
                                        Expanded(
                                          child: Text("${request.area} ${"Marla".tr}",
                                              style: kTextStyle14.copyWith(color: kAccentColor)),
                                        ),
                                      ],
                                    ),

                                  ],
                                ),
                              )),


                        ],
                      ),
                    ), systemOverlayStyle: SystemUiOverlayStyle.dark),
              ];
            },
            body: RemoveSplash(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(

                      padding: EdgeInsets.symmetric(horizontal: 12.w,
                          vertical: 8.w),

                      child: Row(
                        children: [
                          ImageWidget(request!.customerImage??"assets/images/profile2.jpg",width: 70.r,height: 70.r,
                          isCircular: true,isLocalImage: request.customerImage==null,),

                          kHorizontalSpace12,
                          Expanded(
                            child: Text("${request.customerName}", style: kTextStyle16.copyWith(color: kAccentColor),),
                          ),



                          SizedBox(
                            width: 40.w,
                            child: OutlinedButton(onPressed: ()async{
                              await  launch("tel://${request.phoneNumber!.phoneNumber}");
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


//                               String adUrl = await DynamicLink
//                                   .createDynamicLink(false,
//                                   uri: "/Request/Detail/${request.requestId}",
//                                   metaTag: false);
//                               String url;
//                               var message = Uri.encodeFull("Hello,\n${request.customerName}\nI would like to get more information about this ad you posted on.\n$adUrl \n or Check this ad on Car aqar \n https://www.caraqar.co/request/Detail/${request.requestId}");
//                               if (Platform.isIOS) {
//                                 url =
//                                 "https://wa.me/${request.phoneNumber!.phoneNumber}?text=$message";
//                               } else {
//                                 url =
//                                 "whatsapp://send?phone=${request.phoneNumber!.phoneNumber}&text=$message";
//                               }
// try{
//                               await launchUrl(Uri.parse(url),);
//                             }catch(e){
//                               showSnackBar(message: "CouldNotLaunchWhatsApp");
//                             }
                            },
                              style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  side: const BorderSide(color: Colors.transparent)
                              ), child: Image.asset("assets/images/whatsapp.png",width: 22.w,),
                            ),
                          ),
                          Container(
                            width: 40.w,
                            child: OutlinedButton(onPressed: ()async{
                              // if (Platform.isAndroid) {
                              //   var uri = 'sms:${request.contactNo}?body=hello';
                              //   await launch(uri);
                              // } else if (Platform.isIOS) {
                              //   // iOS
                              //   var uri = 'sms:${request.contactNo}&body=hello';
                              //   await launch(uri);
                              // }
                            },
                              style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  side: const BorderSide(color: Colors.transparent)
                              ), child:Icon(Entypo.chat,color: kAccentColor,size: 25.w,),
                            ),
                          ),


                        ],
                      ),
                    ),

                        Column(
                          children: [
                            Divider(thickness: 1.h, color: Colors.grey.shade400,),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  if(request.floors!>0 && request.floors!=null)
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Image.asset("assets/images/floor.png"
                                            , width: 25.w,
                                            height:25.w,
                                            color: kLightBlueColor,
                                          ), Text(
                                            "${request.floors} ${"Floors".tr}",
                                            style: TextStyle(
                                                color: kAccentColor,
                                                fontSize: 12.sp),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if(request.bedrooms!>0 && request.bedrooms!=null)
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Image.asset("assets/images/bedroom.png"
                                            , width: 25.w,
                                            height:25.w,
                                            color: kLightBlueColor,
                                          ), Text(
                                            "${request.bedrooms} ${"Beds".tr}",
                                            style: TextStyle(
                                                color: kAccentColor,
                                                fontSize: 12.sp),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if(request.baths!>0 && request.baths!=null)
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Image.asset("assets/images/shower.png"
                                            , width: 25.w,
                                            height:25.w,
                                            color: kLightBlueColor,
                                          ),
                                          Text(
                                            "${request.baths} ${"Baths".tr}",
                                            style: TextStyle(
                                                color: kAccentColor,
                                                fontSize: 12.sp),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if(request.kitchens!>0 && request.kitchens!=null)
                                    Expanded(child:  Column(
                                      children: [
                                        Image.asset("assets/images/kitchen.png"
                                          ,
                                          width: 25.w,
                                          height:25.w,
                                          color: kLightBlueColor,
                                        ),
                                        Text(
                                          "${request.kitchens} ${"Kitchens".tr}",
                                          style: TextStyle(
                                              color: kAccentColor,
                                              fontSize: 12.sp),
                                        ),
                                      ],
                                    ),),
                                  if(request.furnished!="" && request.furnished!=null)
                                    Expanded(

                                      child:  Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Image.asset("assets/images/furnished.png"
                                            ,
                                            width: 25.w,
                                            height:25.w,
                                            color: kLightBlueColor,
                                          ),
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              "${request.furnished!.tr} ${"Furnished".tr}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: kAccentColor,
                                                  fontSize: 12.sp),
                                            ),
                                          ),
                                        ],
                                      ),)


                                ],
                              ),
                            ),
                            Divider(thickness: 1.h, color: Colors.grey.shade400,),
                            kVerticalSpace12,
                          ],
                        ),


                    Text("PriceRange".tr,
                      textAlign: TextAlign.center, style: kTextStyle14.copyWith(color: kAccentColor),),
                    kVerticalSpace8,
                    Text("${getPrice(request.startPrice!)} - ${getPrice(request.endPrice!)}",textDirection: TextDirection.ltr, textAlign: TextAlign.center,
                      style: kTextStyle18.copyWith(color: kPrimaryColor),),




                    Padding(
                      padding: kScreenPadding,
                      child: Row(
                        children: [
                          Icon(MaterialCommunityIcons.map_marker_outline,
                            color: kLightBlueColor, size: 22.sp,),

                          kHorizontalSpace8,

                          Expanded(child: Text("${request.location}, ${request.cityName}".tr,
                            style: kTextStyle16.copyWith(color: kAccentColor),)),

                          kHorizontalSpace12,
                          GestureDetector(
                            onTap: ()async{
                              var uri = Uri.parse("https://www.google.com/maps/search/?api=1&query=${request.coordinates}");
                              if (await canLaunch(uri.toString())) {
                                await launch(uri.toString());
                              } else {
                                print('Could not launch ${uri.toString()}');
                              }

                            },
                            child: ImageWidget(gSelectedCountry!.mapImage!,width: 80.w,
                              height: 130.h,
                            ),
                          ),

                        ],
                      ),
                    )


                  ],
                ),
              ),
            ),
          ):CircularLoader();
      }
      ),
    );

  }
}
