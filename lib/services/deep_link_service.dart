import 'package:app_links/app_links.dart';
import 'package:careqar/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeepLinkService extends GetxService {
  late AppLinks _appLinks;
  bool _openedViaDeeplink = false;

  @override
  Future<void> onInit() async {
    super.onInit();
    _appLinks = AppLinks();
    await _initDeepLinks();
  }

  void setOpenedViaDeeplink(bool value) {
    _openedViaDeeplink = value;
  }

  bool get openedViaDeeplink => _openedViaDeeplink;

  // Add method to handle back navigation from deeplink
  void handleDeeplinkBack() {
    print(" SAHAr ⬅️ handleDeeplinkBack | openedViaDeeplink=$_openedViaDeeplink | currentRoute=${Get.currentRoute}");

    if (_openedViaDeeplink) {
      _openedViaDeeplink = false;
      Get.offAllNamed(Routes.chooseOptionScreenNew);
    } else {
      if (Get.previousRoute.isNotEmpty) {
        Get.back();
      } else {
        Get.offAllNamed(Routes.navigationScreen);
      }
    }
  }

  Future<void> _initDeepLinks() async {
    await _handleInitialLink();

    _handleIncomingLinks();
  }

  Future<void> _handleInitialLink() async {
    try {
      final Uri? initialLink = await _appLinks.getInitialLink();
      if (initialLink != null) {
        // Add delay to ensure app is fully initialized
        //await Future.delayed(Duration(milliseconds: 500));
        print("SAHAr Before processing deeplink, openedViaDeeplink=$_openedViaDeeplink");
        _processDeepLink(initialLink);
        print("SAHAr After processing deeplink, openedViaDeeplink=$_openedViaDeeplink");
      }
    } catch (e) {
      print('SAHArError handling initial link: $e');
    }
  }

  void _handleIncomingLinks() {
    _appLinks.uriLinkStream.listen(
          (Uri uri) {
        // Ensure proper timing for navigation
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _processDeepLink(uri);
        });
      },
      onError: (err) {
        print('SAHAr Error handling incoming link: $err');
      },
    );
  }

  void _processDeepLink(Uri uri) {
    print('SAHAr Processing deep link: $uri');
    print('SAHAr Current route: ${Get.currentRoute}');

    final String scheme = uri.scheme;
    final String host = uri.host;
    final String path = uri.path;
    final Map<String, String> queryParams = uri.queryParameters;

    try {
      // Handle your website links
      if (scheme == 'https' && host == 'caraqaar.com') {
        _handleWebsiteDeepLink(path, queryParams);
      }
      // Handle custom scheme links
      else if (scheme == 'caraqaar') {
        _handleCaraqaarDeepLink(host, path, queryParams);
      }
    } catch (e) {
      print('SAHAr SAHArError processing deep link: $e');
      // Fallback to main navigation
      Get.offAllNamed(Routes.navigationScreen);
    }
  }

  void _handleWebsiteDeepLink(String path, Map<String, String> queryParams) {
    _openedViaDeeplink = true;
    if (path == '/share' || path.startsWith('/share')) {
      if (queryParams.containsKey('carId')) {
        Get.toNamed(Routes.viewCarScreen, arguments: {'carId': queryParams['carId']});
      } else if (queryParams.containsKey('bikeId')) {
        Get.toNamed(Routes.viewBikeScreen, arguments: {'bikeId': queryParams['bikeId']});
      } else if (queryParams.containsKey('propertyId')) {
        Get.toNamed(Routes.viewPropertyScreen, arguments: {'propertyId': queryParams['propertyId']});
      } else if (queryParams.containsKey('companyId')) {
        // Handle company deep link
        final String companyId = queryParams['companyId']!;
        final String type = queryParams['type'] ?? 'Real State';

        print("SAHAr DeepLink → companyId=$companyId, type=$type");
        Get.toNamed(
          Routes.companyScreen,
          arguments: int.parse(companyId),
          parameters: {'type': type},
        );
      } else {
        Get.offAllNamed(Routes.navigationScreen);
      }
    } else {
      // Default fallback for other paths
      Get.offAllNamed(Routes.navigationScreen);
    }
  }

  void _handleCaraqaarDeepLink(String host, String path, Map<String, String> queryParams) {
    _openedViaDeeplink = true;

    try {
      switch (host) {
        case 'property':
          final String propertyId = path.replaceFirst('/', '');
          if (propertyId.isNotEmpty) {
            print(" SAHAr DeepLink → propertyId=$propertyId");
            Get.toNamed(
              Routes.viewPropertyScreen,   // ✅ use declared route name
              arguments: {'propertyId': propertyId},
            );
          } else {
            Get.offAllNamed(Routes.navigationScreen);
          }
          break;

        case 'car':
          final String carId = path.replaceFirst('/', '');
          if (carId.isNotEmpty) {
            print(" SAHAr DeepLink → carId=$carId");
            Get.toNamed(
              Routes.viewCarScreen,
              arguments: {'carId': carId},
            );
          } else {
            Get.offAllNamed(Routes.navigationScreen);
          }
          break;

        case 'bike':
          final String bikeId = path.replaceFirst('/', '');
          if (bikeId.isNotEmpty) {
            print(" SAHAr DeepLink → bikeId=$bikeId");
            Get.toNamed(
              Routes.viewBikeScreen,
              arguments: {'bikeId': bikeId},
            );
          } else {
            Get.offAllNamed(Routes.navigationScreen);
          }
          break;

        case 'company':
          final String pathWithoutSlash = path.replaceFirst('/', '');
          final List<String> pathParts = pathWithoutSlash.split('/');

          if (pathParts.isNotEmpty && pathParts[0].isNotEmpty) {
            final String companyId = pathParts[0];
            // Extract type from path or use default
            final String type = pathParts.length > 1
                ? Uri.decodeComponent(pathParts[1])
                : queryParams['type'] ?? 'Real State';

            print(" SAHAr DeepLink → companyId=$companyId, type=$type");
            Get.toNamed(
              Routes.companyScreen,
              arguments: int.parse(companyId),
              parameters: {'type': type},
            );
          } else {
            Get.offAllNamed(Routes.navigationScreen);
          }
          break;

        default:
          Get.offAllNamed(Routes.navigationScreen);
          break;
      }
    } catch (e) {
      print('❌ Error in caraqaar deep link navigation: $e');
      Get.offAllNamed(Routes.navigationScreen);
    }
  }
}