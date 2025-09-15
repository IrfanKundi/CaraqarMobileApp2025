import 'package:app_links/app_links.dart';
import 'package:careqar/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeepLinkService extends GetxService {
  late AppLinks _appLinks;

  @override
  Future<void> onInit() async {
    super.onInit();
    _appLinks = AppLinks();
    await _initDeepLinks();
  }

  Future<void> _initDeepLinks() async {
    // Handle app launch from terminated state
    await _handleInitialLink();

    // Handle app links while app is running
    _handleIncomingLinks();
  }

  Future<void> _handleInitialLink() async {
    try {
      final Uri? initialLink = await _appLinks.getInitialLink();
      if (initialLink != null) {
        // Add delay to ensure app is fully initialized
        await Future.delayed(Duration(milliseconds: 500));
        _processDeepLink(initialLink);
      }
    } catch (e) {
      print('Error handling initial link: $e');
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
        print('Error handling incoming link: $err');
      },
    );
  }

  void _processDeepLink(Uri uri) {
    print('Processing deep link: $uri');
    print('Current route: ${Get.currentRoute}');

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
      print('Error processing deep link: $e');
      // Fallback to main navigation
      Get.offAllNamed(Routes.navigationScreen);
    }
  }

  void _handleWebsiteDeepLink(String path, Map<String, String> queryParams) {
    if (path == '/share' || path.startsWith('/share')) {
      if (queryParams.containsKey('carId')) {
        Get.toNamed(Routes.viewCarScreen, arguments: {'carId': queryParams['carId']});
      } else if (queryParams.containsKey('bikeId')) {
        Get.toNamed(Routes.viewBikeScreen, arguments: {'bikeId': queryParams['bikeId']});
      } else if (queryParams.containsKey('propertyId')) {
        Get.toNamed(Routes.viewPropertyScreen, arguments: {'propertyId': queryParams['propertyId']});
      } else {
        Get.offAllNamed(Routes.navigationScreen);
      }
    } else {
      // Default fallback for other paths
      Get.offAllNamed(Routes.navigationScreen);
    }
  }

  void _handleCaraqaarDeepLink(String host, String path, Map<String, String> queryParams) {
    // Handle caraqaar:// links from your website
    try {
      switch (host) {
        case 'car':
          final String carId = path.replaceFirst('/', '');
          if (carId.isNotEmpty) {
            Get.toNamed(Routes.viewCarScreen, arguments: {'carId': carId});
          } else {
            Get.offAllNamed(Routes.navigationScreen);
          }
          break;

        case 'bike':
          final String bikeId = path.replaceFirst('/', '');
          if (bikeId.isNotEmpty) {
            Get.toNamed(Routes.viewBikeScreen, arguments: {'bikeId': bikeId});
          } else {
            Get.offAllNamed(Routes.navigationScreen);
          }
          break;

        case 'property':
          final String propertyId = path.replaceFirst('/', '');
          if (propertyId.isNotEmpty) {
            Get.toNamed(Routes.viewPropertyScreen, arguments: {'propertyId': propertyId});
          } else {
            Get.offAllNamed(Routes.navigationScreen);
          }
          break;

        case 'home':
        default:
          Get.offAllNamed(Routes.navigationScreen);
          break;
      }
    } catch (e) {
      print('Error in caraqaar deep link navigation: $e');
      Get.offAllNamed(Routes.navigationScreen);
    }
  }

  // Generate share links using your website
  String generateShareLink({
    required String type, // 'car', 'bike', 'property'
    required String id,
  }) {
    return 'https://caraqaar.com/share?${type}Id=$id';
  }
}