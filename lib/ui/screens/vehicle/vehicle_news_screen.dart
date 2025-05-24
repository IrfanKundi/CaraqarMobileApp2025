import 'dart:io';

import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/content_controller.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gif_view/gif_view.dart';
import 'package:video_player/video_player.dart';

class VehicleNewsScreen extends StatefulWidget {

  VehicleNewsScreen({Key? key}) : super(key: key){
   // var controller = Get.put(CompanyController());
   // controller.getCompanies();


  }

  @override
  State<VehicleNewsScreen> createState() => _VehicleNewsScreenState();
}

class _VehicleNewsScreenState extends State<VehicleNewsScreen> {

  VideoPlayerController? _videoPlayerController;
  ContentController? contentController;
  @override
  void dispose() {
    super.dispose();
    if(_videoPlayerController!=null){
      _videoPlayerController?.dispose();
    }

  }
  var currentIndexPosition = 0;
  void playVideo() async{


    _videoPlayerController   =
    Platform.isIOS?  VideoPlayerController.networkUrl(Uri.parse(contentController!.newsContent!.videos[currentIndexPosition],)):

        VideoPlayerController.file(contentController!.newsContent!.files[currentIndexPosition],
            videoPlayerOptions: VideoPlayerOptions(  mixWithOthers: true,));



    _videoPlayerController
      ?..addListener(()async {
        final bool isPlaying = _videoPlayerController!.value.position
            .inMilliseconds <
            _videoPlayerController!.value.duration.inMilliseconds;

        if (!isPlaying) {
          if (currentIndexPosition < (contentController!.newsContent?.files.length)! - 1) {
            currentIndexPosition++;
          } else {
            currentIndexPosition = 0;
          }
          var videoPlayerController=_videoPlayerController;
          await videoPlayerController!.dispose();
          playVideo();
        }
      })
      ..initialize().then((_) {
        //_videoPlayerController.setLooping(true);
        _videoPlayerController!.setVolume(0);
        _videoPlayerController!.play();
        setState(() {

        });
      });
  }


  int sliderIndex=0;

  @override
  void initState() {
    contentController=Get.find<ContentController>();
    if(contentController!.newsContent!.videos.isNotEmpty){
      playVideo();
    }


    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(bottom: 50.h),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            contentController!.newsContent!.videos.isNotEmpty?
            _videoPlayerController!.value.isInitialized
                ? SizedBox(
                height: 220.h,
                width: 1.sw,
                child: VideoPlayer(_videoPlayerController!))
                : Container():
            contentController!.newsContent!.gifs.isNotEmpty?
            GifView.memory(
              Get.find<ContentController>().newsContent!.files.last.readAsBytesSync(),
fit: BoxFit.fill,
              height: 220.h,
              width: 1.sw,
progress: const Center(child: CircularLoader()),

              frameRate: 1, // default is 15 FPS
            ):   SizedBox(   height: 220.h,
              width: 1.sw,
              child: CarouselSlider(
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
                  initialPage: sliderIndex,
                  onPageChanged: (index, reason) {
                    sliderIndex=index;
                    setState(() {

                    });
                  },
                ),
                items:  contentController!.newsContent!.files.map((item) {
                  return Builder(
                    builder: (BuildContext context) {
                      return  Image.memory(item.readAsBytesSync(),
                        fit: BoxFit.fill,
                        width: double.infinity,
                        height: double.infinity,
                      );
                    },
                  );
                }).toList(),
              ),
            ),

            Expanded(
              child:   SafeArea(top: false,
                child:  Padding(
                  padding: kScreenPadding,

                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [

                      Expanded(
                        child: InkWell(
                          onTap: (){
                            Get.toNamed(Routes.companiesScreen,arguments: "Car");

                          },
                          child:Stack(alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              Image.asset("assets/images/carbanner.jpg",fit: BoxFit.cover,width: double.infinity,height: double.infinity,),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 4.w, horizontal: 8.w),
                                decoration: BoxDecoration(
                                  color: Colors.black38,
                                  borderRadius: kBorderRadius4,
                                ),
                                child: Text(
                                  "CarCompanies".tr,
                                  style: TextStyle(
                                      color: kWhiteColor, fontSize: 17.sp,fontWeight: FontWeight.w600),),
                              )
                            ],
                          ),
                        ),
                      ),
                      kVerticalSpace16,
                      Expanded(
                        child: InkWell(
                          onTap: (){
                            Get.toNamed(Routes.companiesScreen,arguments:"Bike");
                          },
                          child:Stack(alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              Image.asset("assets/images/bikebanner.png",fit: BoxFit.cover,width: double.infinity,height: double.infinity,),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 4.w, horizontal: 8.w),
                                decoration: BoxDecoration(
                                  color: Colors.black38,
                                  borderRadius: kBorderRadius4,
                                ),
                                child: Text(
                                  "BikeCompanies".tr,
                                  style: TextStyle(
                                      color: kWhiteColor, fontSize: 17.sp,fontWeight: FontWeight.w600),),
                              ) ],
                          ),
                        ),),
                      kVerticalSpace16,
                      Expanded(
                        child: InkWell(

                          onTap: (){
                            Get.toNamed(Routes.companiesScreen,arguments:"NumberPlate");
                          },
                          child:Stack(alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              Image.asset("assets/images/nplate.jpg",fit: BoxFit.cover,width: double.infinity,height: double.infinity,),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 4.w, horizontal: 8.w),
                                decoration: BoxDecoration(
                                  color: Colors.black38,
                                  borderRadius: kBorderRadius4,
                                ),
                                child: Text(
                                  "NumberPlateCompanies".tr,
                                  style: TextStyle(
                                      color: kWhiteColor, fontSize: 17.sp,fontWeight: FontWeight.w600),),
                              ) ],
                          ),
                        ),),
                    ],
                  ),
                ),

              ),
            )


          ],
        ),
      ),
    );
  }
}
