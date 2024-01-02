import 'package:url_launcher/url_launcher.dart';

class ExternalUrlService {
  static const String supportEmail = 'diarynigracia@gmail.com';
  static const String emailSubject = 'Relief Problem Report';

  static void sendEmail(String content) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: supportEmail,
      queryParameters: {'subject': emailSubject, 'body': content},
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      throw 'Could not launch email client';
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