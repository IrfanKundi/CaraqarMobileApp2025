import 'dart:async';
import 'dart:io';

import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/models/content_model.dart';
import 'package:careqar/ui/screens/pdf_view_screen.dart';
import 'package:careqar/ui/screens/youtube_player_screen.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/image_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../routes.dart';
import '../../save_file.dart';
import '../widgets/alerts.dart';

class RequirementDetailScreen extends StatefulWidget{
  const RequirementDetailScreen({Key? key}) : super(key: key);

  @override
  State<RequirementDetailScreen> createState() => _RequirementDetailScreenState();
}

class _RequirementDetailScreenState extends State<RequirementDetailScreen> {

  late Requirement requirements;
  late String pdfPath;

  @override
  void initState() {
    super.initState();
    requirements = Get.arguments as Requirement;

    if(requirements.pdfs.isNotEmpty){
      createFileOfPdfUrl(requirements.pdfs.first).then((f) {
        setState(() {
          pdfPath = f.path;
        });
      });
    }

    List<String> parts = divideDescription(requirements.description!, 500);
    part1 = parts[0];
    part2 = parts[1];
  }

  late String? part1;
  late String? part2;

  List<String> divideDescription(String description, int maxLength) {
    if (description.length <= maxLength) {
      return [description, ''];
    } else {
      String part1 = description.substring(0, maxLength);
      String part2 = description.substring(maxLength);
      return [part1, part2];
    }
  }

