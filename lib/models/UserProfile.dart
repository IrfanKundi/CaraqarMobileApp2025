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
}