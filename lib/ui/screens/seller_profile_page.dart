import 'package:careqar/constants/colors.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SellerProfileController extends GetxController {
  // Sample data - replace with actual data models
  var sellerName = "Zeeshan Ansari".obs;
  var sellerLocation = "Lahore: 597-A Maulana Shoukat Ali Road Faisal Town Lahore".obs;
  var profileImage = "".obs; // Add your image URL here

  // Sample property data
  var properties = <PropertyModel>[
    PropertyModel(
      id: 1,
      title: "BMW iX3 M Sport",
      year: "2020",
      type: "Hybrid",
      location: "Punjab",
      distance: "27,000 km",
      timeAgo: "20 min ago",
      price: "PKR 1.95 Cr",
      imageCount: 18,
      isFavorite: false,
      image: "", // Add your image URL here
    ),
  ].obs;

  void toggleFavorite(int propertyId) {
    int index = properties.indexWhere((p) => p.id == propertyId);
    if (index != -1) {
      properties[index].isFavorite = !properties[index].isFavorite;
      properties.refresh();
    }
  }

  void makeCall() {
    // Implement call functionality
    Get.snackbar("Call", "Calling seller...");
  }

  void sendMessage() {
    // Implement message functionality
    Get.snackbar("Message", "Opening chat...");
  }
}

class PropertyModel {
  final int id;
  final String title;
  final String year;
  final String type;
  final String location;
  final String distance;
  final String timeAgo;
  final String price;
  final int imageCount;
  bool isFavorite;
  final String image;

  PropertyModel({
    required this.id,
    required this.title,
    required this.year,
    required this.type,
    required this.location,
    required this.distance,
    required this.timeAgo,
    required this.price,
    required this.imageCount,
    required this.isFavorite,
    required this.image,
  });
}

class SellerProfilePage extends StatelessWidget {
  final SellerProfileController controller = Get.put(SellerProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, title: "Seller Profile"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 10.h),
              // Profile Section - Centered and Bigger
              Column(
                children: [
                  // Profile Image - Bigger using ImageWidget like your reference
                  ImageWidget(
                    controller.profileImage.value.isEmpty
                        ? "assets/images/profile2.jpg"
                        : controller.profileImage.value,
                    width: 120.w,
                    height: 120.w,
                    isCircular: true,
                    isLocalImage: controller.profileImage.value.isEmpty,
                    fit: BoxFit.cover,
                  ),

                  SizedBox(height: 10.h),

                  // Seller Name - Bigger font
                  Obx(() => Text(
                    controller.sellerName.value,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: kBlackColor,
                    ),
                  )),

                  SizedBox(height: 10.h),

                  // Location
                  Obx(() => Text(
                    controller.sellerLocation.value,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.black87,
                    ),
                  )),

                  SizedBox(height: 10.h),

                  // Phone & Email Icons + Report - Like your reference code
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Phone + Email
                      Row(
                        children: [
                          GestureDetector(
                            onTap: controller.makeCall,
                            child: Icon(
                              Icons.phone_iphone,
                              size: 20.sp,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          GestureDetector(
                            onTap: controller.sendMessage,
                            child: Icon(
                              Icons.email_outlined,
                              size:20.sp,
                            ),
                          ),
                          SizedBox(height: 16.h),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10.w),
              // Divider
              Container(
                height: 1.h,
                color: Colors.black54
              ),
              // Posted By Section
              SizedBox(height: 10.w),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Obx(() => Text(
                      "Posted By ${controller.sellerName.value}",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: kBlackColor,
                      ),
                    )),

                    SizedBox(height: 16.h),

                    // Properties placeholder - removed PropertyCard for now
                    SizedBox(
                      height: 200.h,
                      child: Center(
                        child: Text(
                          "Ads will be displayed here",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PropertyCard extends StatelessWidget {
  final PropertyModel property;
  final VoidCallback onFavoritePressed;

  const PropertyCard({
    Key? key,
    required this.property,
    required this.onFavoritePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Property Image
          Container(
            width: 120.w,
            height: 120.w,
            margin: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: Colors.grey.shade200,
              image: property.image.isNotEmpty
                  ? DecorationImage(
                image: NetworkImage(property.image),
                fit: BoxFit.cover,
              )
                  : null,
            ),
            child: Stack(
              children: [
                if (property.image.isEmpty)
                  Center(
                    child: Icon(
                      Icons.car_rental,
                      size: 40.sp,
                      color: Colors.grey,
                    ),
                  ),
                // Image Count
                Positioned(
                  bottom: 8.h,
                  left: 8.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 12.sp,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          "${property.imageCount}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Property Details
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Favorite
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          property.title,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: kBlackColor,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: onFavoritePressed,
                        child: Icon(
                          property.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: property.isFavorite ? Colors.red : Colors.grey,
                          size: 24.sp,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h),

                  // Year and Type
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(4.r),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Text(
                          property.year,
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(4.r),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Text(
                          property.type,
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h),

                  // Location
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14.sp,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        property.location,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Icon(
                        Icons.speed,
                        size: 14.sp,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        property.distance,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h),

                  // Time and Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        property.timeAgo,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      Text(
                        property.price,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),

                  // View Count
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.only(top: 4.h),
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.visibility,
                            size: 12.sp,
                            color: Colors.grey.shade600,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            "546",
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
