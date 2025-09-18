import 'package:app_links/app_links.dart';
import 'package:careqar/controllers/country_controller.dart';
import 'package:careqar/global_variables.dart';
import 'package:careqar/locale/app_localizations.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/services/deep_link_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:careqar/models/content_model.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  void initState() {
    super.initState();
    _handleAppStart();
  }

  Future<void> _handleAppStart() async {
    // Initialize only essential services
    await _initializeEssentials();

    // Check for deep link first
    final deepLinkService = Get.find<DeepLinkService>();
    final hasDeepLink = await _checkForDeepLink();

    if (hasDeepLink) {
      // Store that app was opened via deeplink
      deepLinkService.setOpenedViaDeeplink(true);
    } else {
      // No deep link, proceed with normal flow
      await _initializeAppData();
      Get.offAllNamed(Routes.chooseOptionScreenNew);
    }
  }

  Future<void> _initializeEssentials() async {
    await Hive.initFlutter();
    Hive.registerAdapter(AppContentAdapter());
    gBox = await Hive.openBox<AppContent>('app-content');
    timeago.setLocaleMessages('ar', timeago.ArMessages());

    // Initialize DeepLinkService
    Get.put(DeepLinkService());
  }

  Future<bool> _checkForDeepLink() async {
    try {
      final appLinks = AppLinks();
      final initialLink = await appLinks.getInitialLink();
      return initialLink != null;
    } catch (e) {
      return false;
    }
  }

  Future<void> _initializeAppData() async {
    // Only load if not handled by deep link
    try {
      await AppLocalizations.getLocale();
      AppLocalizations.future = AppLocalizations.load();

      // Load countries only when needed
      var controller = Get.put(CountryController(), permanent: true);
      await controller.getCountries();
    } catch (e) {
      print('Background initialization error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/images/ic_launcher.png',
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}