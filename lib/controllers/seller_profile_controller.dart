import 'package:careqar/models/car_model.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import '../global_variables.dart';
import '../models/UserProfile.dart' show UserProfile;

class SellerProfileController extends GetxController {

  // Observable variables
  final Rx<UserProfile?> userProfile = Rx<UserProfile?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxInt publishedAdsCount = 0.obs; // Updated to start with 0

  // Car listings variables - ADDED
  final Rx<List<Car>> cars = Rx<List<Car>>([]);
  final RxBool isLoadingCars = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString carError = ''.obs;
  final RxBool isGridView = true.obs;
  final RxInt page = 1.obs;
  final RxInt fetch = 50.obs;
  final RxBool loadMore = true.obs;

  // Profile data for filtering - ADDED
  int? currentUserId;
  String? currentAgentName;

  @override
  void onInit() {
    super.onInit();

    // Get userId from arguments or parameters
    int? userId;
    String? contactNo;
    String? agentName;

    // Try to get from arguments first
    if (Get.arguments != null) {
      userId = Get.arguments['userId'];
      contactNo = Get.arguments['contactNo'];
      agentName = Get.arguments['agentName'];
    }
    // If not found in arguments, try parameters
    else if (Get.parameters['userId'] != null) {
      userId = int.tryParse(Get.parameters['userId']!);
    }

    // Store for car filtering - ADDED
    currentUserId = userId;
    currentAgentName = agentName;

    // Debug print
    if (kDebugMode) {
      debugPrint(' SAHAr 🔍 Controller - userId: $userId');
      debugPrint(' SAHAr 🔍 Controller - contactNo: $contactNo');
      debugPrint(' SAHAr 🔍 Controller - agentName: $agentName');
    }

    // Profile creation logic
    if (userId == null || userId == 0) {
      if (kDebugMode) {
        debugPrint(' SAHAr 🎭 Creating fake profile (userId is $userId)');
      }
      createFakeProfile(contactNo, agentName);
    } else {
      if (kDebugMode) {
        debugPrint(' SAHAr 🌐 Fetching real profile for userId: $userId');
      }
      fetchUserProfile(userId);
    }

    // Load cars - ADDED
    loadSellerCars();
  }

  void createFakeProfile(String? contactNo, String? agentName) {
    try {
      isLoading.value = true;
      error.value = '';

      if (kDebugMode) {
        debugPrint(' SAHAr 🎭 Creating fake profile with contactNo: $contactNo, agentName: $agentName');
      }

      // Simulate loading delay
      Future.delayed(const Duration(milliseconds: 500), () {
        // Array of fake profile images
        List<String> fakeProfileImages = [
          'assets/profiles/images1.jpeg',
          'assets/profiles/images2.jpeg',
          'assets/profiles/images3.jpeg',
          'assets/profiles/images4.jpeg',
          'assets/profiles/images5.jpeg',
          'assets/profiles/images6.jpeg',
          'assets/profiles/images7.jpeg',
          'assets/profiles/images8.jpeg',
          'assets/profiles/images9.jpeg',
        ];

        // Get random image from the array
        String randomImage = fakeProfileImages[DateTime.now().millisecond % fakeProfileImages.length];

        if (kDebugMode) {
          debugPrint(' SAHAr 🖼️ Selected random profile image: $randomImage');
        }

        // Create fake profile data with location
        final fakeProfileData = {
          'UserId': 0,
          'FirstName': agentName ?? 'Guest User',
          'LastName': null,
          'CountryCode': '+92',
          'PhoneNumber': contactNo?.replaceAll('+92', '') ?? '1234567890',
          'Email': 'guest@example.com',
          'Password': null,
          'Image': randomImage,
          'CreatedAt': DateTime.now().toIso8601String(),
          'Status': 'Guest',
          'IsDeleted': false,
          'Otp': null,
          'PhoneNumberVerified': false,
          'EmailVerified': false,
          'OtpExpiry': null,
          'LoginWith': null,
          'AccountId': null,
          'IsCustomImage': null,
          'IsCustomInfo': false,
          'CountryId': null,
          'IsoCode': null,
          'cityId': null,
          'cityName': 'Punjab', // Default fake city
          'locationId': null,
          'locationName': 'Lahore', // Default fake location
        };

        // Create UserProfile from fake data
        userProfile.value = UserProfile.fromJson(fakeProfileData);

        if (kDebugMode) {
          debugPrint(' SAHAr Fake profile created successfully for: ${userProfile.value?.fullName}');
        }

        isLoading.value = false;
      });

    } catch (e) {
      error.value = 'Failed to create profile';
      if (kDebugMode) {
        debugPrint(' SAHAr ❌ Exception in createFakeProfile: $e');
      }
      isLoading.value = false;
    }
  }

