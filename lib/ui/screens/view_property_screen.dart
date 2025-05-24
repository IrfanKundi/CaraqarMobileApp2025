import 'dart:io';

import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/favorite_controller.dart';
import 'package:careqar/controllers/view_property_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/services/dynamic_link.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:careqar/ui/widgets/button_widget.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:careqar/ui/widgets/icon_button_widget.dart';
import 'package:careqar/ui/widgets/image_widget.dart';
import 'package:careqar/ui/widgets/remove_splash.dart';
import 'package:careqar/ui/widgets/text_field_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart';
import 'package:url_launcher/url_launcher.dart';


import '../../global_variables.dart';

class ViewPropertyScreen extends GetView<ViewPropertyController> {
   ViewPropertyScreen({super.key}){
    controller.sliderIndex(0);
  }

  @override
  Widget build(BuildContext context) {
    controller.formKey = GlobalKey<FormState>();
    return Scaffold(backgroundColor: kWhiteColor,
      body: Obx(() {
        var property = controller.property.value;
        double? pLatitude;
        double? pLongitude;
        if (property?.coordinates != null && property!.coordinates.contains(',')) {
          List<String> coordinates = property.coordinates.split(',');
          pLatitude = double.tryParse(coordinates[0].trim())!;
          pLongitude = double.tryParse(coordinates[1].trim())!;
          }

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
                        Expanded(child: Text("Details".tr.toUpperCase(),textAlign: TextAlign.center,maxLines: 1,style: kAppBarStyle,)),
                        kHorizontalSpace12,
                        IconButtonWidget(icon: MaterialCommunityIcons
                            .share_variant,
                          color: kBlackColor,
                            onPressed: () async {
                              String adUrl = await DynamicLink.createDynamicLink(
                                  false,
                                  uri: "/Properties/Detail/${property.propertyId}",
                                  title: property.title,
                                  desc: property.description,
                                  image: property.images.first);
                              String webUrl = "$kFileBaseUrl/Properties/Detail/${property.propertyId}";
                              var message = "Hey! you might be interested in this.\n$adUrl\nor Check this ad on Car aqar\n$webUrl";

                              Share.share(message);
                            },
                        ),
                      ],
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      background: Stack(
                        alignment: Alignment.center,
                        children: [
                          CarouselSlider(
                            options: CarouselOptions(
                              height: double.infinity,
                              autoPlayCurve: Curves.linearToEaseOut,
                              autoPlay: true,
                              scrollPhysics: const BouncingScrollPhysics(),
                              enableInfiniteScroll: false,
                              aspectRatio: 16 / 9,
                              viewportFraction: 1,
                              enlargeCenterPage: true,
                              enlargeStrategy:
                              CenterPageEnlargeStrategy.height,
                              initialPage: controller.sliderIndex.value,
                              onPageChanged: (index, reason) {
                                controller.sliderIndex.value=index;
                                controller.update();
                              },
                            ),
                            items:  property.images.map((item) {
                            return Builder(
                            builder: (BuildContext context) {
                            return GestureDetector(
                              onTap: (){
                                Get.toNamed(Routes.viewImageScreen,
                                    arguments: property.images,parameters: {"index":property.images.indexOf(item).toString()});
                              },
                              child: ImageWidget(
                              item,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,

                              ),
                            );
                            },
                            );
                            }).toList(),
                          ),

                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Container(
                          //         color: Colors.black38,
                          //         child: IconButtonWidget(
                          //           icon: MaterialCommunityIcons.chevron_left,
                          //           onPressed: () {},
                          //           color: kWhiteColor,)),
                          //     Container(
                          //         color: Colors.black38,
                          //         child: IconButtonWidget(
                          //           icon: MaterialCommunityIcons.chevron_right,
                          //           onPressed: () {},
                          //           color: kWhiteColor,)),
                          //   ],
                          // ),

//                        GetBuilder<ViewPropertyController>(builder: (controller)=> Positioned(
//                               bottom: 10.w,
//                               right: 16.w,
//                               child: Container(
//                                 padding: EdgeInsets.symmetric(
//                                     vertical: 2, horizontal: 8),
//                                 decoration: BoxDecoration(
//                                   color: Colors.black38,
//                                   borderRadius: kBorderRadius30,
//                                 ),
//                                 child: Text(
//                                   "${controller.sliderIndex.value + 1}/${property.images.length}",
//                                   style: TextStyle(
//                                       color: kWhiteColor, fontSize: 12.sp),),
//                               )))
// ,

                          // GestureDetector(
                          //   onTap: (){
                          //     Get.toNamed(Routes.viewImageScreen,
                          //         arguments: property.images,parameters: {"index":0.toString()});
                          //   },
                          //   child: ImageWidget(
                          //     property.images.first,
                          //     width: double.infinity,
                          //     height: double.infinity,
                          //     fit: BoxFit.cover,
                          //
                          //   ),
                          // ),
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
                                decoration: const BoxDecoration(
                                  color: Colors.black12,

                                ),

                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4, horizontal: 8),
                                            decoration: BoxDecoration(
                                              color: property.purpose=="Sell"?  kAccentColor:kLightBlueColor,
                                              borderRadius: kBorderRadius30,
                                            ),
                                            child: Text(
                                              "For${property.purpose}".tr.toUpperCase(),
                                              style: TextStyle(
                                                  color: kWhiteColor, fontSize: 10.sp),),
                                          ),
                                          kVerticalSpace8,
                                          Text(
                                            property.title!.capitalize!, textAlign: TextAlign.center,
                                            maxLines: 1,
                                            style: kLightTextStyle18),
                                          kVerticalSpace4,
                                          Row(
                                            children: [ Icon(  MaterialCommunityIcons.map_marker_outline,    size: 16.sp,
                                              color: kWhiteColor,),
                                              Expanded(
                                                child: Text(
                                                    "${property.location}, ${property.cityName}", style: kTextStyle14.copyWith(color: kWhiteColor)),
                                              ),
kHorizontalSpace12,
                                              Icon(  CupertinoIcons.map_pin_ellipse,    size: 16.sp,
                                                color: kWhiteColor,),
                                              Expanded(
                                                child: Text("${property.area} ${"Marla".tr}",
                                                    style: kTextStyle14.copyWith(color: kWhiteColor)),
                                              ),
                                            ],
                                          ),

                                        ],
                                      ),
                                    ),
                                    Column(crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        GetBuilder<ViewPropertyController>(
                                          builder: (controller)=>
                                              IconButtonWidget(icon: property.favoriteId!>0?
                                              MaterialCommunityIcons.heart:
                                              MaterialCommunityIcons
                                                  .heart_outline,
                                                color:property.favoriteId!>0? kRedColor:kWhiteColor,
                                                width: 30.w,
                                                onPressed: ()async {
                                                  if(property.favoriteId!>0){
                                                    if(await Get.put(FavoriteController()).deleteFavorite(property: property)){
                                                      controller.update();
                                                    }
                                                  }else{
                                                    if(await Get.put(FavoriteController()).addToFavorites(property:property)){
                                                      controller.update();
                                                    }
                                                  }
                                                }
                                                ,),
                                        ),
                                        kVerticalSpace8,
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2, horizontal: 8),
                                          decoration: BoxDecoration(
                                            color: Colors.black38,
                                            borderRadius: kBorderRadius30,
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(MaterialCommunityIcons.eye_outline,size: 16.sp,color: kWhiteColor,),
                                              Text(
                                                " ${property.clicks}",
                                                style: TextStyle(
                                                    color: kWhiteColor, fontSize: 12.sp),),
                                            ],
                                          ),
                                        ),

                                      ],
                                    )
                                  ],
                                ),
                              )),


                        ],
                      ),
                    ), systemOverlayStyle: SystemUiOverlayStyle.dark),
              ];
            },
            body: RemoveSplash(
              child:
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(

                      padding: EdgeInsets.symmetric(horizontal: 12.w,
                          vertical: 8.w),

                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: (){
                              if(property?.companyId!=null){
                                if(Get.previousRoute=="${Routes.companyScreen}?type=Real State&agentAds=${property?.isAgentAd}"){
                                  Get.back();
                                }else{
                                  Get.offNamed(Routes.companyScreen,arguments: property?.companyId,parameters:{"type":"Real State","agentAds":"${property?.isAgentAd}"});
                                }

                              }else if(property?.agentId!=null){
                                if(Get.previousRoute=="${Routes.agentScreen}?type=Real State&agentAds=${property?.isAgentAd}"){
                                  Get.back();
                                }
                                else{
                                  Get.offNamed(Routes.agentScreen,arguments: property?.agentId,parameters:{"type":"Real State","agentAds":"${property?.isAgentAd}"});
                                }

                              }

                            },
                            child: ImageWidget(property?.agentImage==""|| property?.agentImage==null ?"assets/images/profile2.jpg":property?.agentImage,width: 70.r,height: 70.r,
                            isCircular: true,isLocalImage: property?.agentImage==""|| property?.agentImage==null,fit: BoxFit.cover,),
                          ),

                          kHorizontalSpace12,
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${property?.agentName}", style: kTextStyle16.copyWith(color: kAccentColor),),
                             kVerticalSpace4,
                                Text("Owner".tr, style: kTextStyle14.copyWith(color: kGreyColor),),

                              ],
                            ),
                          ),



                          SizedBox(
                            width: 40.w,
                            child: OutlinedButton(onPressed: ()async{controller.updateClicks(isCall: true);
                              await  launch("tel://${property?.contactNo}");
                            },
                              style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  side: const BorderSide(color: Colors.transparent)
                              ), child:Icon(MaterialCommunityIcons.phone,color: kAccentColor,size: 25.w),
                            ),
                          ),
                          SizedBox(
                            width: 40.w,
                            child: OutlinedButton(
                              onPressed: ()async{
                              controller.updateClicks(isWhatsapp: true);

                              String adUrl = await DynamicLink.createDynamicLink(false,
                                  uri: "/Properties/Detail/${property?.propertyId}",
                                  title: property?.title,
                                  desc: property?.description,
                                  image: property?.images.first);

                              String webUrl = "$kFileBaseUrl/Properties/Detail/${property?.propertyId}";
                              String url;
                              var message = Uri.encodeFull("Hello,\n${property?.agentName}\nI would like to get more information about this ad you posted on.\n$adUrl \n or Check this ad on Car aqar\n $webUrl");
                              if (Platform.isIOS) {
                                url =
                                "https://wa.me/${property?.contactNo}?text=$message";
                              }  else {
                                url =
                                "whatsapp://send?phone=${property?.contactNo}&text=$message";
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
                            child: OutlinedButton(
                              onPressed: () async {
                              controller.updateClicks(isEmail: true);

                              String adUrl = await DynamicLink.createDynamicLink(
                                false,
                                uri: "/Properties/Detail/${property?.propertyId}",
                                title: property?.title,
                                desc: property?.description,
                                image: property?.images.first,
                              );

                              String webUrl = "$kFileBaseUrl/Properties/Detail/${property?.propertyId}";
                              String subject = property!.title!;

                              // Properly encode the message to handle spaces and special characters
                              var message = "Hello,\n${property.agentName}\nI would like to get more information about this ad you posted on.\n$adUrl\nOr check this ad on Car aqar\n$webUrl";

                              final Email email = Email(
                                body: message,
                                subject: subject,
                                recipients: [property.email!],
                                isHTML: false,
                              );

                              await FlutterEmailSender.send(email);
                            },
                              style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  side: const BorderSide(color: Colors.transparent)
                              ), child:Icon(MaterialCommunityIcons.email,color: kAccentColor,size: 25.w,),
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
                                  if(property!.floors!>0 && property.floors!=null)
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Image.asset("assets/images/floor.png"
                                            , width: 25.w,
                                            height:25.w,
                                            color: kLightBlueColor,
                                          ), Text(
                                            "${property.floors} ${"Floors".tr}",
                                            style: TextStyle(
                                                color: kAccentColor,
                                                fontSize: 12.sp),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if(property.bedrooms!>0 && property.bedrooms!=null)
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Image.asset("assets/images/bedroom.png"
                                            , width: 25.w,
                                            height:25.w,
                                            color: kLightBlueColor,
                                          ), Text(
                                            "${property.bedrooms} ${"Beds".tr}",
                                            style: TextStyle(
                                                color: kAccentColor,
                                                fontSize: 12.sp),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if(property.baths!>0 && property.baths!=null)
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Image.asset("assets/images/shower.png"
                                            , width: 25.w,
                                            height:25.w,
                                            color: kLightBlueColor,
                                          ),
                                          Text(
                                            "${property.baths} ${"Baths".tr}",
                                            style: TextStyle(
                                                color: kAccentColor,
                                                fontSize: 12.sp),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if(property.kitchens!>0 && property.kitchens!=null)
                                    Expanded(child:  Column(
                                      children: [
                                        Image.asset("assets/images/kitchen.png"
                                          ,
                                          width: 25.w,
                                          height:25.w,
                                          color: kLightBlueColor,
                                        ),
                                        Text(
                                          "${property.kitchens} ${"Kitchens".tr}",
                                          style: TextStyle(
                                              color: kAccentColor,
                                              fontSize: 12.sp),
                                        ),
                                      ],
                                    ),),
                                  if(property.furnished!="" && property.furnished!=null)
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
                                              "${property.furnished!.tr} ${"Furnished".tr}",
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


                    Text("CurrentPrice".tr,
                      textAlign: TextAlign.center, style: kTextStyle14.copyWith(color: kAccentColor),),
                    kVerticalSpace8,
                    Text("${getPrice(property.price!)}", textAlign: TextAlign.center,textDirection: TextDirection.ltr,
                      style: kTextStyle18.copyWith(color: kPrimaryColor),),




                    Padding(
                      padding: kScreenPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [

                          Text("Description".tr, style: kTextStyle16.copyWith(color: kAccentColor),),
                          kVerticalSpace12,
                          Text(
                            "${property.description}",
                            style: kTextStyle14.copyWith(color: kAccentColor),),



                          kVerticalSpace16,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    MaterialCommunityIcons.map_marker_outline,
                                    color: kLightBlueColor,
                                    size: 22.sp,
                                  ),
                                  kHorizontalSpace8,
                                  Expanded(
                                    child: Text(
                                      "${property.location}, ${property.cityName}".tr,
                                      style: kTextStyle16.copyWith(color: kAccentColor),
                                    ),
                                  ),
                                ],
                              ),
                              kVerticalSpace8,
                              pLatitude != null && pLongitude != null
                                  ? InkWell(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  elevation: 2, // Set elevation to 0 to remove the box shadow
                                  child: Container(
                                    width: Get.width, // You can adjust the width here as needed
                                    height: 180.0, // You can adjust the height here as needed
                                    padding: EdgeInsets.all(5.0), // You can adjust the padding here as needed
                                    child: GoogleMap(
                                      zoomGesturesEnabled: false,
                                      zoomControlsEnabled: false,
                                      tiltGesturesEnabled: false,
                                      scrollGesturesEnabled: false,
                                      rotateGesturesEnabled: false,
                                      initialCameraPosition: CameraPosition(target: LatLng(pLatitude, pLongitude), zoom:14),
                                      markers: {
                                        Marker(
                                          markerId: const MarkerId("view_pId"),
                                          position: LatLng(pLatitude, pLongitude),
                                          icon: BitmapDescriptor.defaultMarker,
                                        ),
                                      },
                                    ),
                                  ),
                                ),
                                onTap: () async {
                                  var uri = Uri.parse("https://www.google.com/maps/search/?api=1&query=${property.coordinates}");
                                  if (await canLaunchUrl(uri)) {
                                    try {
                                      await launchUrl(uri);
                                    } catch (e) {
                                      if (kDebugMode) {
                                        print('Failed to launch Google Maps: $e');
                                      }
                                    }
                                  } else {
                                    if (kDebugMode) {
                                      print('Could not launch ${uri.toString()}');
                                    }
                                  }
                                },
                              ) : SizedBox(),








                            ],
                          ),
                          kVerticalSpace16,

                          if( property.featureHeads.isNotEmpty)
                              Padding(
                                padding:  EdgeInsets.only(bottom: 28.w),
                                child: Text("Features/Amenities".tr, style: kTextStyle16.copyWith(color: kAccentColor),),
                              ),

                          Column(
                            children:
                            property.featureHeads.map((e) =>
                                Container(
                                  margin: EdgeInsets.only(bottom: 32.h),
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    alignment: Alignment.topCenter,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 32.w, horizontal: 16.w),
                                        decoration: BoxDecoration(
                                          borderRadius: kBorderRadius4,

                                          border: Border.all(
                                              color: kBorderColor, width: 1.w),

                                        ),
                                        child:

                                            GridView.builder(
                                              padding: EdgeInsets.zero,
                                                physics: const PageScrollPhysics(),
                                                shrinkWrap: true,
                                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                              childAspectRatio: 1,
                                              crossAxisSpacing: 8.w,
                                              mainAxisSpacing: 8.w,
                                              crossAxisCount: 3,
                                            ),
                                                itemCount: e.features.length,


                                                itemBuilder: (context,index){
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment
                                    .center,
                              children: [
                                  ImageWidget(e.features[index].image,width: 30.w,height: 30.w,),

                                  kVerticalSpace4,
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text("${e.features[index].title}${e.features[index].quantity!>0?": ${e.features[index].quantity}":e.features[index].featureOption!=null?": ${e.features[index].featureOption}":""}",
                                      style: kTextStyle12.copyWith(color: kAccentColor),
                                      textAlign: TextAlign.center,),
                                  )
                              ],
                            );
                                            })


                                      ),

                                      Positioned(
                                        top: -16.w,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 6.w, horizontal: 12.w),
                                          decoration: BoxDecoration(
                                              color: kBgColor,
                                              borderRadius: kBorderRadius4,
                                              border: Border.all(
                                                  color: kBorderColor, width: 1.w)
                                          ),
                                          child: Text(
                                            "${e.title}", style: kTextStyle16.copyWith(color: kAccentColor),),
                                        ),
                                      )
                                    ],
                                  ),
                                )).toList(),
                          ),



                          GetBuilder<ViewPropertyController>(
                            id: "comments",
                            builder: (controller)=>

                                Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Text("${"Comments".tr} (${controller.comments.length})",
                                    style: kTextStyle16.copyWith(color: kAccentColor),
                                    ),

                                    kVerticalSpace16,

                                    if (controller.comments.isEmpty) Text("NoComments".tr,style:kTextStyle14,textAlign: TextAlign.center,) else ListView.separated(

                                           physics: const PageScrollPhysics(),
                                           padding: EdgeInsets.zero,
                                           itemBuilder: (context,index){
                                           var item=controller.comments[index];
                                           return Row(crossAxisAlignment: CrossAxisAlignment.start,
                                             children: [
                                               ImageWidget(item.image??"assets/images/profile2.jpg",
                                               isLocalImage: item.image==null,
                                                 width: 50.r,
                                                 height: 50.r,
                                                 isCircular: true,
                                               ),
                                               kHorizontalSpace12,
                                               Expanded(
                                                 child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                                                   children: [
                                                     Text("${item.name}",style: TextStyle(
                                                       fontSize: 15.sp,color: kAccentColor,
                                                       fontWeight: FontWeight.w600
                                                     ),),
                                                     Text("${format(item.createdAt!,locale: gSelectedLocale?.locale?.languageCode,
                                                     )}",style: TextStyle(

                                                       color: kGreyColor,fontSize: 12.sp
                                                     ),),
                                                     kVerticalSpace8,
                                                     Text("${item.comment}",style: TextStyle(
                                                         fontSize: 14.sp,color: kAccentColor
                                                     ),),
                                                   ],
                                                 ),
                                               )
                                             ],
                                           );
                                         },separatorBuilder: (context,index){
                                         return  const Divider();
                                         },shrinkWrap: true,itemCount: controller.comments.length,)



                                  ],
                                )
                          ),
                          kVerticalSpace20,



                          Form(
                            key: controller.formKey,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            child: TextFieldWidget(maxLines: 3,
                              borderRadius: kBorderRadius4,
                              hintText: "TypeComment",
                              text: controller.comment,
                              onChanged: (val){
                              controller.comment=val.toString().trim();
                              },
                              onSaved: (val){
                              controller.comment=val.toString().trim();
                              },
                              validator: (val){

                              if(val.toString().isEmpty){
                                return kRequiredMsg.tr;
                              }else{
                                return null;
                              }
                              },

                            ),
                          ),
                          kVerticalSpace16,

                          ButtonWidget(text: "Comment", onPressed: controller.saveComment)

                        ]
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

String encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}

