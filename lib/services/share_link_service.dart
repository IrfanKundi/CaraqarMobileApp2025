import 'dart:io';

import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ShareService extends GetxService {

  // Generate share links using your website
  String generateShareLink({
    required String type, // 'car', 'bike', 'property'
    required String id,
  }) {
    return 'https://caraqaar.com/share.html?${type}Id=$id';
  }

  // Email specific sharing
  Future<void> shareToEmail({
    required String type,
    required String id,
    required String email,
    required String? agentName,
    required String title,
    required String? description,
  }) async {
    // Generate the share URL
    String shareUrl = generateShareLink(type: type, id: id);

    // Create the email message
    String message = "Hello,\n$agentName\n"
        "I would like to get more information about this ad you posted on.\n"
        "$shareUrl";

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
    required String? title,
    required String? description,
  }) async {
    // Generate the share URL
    String shareUrl = generateShareLink(type: type, id: id);

    // Create the WhatsApp message
    String message = Uri.encodeFull(
        "Hello,\n$agentName\nI would like to get more information about this ad you posted on.\n$shareUrl"
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
    String? title,
    String? description,
  }) async {
    final String shareUrl = generateShareLink(type: type, id: id);

    final String shareTitle = title ?? 'Check out this $type on Caraqaar';
    final String shareText = description ?? 'View this amazing $type listing on Caraqaar app!\n\n$shareUrl';

    await Share.share(
      shareText,
      subject: shareTitle,
    );
  }
}