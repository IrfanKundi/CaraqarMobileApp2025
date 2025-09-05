import 'package:careqar/ui/screens/vehicle/vehicle_home_screen.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/icon_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../constants/colors.dart';
import '../../controllers/seller_profile_controller.dart';

class SellerProfilePage extends StatelessWidget {
  const SellerProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final SellerProfileController controller = Get.put(SellerProfileController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context, title: "Seller Profile"),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.error.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64.sp,
                  color: Colors.red,
                ),
                SizedBox(height: 16.h),
                Text(
                  controller.error.value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () => controller.refreshProfile(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.userProfile.value == null) {
          return const Center(
            child: Text('No profile data available'),
          );
        }

        final profile = controller.userProfile.value!;

        return RefreshIndicator(
          onRefresh: () => controller.refreshProfile(),
          child: Column(
            children: [
              // Profile Header Section
              Container(
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  children: [
                    SizedBox(height: 10.h),

                    // Profile Image - Much smaller size
                    Container(
                      width: 100.w,
                      height: 100.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: profile.image != null && profile.image!.isNotEmpty
                            ? DecorationImage(
                          image: profile.image != null && profile.image!.isNotEmpty
                              ? (profile.image!.startsWith('assets/')
                              ? AssetImage(profile.image!) as ImageProvider
                              : NetworkImage(profile.image!))
                              : const AssetImage("assets/images/profile2.jpg") as ImageProvider,
                          fit: BoxFit.cover,
                        )
                            : const DecorationImage(
                          image: AssetImage("assets/images/profile2.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    SizedBox(height: 15.h),

                    // Name with verification badge and action buttons row
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        children: [
                          // Left side - Name and badge
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        profile.fullName,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(width: 6.w),
                                    if (profile.userId != 0 && (profile.phoneNumberVerified == true || profile.emailVerified == true))
                                      Container(
                                        width: 16.w,
                                        height: 16.w,
                                        decoration: const BoxDecoration(
                                          color: Colors.green,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 10.sp,
                                        ),
                                      ),
                                    if (profile.userId == 0)
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                                        decoration: BoxDecoration(
                                          color: Colors.orange.shade100,
                                          borderRadius: BorderRadius.circular(8.r),
                                        ),
                                        child: Text(
                                          'Guest',
                                          style: TextStyle(
                                            fontSize: 8.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.orange.shade700,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  "Lahore, Pakistan", // You can make this dynamic if you have location data
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Right side - Action buttons
                          Row(
                            children: [
                              // Call button
                              GestureDetector(
                                onTap: () => controller.makeCall(),
                                child: Container(
                                  width: 30.w,
                                  height: 30.w,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.phone,
                                    size: 16.sp,
                                    color: Colors.black,
                                  ),
                                ),
                              ),

                              SizedBox(width: 10.w),

                              // WhatsApp button
                              GestureDetector(
                                onTap: () => controller.sendWhatsAppMessage(),
                                child: Container(
                                  width: 30.w,
                                  height: 30.w,
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.message,
                                    size: 16.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // Member Since area has background color
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: Row(
                        children: [
                          // Member Since
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  width: 35.w,
                                  height: 35.w,
                                  padding: EdgeInsets.all(6.w),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE3F2FD),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Icon(
                                    Icons.calendar_month,
                                    color: const Color(0xFF1976D2),
                                    size: 18.sp,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Member Since",
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      profile.memberSinceYear,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Vertical divider
                          Container(
                            height: 35.h,
                            width: 1.w,
                            color: Colors.grey.shade300,
                            margin: EdgeInsets.symmetric(horizontal: 15.w),
                          ),

                          // Published Ads
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  width: 35.w,
                                  height: 35.w,
                                  padding: EdgeInsets.all(6.w),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE3F2FD),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Icon(
                                    Icons.campaign,
                                    color: const Color(0xFF1976D2),
                                    size: 18.sp,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Published Ads",
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      controller.publishedAdsCount.value.toString(),
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 5.h),

                    // View toggle buttons
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        children: [
                          Text(
                            "Total ${controller.publishedAdsCount.value.toString()} ads",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const Spacer(),
                      IconButtonWidget(
                        color: kAccentColor,
                        width: 12,
                        onPressed: () {
                          controller.isGridView.value = !controller.isGridView.value;
                        },
                        icon: controller.isGridView.value
                            ? FontAwesomeIcons.list
                            : FontAwesomeIcons.grip,
                      ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Cars List Section
              Expanded(
                child: controller.isLoadingCars.value
                    ? const Center(child: CircularProgressIndicator())
                    : controller.carError.value.isNotEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48.sp,
                        color: Colors.red,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        controller.carError.value,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
                    : controller.cars.value.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.car_rental,
                        size: 48.sp,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "No ads found for this seller",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
                    : Column(
                  children: [
                    Expanded(
                      child: controller.isGridView.value
                          ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: GridView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: controller.cars.value.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent: 310.h,
                            crossAxisSpacing: 0.w,
                            mainAxisSpacing: 0.w,
                          ),
                          itemBuilder: (context, index) {
                            var item = controller.cars.value[index];
                            return CarItem(
                              item: item,
                              isGridView: true,
                            );
                          },
                        ),
                      )
                          : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: controller.cars.value.length,
                        itemBuilder: (context, index) {
                          var item = controller.cars.value[index];
                          return CarItem(
                            item: item,
                            isGridView: false,
                          );
                        },
                      ),
                    ),
                    if (controller.isLoadingMore.value)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: const CircularProgressIndicator(),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
