import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class UserModel {
  int? userId;
  String? firstName;
  String? lastName;
  String? profileImage;
  String? email;
  PhoneNumber? phoneNumber;
  String? loginWith;
  String? cityId;
  String? cityName;
  String? locationId;
  String? locationName;

  UserModel();

  UserModel.fromMap(map) {
    try {
      // Handle both array and object responses
      var userData;
      if (map is List && map.isNotEmpty) {
        // If it's an array, get the first element
        userData = map[0];
        print("API returned array, using first element");
      } else if (map is Map) {
        // If it's already an object, use it directly
        userData = map;
        print("API returned object directly");
      } else {
        print("Unexpected API response format: $map");
        return;
      }

      // Debug: Print the userData structure
      print("UserData structure: $userData");
      print("UserData keys: ${userData.keys}");

      // Map user basic info (try both PascalCase and camelCase)
      userId = userData["UserId"] ?? userData["userId"];
      firstName = userData["FirstName"] ?? userData["firstName"];
      lastName = userData["LastName"] ?? userData["lastName"];
      profileImage = userData["Image"] ?? userData["image"] ?? userData["profileImage"];
      email = userData["Email"] ?? userData["email"];
      loginWith = userData["LoginWith"] ?? userData["loginWith"];

      // Map city/location info (try multiple possible field names)
      cityId = (userData["cityId"] ?? userData["CityId"])?.toString();
      cityName = userData["cityName"] ?? userData["CityName"];
      locationId = (userData["locationId"] ?? userData["LocationId"])?.toString();
      locationName = userData["locationName"] ?? userData["LocationName"];

      // Map phone number if available
      var phoneNum = userData["PhoneNumber"] ?? userData["phoneNumber"];
      var countryCode = userData["CountryCode"] ?? userData["countryCode"];
      var isoCode = userData["IsoCode"] ?? userData["isoCode"];

      if(phoneNum != null) {
        phoneNumber = PhoneNumber(
            phoneNumber: phoneNum,
            dialCode: countryCode,
            isoCode: isoCode
        );
      }

      // Debug logging
      print("UserModel created:");
      print("- UserId: $userId");
      print("- Name: $firstName $lastName");
      print("- Email: $email");
      print("- ProfileImage: $profileImage");
      print("- City: $cityName (ID: $cityId)");
      print("- Location: $locationName (ID: $locationId)");

    } catch (e) {
      print("Error creating UserModel: $e");
      print("Raw data: $map");
      print("Raw data type: ${map.runtimeType}");
    }
  }

  // Helper method to check if location data exists
  bool get hasLocationData =>
      cityName != null && cityName!.isNotEmpty &&
          locationName != null && locationName!.isNotEmpty;

  // Helper method to get formatted address
  String get formattedAddress {
    if (hasLocationData) {
      return "$cityName, $locationName";
    } else if (cityName != null && cityName!.isNotEmpty) {
      return cityName!;
    } else {
      return "";
    }
  }
}
