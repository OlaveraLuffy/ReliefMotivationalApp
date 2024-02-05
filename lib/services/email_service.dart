import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'dart:developer' as dev;

class ExternalUrlService {
  static const String supportEmail = 'diarynigracia@gmail.com';
  static const String emailSubject = 'Relief Problem Report';

  static void sendEmail(String content) async {
    final Email email = Email(
      body: content,
      subject: emailSubject,
      recipients: [supportEmail],
      isHTML: true,
    );
    String platformResponse;
    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      dev.log(error.toString());
      platformResponse = error.toString();
    }
  }

  static void openAppStore() async {
    final Uri appStoreUrl = Uri.parse('https://play.google.com/store/apps/details?id=com.relief.motivationalapp');
    if (await canLaunchUrl(appStoreUrl)) {
      await launchUrl(
        appStoreUrl,
        mode: LaunchMode.externalApplication
      );
    } else {
      throw 'Could not launch app store';
    }
  }
}