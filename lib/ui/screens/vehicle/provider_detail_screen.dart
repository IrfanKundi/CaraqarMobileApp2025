import 'dart:io';

import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/models/service_model.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/image_widget.dart';
import 'package:careqar/ui/widgets/remove_splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ProviderDetailScreen extends StatelessWidget {


   late ServiceProvider serviceProvider;
  ProviderDetailScreen({Key? key}) : super(key: key){


   serviceProvider=Get.arguments;



  }
  @override
  Widget build(BuildContext context) {



    return Scaffold(backgroundColor: kWhiteColor,
      appBar: buildAppBar(context,title:"Profile"),


        body: RemoveSplash(
          child: SingleChildScrollView(

            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: (){
                    Get.toNamed(Routes.viewImageScreen,
                        arguments: serviceProvider.image,parameters: {"index":0.toString()});
                  },
                  child: ImageWidget(
                    serviceProvider.image,
                    width: 1.sw,
                    height:0.3.sh,
                    fit: BoxFit.fill,

                  ),
                ),
                Padding(padding: kScreenPadding,child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                  Text("${serviceProvider.companyName}".toUpperCase(),style: kTextStyle16,),
                    kVerticalSpace4,
                    Row(
                      children: [
                        Expanded(child: Text("${serviceProvider.contactNo}",style: kTextStyle14,)),

                        SizedBox(
                          width: 40.w,
                          child: OutlinedButton(onPressed: ()async{
                            await  launch("tel://${serviceProvider.contactNo}");
                          },
                            style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                side: const BorderSide(color: Colors.transparent)
                            ), child:Icon(MaterialCommunityIcons.phone,color: kAccentColor,size: 25.w),
                          ),
                        ),kHorizontalSpace8,
                        SizedBox(
                          width: 40.w,
                          child: OutlinedButton(onPressed: ()async{
                            String url;
                            if (Platform.isIOS) {
                              url =
                              "whatsapp://wa.me/${serviceProvider.contactNo}/?text=hello";
                            } else {
                              url =
                              "whatsapp://send?phone=${serviceProvider.contactNo}&text=Hello";
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
                      ],
                    ),
                    kVerticalSpace4,

                  Text("${serviceProvider.address}",style: kTextStyle14.copyWith(color:kGreyColor),),
                    kVerticalSpace4,
                    Text("${serviceProvider.cityName}",style: kTextStyle14.copyWith(color:kGreyColor),),






                ],),)



              ],
            )

          ),
        )


     );
  }
}
