




checkForUpdate(context) async {
  //Get Current installed version of app
  //final PackageInfo info = await PackageInfo.fromPlatform();
  //int currentVersion = int.parse(info.buildNumber.trim().replaceAll(".", ""));

  //Get Latest version info from firebase config
 // final RemoteConfig remoteConfig = RemoteConfig.instance;

  // try {
  //   await remoteConfig.setConfigSettings(RemoteConfigSettings(
  //     fetchTimeout: Duration(seconds: 10),
  //     minimumFetchInterval: Duration.zero,
  //   ));
  //   // Using default duration to force fetching from remote server.
  //   bool updated = await remoteConfig.fetchAndActivate();
  //
  //     // the config has been updated, new parameter values are available.
  //     double newVersion = double.parse(remoteConfig
  //         .getString(Platform.isIOS?'new_app_version_ios': 'new_app_version_android')
  //         .trim()
  //         .replaceAll(".", ""));
  //
  //     bool forceUpdate=remoteConfig
  //         .getBool('force_update')??false;
  //     if (newVersion > currentVersion) {
  //
  //       final storeUrl = remoteConfig
  //           .getString(Platform.isIOS?'app_store_url': 'play_store_url').trim();
  //
  //   await   _showUpdateAlert(context,storeUrl:storeUrl,forceUpdate: forceUpdate);
  //     }
  //
  // } catch (ex) {
  //     print(ex);
  // }
}
//Show Dialog to force user to update

  // _launchURL(String url) async {
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw '${"CouldNotLaunch".tr} $url';
  //   }
  // }
  // _showUpdateAlert(BuildContext context,{storeUrl,forceUpdate=false}) {
  //   return showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (_) =>
  //           WillPopScope(
  //             onWillPop: () {
  //               return Future.value(false);
  //             },
  //             child: Platform.isIOS?CupertinoAlertDialog(
  //               title: Column(
  //                 children: <Widget>[
  //                   Text(
  //               "NewUpdateAvailable".tr,
  //                     style: kTextStyle16,
  //                   ),
  //                   kVerticalSpace12,
  //                   Text(
  //                     "ThereIsANewerVersion".tr,
  //                     textAlign: TextAlign.center,
  //                     style: kTextStyle14,
  //                   ),
  //                   kVerticalSpace12,
  //                   const Divider(
  //                   ),
  //                   forceUpdate?
  //                   TextButtonWidget(text: "Update", onPressed: () {
  //                     _launchURL(storeUrl);
  //                   },)
  //                       : Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                     children: <Widget>[
  //                       TextButtonWidget(text: "Later", onPressed: () {
  //                         Navigator.pop(context);
  //                       },),
  //
  //                       const VerticalDivider(),
  //                       TextButtonWidget(text: "Update", onPressed: () {
  //                         _launchURL(storeUrl);
  //                       },),
  //                     ],
  //                   )
  //                 ],
  //               ),
  //             ) :  AlertDialog(
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: kBorderRadius8),
  //               title: Column(
  //                 children: <Widget>[
  //                   Text(
  //               "NewUpdateAvailable".tr,
  //                     style: kTextStyle16,
  //                   ),
  //                   kVerticalSpace12,
  //                   Text(
  //                     "ThereIsANewerVersion".tr,
  //                     textAlign: TextAlign.center,
  //                     style: kTextStyle14,
  //                   ),
  //                   kVerticalSpace12,
  //                   const Divider(
  //                   ),
  //                  forceUpdate?
  //                  TextButtonWidget(text: "Update", onPressed: () {
  //                    _launchURL(storeUrl);
  //                  },)
  //                  : Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                     children: <Widget>[
  //                       TextButtonWidget(text: "Later", onPressed: () {
  //                         Navigator.pop(context);
  //                       },),
  //                       const VerticalDivider(),
  //                       TextButtonWidget(text: "Update", onPressed: () {
  //                         _launchURL(storeUrl);
  //                       },),
  //
  //                     ],
  //                   )
  //                 ],
  //               ),
  //             ),
  //           ));
  // }
