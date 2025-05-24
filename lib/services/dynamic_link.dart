

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class DynamicLink {


  static Future<String> createDynamicLink(bool short,{uri="",title,desc,image,metaTag=true}) async {
    EasyLoading.show();


    FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      link: Uri.parse("https://www.caraqar.co$uri"),
      uriPrefix: 'https://careqar.page.link',
      androidParameters: const AndroidParameters(
        packageName: 'com.careqar.app',
        minimumVersion: 0,
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.careqar.app',
        minimumVersion: '0',
      ),
      socialMetaTagParameters:metaTag? SocialMetaTagParameters(
        title: title,
        description: desc,
        imageUrl: Uri.parse(image),
      ):null,
    );
    Uri url;
    if (true) {
      final ShortDynamicLink shortLink = await dynamicLinks.buildShortLink(
          parameters);
      url = shortLink.shortUrl;
    } else {
      url = await dynamicLinks.buildLink(parameters);
    }

    EasyLoading.dismiss();
    return  url.toString();
  }

}