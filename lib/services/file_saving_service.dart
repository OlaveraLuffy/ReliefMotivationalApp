import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:com.relief.motivationalapp/models/journal_entry.dart';
import 'package:com.relief.motivationalapp/models/quote.dart';
import 'package:com.relief.motivationalapp/pages/quote_page.dart';
import 'package:com.relief.motivationalapp/theme/theme_constants.dart';
import 'package:com.relief.motivationalapp/theme/theme_manager.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:intl/intl.dart';

import 'package:com.relief.motivationalapp/pages/journal_page.dart';

Future<Uint8List> _screenshot(Quote quote) async {
  ScreenshotController ssController = ScreenshotController();
  ThemeManager themeManager = ThemeManager();
  Uint8List capturedImage = await ssController.captureFromWidget(MediaQuery(
      data: const MediaQueryData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: themeManager.themeMode,
        home: QuotePage(
          isScreenshot: true,
          quote: quote,
        ),
      )));
  return capturedImage;
}

Future<Map> saveQuoteImage(Quote quote) async {
  Uint8List imgBytes = await _screenshot(quote);

  await Permission.photos.request();
  String time = DateTime.now().toIso8601String();
  String fileName = 'screenshot_$time';
  dynamic result = await ImageGallerySaver.saveImage(imgBytes, name: fileName);

  if (result['isSuccess']) {
    return {'fileName': fileName, 'success': true};
  } else {
    return {'success': false};
  }
}

Future<bool> saveAndShareQuote(Quote quote) async {
  _screenshot(quote).then((Uint8List imgBytes) async {

    // Generate a unique filename with the current date and time
    String formattedDate = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    String fileName = 'quote_$formattedDate.png';

    final Directory dir = await getApplicationDocumentsDirectory();
    File imgPath = await File(p.join(dir.path, fileName)).create();
    await imgPath.writeAsBytes(imgBytes);

    Share.shareXFiles([XFile(imgPath.path)]).then((ShareResult result) {
      if (result.status == ShareResultStatus.success) {
        return true;
      } else {
        return false;
      }
    });
  });
  return false;
}

////////////////// SCREEN SHOT JOURNAL ///////////////////////
Future<Uint8List> _screenshotJournal(JournalEntry journalEntry) async {
  ScreenshotController ssController = ScreenshotController();
  ThemeManager themeManager = ThemeManager();
  Uint8List capturedImage = await ssController.captureFromWidget(MediaQuery(
    data: const MediaQueryData(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeManager.themeMode,
      home: JournalPage(isScreenshot: true, journalEntry: journalEntry),
    ),
  ));
  return capturedImage;
}

////////////////// SAVE JOURNAL IMAGE ///////////////////////
Future<Map> saveJournalImage(JournalEntry journalEntry) async {
  Uint8List imgBytes = await _screenshotJournal(journalEntry);

  await Permission.photos.request();
  String time = DateTime.now().toIso8601String();
  String fileName = 'journal_screenshot_$time';
  dynamic result = await ImageGallerySaver.saveImage(imgBytes, name: fileName);

  if (result['isSuccess']) {
    return {'fileName': fileName, 'success': true};
  } else {
    return {'success': false};
  }
}

////////////////// SAVE AND SHARE JOURNAL ///////////////////////
Future<bool> saveAndShareJournal(JournalEntry journalEntry) async {
  _screenshotJournal(journalEntry).then((Uint8List imgBytes) async {
    String formattedDate = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    String fileName = 'journal_$formattedDate.png';

    final Directory dir = await getApplicationDocumentsDirectory();
    File imgPath = await File(p.join(dir.path, fileName)).create();
    await imgPath.writeAsBytes(imgBytes);

    Share.shareXFiles([XFile(imgPath.path)]).then((ShareResult result) {
      if (result.status == ShareResultStatus.success) {
        return true;
      } else {
        return false;
      }
    });
  });
  return false;
}

void showAlert(BuildContext context, String msg) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(msg),
      ));
}

String limitStringLength({required String str, int length=100}) {
  if (str.length > length) {
    return '${str.substring(0, length-3)}...';
  } else {
    return str;
  }
}

String convertISOTimeToReadable(String strDateTime) {
  DateTime isoTime = DateTime.parse(strDateTime);
  return '${isoTime.day}/${isoTime.month}/${isoTime.year}';
}

dynamic getRandomItem(List<dynamic> list) {
  if (list.isEmpty) {
    return null;
  }
  Random random = Random();
  int randomIndex = random.nextInt(list.length);

  return list[randomIndex];
}