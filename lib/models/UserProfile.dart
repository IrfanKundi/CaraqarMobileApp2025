class UserProfile {
  final int userId;
  final String? firstName;
  final String? lastName;
  final String? countryCode;
  final String? phoneNumber;
  final String? email;
  final String? image;
  final String? createdAt;
  final String? status;
  final bool? phoneNumberVerified;
  final bool? emailVerified;
  final bool? isCustomInfo;
  // New location fields added
  final int? cityId;
  final String? cityName;
  final int? locationId;
  final String? locationName;

  UserProfile({
    required this.userId,
    this.firstName,
    this.lastName,
    this.countryCode,
    this.phoneNumber,
    this.email,
    this.image,
    this.createdAt,
    this.status,
    this.phoneNumberVerified,
    this.emailVerified,
    this.isCustomInfo,
    // New location parameters added
    this.cityId,
    this.cityName,
    this.locationId,
    this.locationName,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['UserId'] ?? 0,
      firstName: json['FirstName'],
      lastName: json['LastName'],
      countryCode: json['CountryCode'],
      phoneNumber: json['PhoneNumber'],
      email: json['Email'],
      image: json['Image'],
      createdAt: json['CreatedAt'],
      status: json['Status'],
      phoneNumberVerified: json['PhoneNumberVerified'] ?? false,
      emailVerified: json['EmailVerified'] ?? false,
      isCustomInfo: json['IsCustomInfo'] ?? false,
      // New location fields from JSON
      cityId: json['cityId'],
      cityName: json['cityName'],
      locationId: json['locationId'],
      locationName: json['locationName'],
    );
  }

  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    } else if (firstName != null) {
      return firstName!;
    } else {
      return 'Unknown User';
    }
  }

  String get memberSinceYear {
    if (createdAt != null) {
      try {
        DateTime date = DateTime.parse(createdAt!);
        return date.year.toString();
      } catch (e) {
        return '2025';
      }
    }
    return '2025';
  }

  String get fullPhoneNumber {
    if (countryCode != null && phoneNumber != null) {
      return '$countryCode$phoneNumber';
    }
    return phoneNumber ?? '';
  }

  // New getter for dynamic location display
  String get locationDisplay {
    List<String> locationParts = [];

    if (locationName != null && locationName!.isNotEmpty) {
      locationParts.add(locationName!);
    }

    if (cityName != null && cityName!.isNotEmpty) {
      locationParts.add(cityName!);
    }

    // Add "Pakistan" as default country if no location data
    if (locationParts.isEmpty) {
      return "Pakistan";
    }

    // Add Pakistan if not already included
    if (!locationParts.any((part) => part.toLowerCase().contains('pakistan'))) {
      locationParts.add("Pakistan");
    }

    return locationParts.join(", ");
  }
}