import 'dart:io';

import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ShareService extends GetxService {

  // Generate share links with detailed information
  String generateShareLink({
    required String type, // 'car', 'bike', 'property', 'company'
    required String id,
    required String title,
    required String price,
    String? location, // optional location info
    String? appName = "CarAqaar",
    String? companyType, // For company sharing - 'Real State', 'Car', 'Bike', 'Number Plate'
  }) {
    String url;

    if (type == 'company') {
        String typeParam = (companyType ?? 'Real State').replaceAll(' ', '_');
        url = 'https://caraqaar.com/share.html?companyId=$id&type=$typeParam';
    } else {
      url = 'https://caraqaar.com/share.html?${type}Id=$id';
    }

    // Format the price with commas and remove decimals
    String formattedPrice = formatPrice(price);

    String shareText = '$title\n$formattedPrice';
    if (location != null && location.isNotEmpty) {
      shareText += '\n$location';
    }
    shareText += '\n$url\n\nShared via $appName.com';
    return shareText;
  }

  String formatPrice(String price) {
    try {
      double priceDouble = double.parse(price);
      int priceInt = priceDouble.toInt();

      if (priceInt == 0) {
        return 'Call for price';
      }

      final formatter = NumberFormat('#,###');
      return 'PKR ${formatter.format(priceInt)}';
    } catch (e) {
      return price; // Fallback if parsing fails
    }
  }

  // Company specific sharing
  Future<void> shareCompany({
    required String companyId,
    required String companyName,
    required String companyType, // 'Real State', 'Car', 'Bike', 'Number Plate'
    required String totalAds,
    String? description,
    String? location,
  }) async {
    // Generate the detailed share text for company
    final String shareText = generateShareLink(
        type: 'company',
        id: companyId,
        title: companyName,
        price: '$totalAds Ads Available',
        location: location,
        companyType: companyType
    );

    await Share.share(
      shareText,
      subject: companyName,
    );
  }

  // Email specific sharing for company
  Future<void> shareCompanyToEmail({
    required String companyId,
    required String email,
    required String companyName,
    required String companyType,
    required String totalAds,
    required String? description,
    String? location,
  }) async {
    // Generate the detailed share text
    String shareText = generateShareLink(
        type: 'company',
        id: companyId,
        title: companyName,
        price: '$totalAds Ads Available',
        location: location,
        companyType: companyType
    );

    // Create the email message
    String message = "Hello,\n"
        "I would like to get more information about this company.\n\n"
        "$shareText";

    final Email emailToSend = Email(
      body: message,
      subject: companyName,
      recipients: [email],
      isHTML: false,
    );

    await FlutterEmailSender.send(emailToSend);
  }

  // WhatsApp specific sharing for company
  Future<void> shareCompanyToWhatsApp({
    required String companyId,
    required String? phoneNumber,
    required String companyName,
    required String companyType,
    required String totalAds,
    required String? description,
    String? location,
  }) async {
    // Generate the detailed share text
    String shareText = generateShareLink(
        type: 'company',
        id: companyId,
        title: companyName,
        price: '$totalAds Ads Available',
        location: location,
        companyType: companyType
    );

    // Create the WhatsApp message
    String message = Uri.encodeFull(
        "Hello,\nI would like to get more information about this company.\n\n$shareText"
    );

    String url;
    if (Platform.isIOS) {
      url = "https://wa.me/$phoneNumber?text=$message";
    } else {
      url = "whatsapp://send?phone=$phoneNumber&text=$message";
    }

    try {
      await launchUrl(Uri.parse(url));
    } catch (e) {
      throw Exception("Could not launch WhatsApp");
    }
  }

  // Email specific sharing
  Future<void> shareToEmail({
    required String type,
    required String id,
    required String email,
    required String? agentName,
    required String title,
    required String price,
    required String? description,
    String? location,
  }) async {
    // Generate the detailed share text
    String shareText = generateShareLink(
        type: type,
        id: id,
        title: title,
        price: price,
        location: location
    );

    // Create the email message
    String message = "Hello,\n$agentName\n"
        "I would like to get more information about this ad you posted on.\n\n"
        "$shareText";

    final Email emailToSend = Email(
      body: message,
      subject: title,
      recipients: [email],
      isHTML: false,
    );

    await FlutterEmailSender.send(emailToSend);
  }

  // WhatsApp specific sharing
  Future<void> shareToWhatsApp({
    required String type,
    required String id,
    required String? phoneNumber,
    required String? agentName,
    required String title,
    required String price,
    required String? description,
    String? location,
  }) async {
    // Generate the detailed share text
    String shareText = generateShareLink(
        type: type,
        id: id,
        title: title,
        price: price,
        location: location
    );

    // Create the WhatsApp message
    String message = Uri.encodeFull(
        "Hello,\n$agentName\nI would like to get more information about this ad you posted on.\n\n$shareText"
    );

    String url;
    if (Platform.isIOS) {
      url = "https://wa.me/$phoneNumber?text=$message";
    } else {
      url = "whatsapp://send?phone=$phoneNumber&text=$message";
    }

    try {
      await launchUrl(Uri.parse(url));
    } catch (e) {
      throw Exception("Could not launch WhatsApp");
    }
  }

  // General sharing
  Future<void> shareItem({
    required String type,
    required String id,
    required String title,
    required String price,
    String? description,
    String? location,
  }) async {
    // Generate the detailed share text
    final String shareText = generateShareLink(
        type: type,
        id: id,
        title: title,
        price: price,
        location: location
    );

    await Share.share(
      shareText,
      subject: title,
    );
  }

  String generateSimpleShareLink({
    required String type,
    required String id,
    String? companyType,
  }) {
    if (type == 'company') {
      return 'https://caraqaar.com/share.html?companyId=$id&type=${Uri.encodeComponent(companyType ?? 'Real State')}';
    }
    return 'https://caraqaar.com/share.html?${type}Id=$id';
  }
}