  Future<File> createFileOfPdfUrl(String path) async {
    Completer<File> completer = Completer();

    try {
      final url = path;
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }






  @override
  Widget build(BuildContext context) {




    int sliderIndex = 0;

    return Scaffold(
      appBar: buildAppBar(context,title: "Requirements".tr),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: kScreenPadding,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 30.h,width: 4.w,decoration: BoxDecoration(
                    color: Colors.deepPurple,borderRadius: kBorderRadius4,
                  )),
                  kHorizontalSpace8,
                  Expanded(
                    child: Text(requirements.title!,style: TextStyle(
                    color: kBlackColor,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w500,)),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: (){
                Get.toNamed(Routes.viewImageScreen,
                    arguments:
                    requirements.images,
                    parameters: {"index": "0"});
              },
              child: SizedBox(
                height: 220.h,
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
                    enlargeStrategy: CenterPageEnlargeStrategy.height,
                    initialPage: sliderIndex,
                    onPageChanged: (index, reason) {
                      sliderIndex = index;
                      setState(() {});
                    },
                  ),
                  items:
                  requirements.images.map((item) {
                    return Builder(
                      builder: (BuildContext context) {
                        return ImageWidget(
                          item,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 0.25.sh,
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ),


            requirements.videoUrls.isEmpty?
            Container(
                padding: kScreenPadding,

                color: kWhiteColor,
                child: HtmlWidget(
                  // the first parameter (`html`) is required
                  requirements.description!,

                  // this callback will be triggered when user taps a link
                  onTapUrl: (url) async {
                    var uri = Uri.parse(url);
                    if (await canLaunchUrl(uri)) {
                      try {
                        await launchUrl(uri);
                        return true;
                      } catch (e) {
                        if (kDebugMode) {
                          print('Failed to launch link: $e');
                        }
                        return false;
                      }
                    } else {
                      if (kDebugMode) {
                        print('Could not launch ${uri.toString()}');
                      }
                      return false;
                    }
                  },

                  // select the render mode for HTML body
                  // by default, a simple `Column` is rendered
                  // consider using `ListView` or `SliverList` for better performance
                  renderMode: RenderMode.column,

                  // set the default styling for text
                  textStyle: Get.textTheme.titleMedium,
                ),
                // Text(requirements.description!,style: Get.textTheme.titleMedium,textAlign: TextAlign.justify)

            ) :
            const SizedBox(),

            requirements.videoUrls.isNotEmpty?Column(children: [
              (part1!=null || part1!="")?
              Container(
                  padding: kScreenPadding,

                  color: kWhiteColor,
                  child: HtmlWidget(
                    // the first parameter (`html`) is required
                    part1!,

                    // this callback will be triggered when user taps a link
                    onTapUrl: (url) async {
                      var uri = Uri.parse(url);
                      if (await canLaunchUrl(uri)) {
                        try {
                          await launchUrl(uri);
                          return true;
                        } catch (e) {
                          if (kDebugMode) {
                            print('Failed to launch link: $e');
                          }
                          return false;
                        }
                      } else {
                        if (kDebugMode) {
                          print('Could not launch ${uri.toString()}');
                        }
                        return false;
                      }
                    },

                    // select the render mode for HTML body
                    // by default, a simple `Column` is rendered
                    // consider using `ListView` or `SliverList` for better performance
                    renderMode: RenderMode.column,

                    // set the default styling for text
                    textStyle: Get.textTheme.titleMedium,
                  )
                  // Text(part1!,style: Get.textTheme.titleMedium,textAlign: TextAlign.justify)

              ):
              const SizedBox(),
              kVerticalSpace16,

              SizedBox(
                  height: 0.3.sh,
                  width: 1.sw,
                  child: YoutubePlayerScreen(videoUrls: requirements.videoUrls)),

              kVerticalSpace16,
              (part2!=null || part2!="")?
              Container(
                  padding: kScreenPadding,

                  color: kWhiteColor,
                  child: HtmlWidget(
                    // the first parameter (`html`) is required
                    part2!,

                    // this callback will be triggered when user taps a link
                    onTapUrl: (url) async {
                      var uri = Uri.parse(url);
                      if (await canLaunchUrl(uri)) {
                        try {
                          await launchUrl(uri);
                          return true;
                        } catch (e) {
                          if (kDebugMode) {
                            print('Failed to launch link: $e');
                          }
                          return false;
                        }
                      } else {
                        if (kDebugMode) {
                          print('Could not launch ${uri.toString()}');
                        }
                        return false;
                      }
                    },

                    // select the render mode for HTML body
                    // by default, a simple `Column` is rendered
                    // consider using `ListView` or `SliverList` for better performance
                    renderMode: RenderMode.column,

                    // set the default styling for text
                    textStyle: Get.textTheme.titleMedium,
                  )
                  // Text(part2!,style: Get.textTheme.titleMedium,textAlign: TextAlign.justify)
              ):
              const SizedBox(),

            ],):const SizedBox(),



            kVerticalSpace16,


            requirements.pdfs.isNotEmpty?Column(
              children: requirements.pdfs.map((e) => InkWell(
                onTap: () async {

                  if(requirements.pdfs.first==e){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PDFScreen(path: pdfPath),));
    }
                  else{
                      createFileOfPdfUrl(e).then((f) {
                        setState(() {
                          pdfPath = f.path;

                          Navigator.push(context, MaterialPageRoute(builder: (context) => PDFScreen(path: pdfPath),));
                        });
                      });
                  }


                },
                child: Container(
                  width: double.infinity,
                  height: 0.20.sh,
                  decoration: BoxDecoration(border: Border.all(width: 1.w,),borderRadius: kBorderRadius8),
                  padding:kScreenPadding,
                  margin: kScreenPadding,
                  child: Stack(alignment: AlignmentDirectional.center,
                    children: [
                      Icon(Icons.file_copy_outlined,
                        size: 70.w,
                        color: kBlackColor.withOpacity(0.6),
                      ),
                      PositionedDirectional(

                        bottom: 0,
                        start: 0,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 4.w, horizontal: 8.w),
                          decoration: BoxDecoration(
                            color: Colors.black38,
                            borderRadius: kBorderRadius4,
                          ),
                          child: Text(
                            "PDF File",
                            style: TextStyle(
                                color: kWhiteColor,
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w600),),
                        ),
                      ),
                      PositionedDirectional(

                        bottom: 0,
                        end: 0,
                        child: InkWell(
                           onTap: () async {
                              try{
                                EasyLoading.show();
                                var file = await SaveFile.downloadFile(e,e.split("/").last);
                                EasyLoading.dismiss();
                                if(file!=null){
                                  OpenFile.open(file.path);
                                }
                              }catch(e){
                                EasyLoading.dismiss();
                                showSnackBar(message: "OperationFailed");
                              }


                            },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 4.w, horizontal: 8.w),
                            decoration: BoxDecoration(
                              color: Colors.black38,
                              borderRadius: kBorderRadius4,
                            ),
                            child: const Icon(Icons.download,color: kWhiteColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )).toList(),
            ):const SizedBox(),


            kVerticalSpace24,

          ],
        ),
      ),
    );
  }
}