  Future<void> fetchUserProfile(int userId) async {
    try {
      isLoading.value = true;
      error.value = '';

      final result = await gApiProvider.get(
        path: 'user/GetProfile?userId=$userId',
        authorization: false,
      );

      result.fold(
            (errorModel) {
          error.value = errorModel.message ?? 'Failed to load profile';
          if (kDebugMode) {
            debugPrint(' SAHAr ❌ Error fetching profile: ${errorModel.message}');
          }
        },
            (successModel) {
          if (successModel.data != null && successModel.data is List) {
            final List dataList = successModel.data as List;
            if (dataList.isNotEmpty) {
              userProfile.value = UserProfile.fromJson(dataList[0]);
              if (kDebugMode) {
                debugPrint(' SAHAr Profile loaded successfully for: ${userProfile.value?.fullName}');
              }
            } else {
              error.value = 'No profile data found';
            }
          } else {
            error.value = 'Invalid response format';
          }
        },
      );
    } catch (e) {
      error.value = 'Something went wrong. Please try again.';
      if (kDebugMode) {
        debugPrint(' SAHAr ❌ Exception in fetchUserProfile: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }

  // ADDED - Load seller's cars
  Future<void> loadSellerCars() async {
    try {
      if (page > 1) {
        isLoadingMore.value = true;
      } else {
        isLoadingCars.value = true;
        cars.value.clear();
      }

      carError.value = '';

      if (kDebugMode) {
        debugPrint(' SAHAr 🚗 Loading cars for userId: $currentUserId, agentName: $currentAgentName');
      }

      String path = "car/get"
          "?companyAds=false"
          "&personalAds=true"
          "&condition="
          "&fuelType="
          "&transmission="
          "&color="
          "&modelId="
          "&brandId="
          "&typeId="
          "&countryId=${gSelectedCountry!.countryId}"
          "&page=${page.value}"
          "&fetch=${fetch.value}"
          "&cityId="
          "&locationId="
          "&startPrice="
          "&endPrice="
          "&startModelYear="
          "&endModelYear="
          "&sortBy=";

      var response = await gApiProvider.get(path: path, authorization: true);

      isLoadingMore.value = false;
      isLoadingCars.value = false;

      await response.fold(
            (l) {
          carError.value = l.message ?? 'Failed to load cars';
          if (kDebugMode) {
            debugPrint(' SAHAr ❌ Error loading cars: ${l.message}');
          }
        },
            (r) async {
          List<Car> allCars = CarModel.fromMap(r.data["cars"]).cars;

          // Filter cars based on userId or agentName
          List<Car> filteredCars = allCars.where((car) {
            if (currentUserId == 0 || currentUserId == null) {
              // For guest users, filter by agentName
              return car.agentName == currentAgentName;
            } else {
              // For real users, filter by userId
              return car.userId == currentUserId;
            }
          }).toList();

          if (kDebugMode) {
            debugPrint(' SAHAr 🚗 Total cars from API: ${allCars.length}');
            debugPrint(' SAHAr 🚗 Filtered cars for this seller: ${filteredCars.length}');
          }

          if (page.value > 1) {
            if (filteredCars.isEmpty) {
              loadMore.value = false;
            }
            cars.value.addAll(filteredCars);
          } else {
            cars.value = filteredCars;
          }

          // Update published ads count
          publishedAdsCount.value = cars.value.length;
        },
      );

    } catch (e) {
      isLoadingMore.value = false;
      isLoadingCars.value = false;
      carError.value = 'Something went wrong while loading cars';
      if (kDebugMode) {
        debugPrint(' SAHAr ❌ Exception in loadSellerCars: $e');
      }
    }
  }

  // ADDED - Toggle view
  void toggleView() {
    isGridView.value = !isGridView.value;
  }

  // ADDED - Load more cars
  Future<void> loadMoreCars() async {
    if (!loadMore.value || isLoadingMore.value) return;
    page.value++;
    await loadSellerCars();
  }

  Future<void> refreshProfile() async {
    // Reset pagination - UPDATED
    page.value = 1;
    loadMore.value = true;

    if (userProfile.value != null) {
      if (userProfile.value!.userId == 0) {
        // For fake profiles, get the data from arguments again
        String? contactNo = Get.arguments?['contactNo'];
        String? agentName = Get.arguments?['agentName'];
        createFakeProfile(contactNo, agentName);
      } else {
        await fetchUserProfile(userProfile.value!.userId);
      }
    }

    // Reload cars - ADDED
    await loadSellerCars();
  }

  String? makeCall() {
    String? phoneNumber;

    if (userProfile.value?.userId == 0) {
      phoneNumber = Get.arguments?['contactNo'];
    } else {
      phoneNumber = userProfile.value?.fullPhoneNumber;
    }

    if (phoneNumber?.isNotEmpty == true) {
      if (kDebugMode) {
        debugPrint('SAHAr 📞 Calling: $phoneNumber');
      }
    }

    return phoneNumber;
  }


  void sendWhatsAppMessage() {
    String? phoneNumber;

    if (userProfile.value?.userId == 0) {
      // For fake profile, use contactNo from arguments
      phoneNumber = Get.arguments?['contactNo'];
    } else {
      // For real profile, use fullPhoneNumber
      phoneNumber = userProfile.value?.fullPhoneNumber;
    }

    if (phoneNumber?.isNotEmpty == true) {
      String cleanNumber = phoneNumber!.replaceAll('+', '').replaceAll(' ', '');
      if (kDebugMode) {
        debugPrint(' SAHAr 💬 WhatsApp: $cleanNumber');
      }
    }
  }
}