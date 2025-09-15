import 'package:careqar/models/content_model.dart';
import 'package:careqar/services/deep_link_service.dart';
import 'package:careqar/services/share_link_service.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'controllers/country_controller.dart';
import 'global_variables.dart';
import 'locale/app_localizations.dart';
import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Only essential, fast initialization that must complete before app starts
  await Firebase.initializeApp(options: FirebaseOptions(
    apiKey: 'AIzaSyAx1S2ewLkXDqgDsABZ0FhuU25oZx3euz8',
    appId: '1:524581358673:android:46813e1a28ed6319a43c70',
    messagingSenderId: '524581358673',
    projectId: 'car-eqar',
    storageBucket: 'car-eqar.firebasestorage.app',
  ));

  await Hive.initFlutter();
  Hive.registerAdapter(AppContentAdapter());
  gBox = await Hive.openBox<AppContent>('app-content');
  timeago.setLocaleMessages('ar', timeago.ArMessages());

  // Start app immediately - don't block on heavy operations
  runApp(DevicePreview(
    enabled: false,
    builder: (context) => MyApp(),
  ));

  // Heavy initialization after app starts - this won't block deep links
  _initializeAppAfterStart();
}

void _initializeAppAfterStart() {
  // Use addPostFrameCallback to ensure app is fully rendered first
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    try {
      // Initialize countries in background
      _initializeCountries();

      // Initialize localization in background
      _initializeLocalization();

    } catch (e) {
      print('Background initialization error: $e');
      // Don't crash the app if background init fails
    }
  });
}
void _initializeLocalization() async {
  try {
    await AppLocalizations.getLocale();
    AppLocalizations.future = AppLocalizations.load();
    print('Localization initialized successfully');
  } catch (e) {
    print('Failed to initialize localization: $e');
    // Don't crash - app can work with default locale
  }
}
void _initializeCountries() async {
  try {
    // Check if controller already exists and has data
    if (Get.isRegistered<CountryController>()) {
      final controller = Get.find<CountryController>();
      if (controller.countries.isNotEmpty) {
        return; // Already loaded
      }
    }

    // Load countries in background
    var controller = Get.put(CountryController(), permanent: true);
    await controller.getCountries();
    print('Countries loaded successfully');
  } catch (e) {
    print('Failed to load countries: $e');
    // Don't crash - app can work without countries initially
  }
}


