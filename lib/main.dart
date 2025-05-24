
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:careqar/models/content_model.dart';
import 'controllers/country_controller.dart';
import 'global_variables.dart';
import 'locale/app_localizations.dart';
import 'my_app.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  var controller= Get.put(CountryController(),permanent: true);
  var future = controller.getCountries(); // Get Countries from BackEnd
  await AppLocalizations.getLocale(); //Get Language Data from BackEnd

  AppLocalizations.future = AppLocalizations.load(); // Load Languages in app
  await Firebase.initializeApp(options: FirebaseOptions(
    apiKey: 'AIzaSyAx1S2ewLkXDqgDsABZ0FhuU25oZx3euz8',
    appId: '1:524581358673:android:46813e1a28ed6319a43c70',
    messagingSenderId: '524581358673',
    projectId: 'car-eqar',
    storageBucket: 'car-eqar.firebasestorage.app',
  )); // Firebase Initialization
  await Hive.initFlutter(); // Initialize Hive for creating boxes
  Hive.registerAdapter(AppContentAdapter());
  gBox = await Hive.openBox<AppContent>('app-content'); // Creating Hive Box
  timeago.setLocaleMessages('ar', timeago.ArMessages());
  await future;



  runApp(DevicePreview(
    enabled: false,
    builder: (context) => MyApp(), // Wrap your app
  ));
}


