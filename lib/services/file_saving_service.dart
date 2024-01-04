import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path/path.dart' as p;
import 'package:com.relief.motivationalapp/models/journal_entry.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:com.relief.motivationalapp/models/quote.dart';
import 'package:com.relief.motivationalapp/pages/quote_page.dart';
import 'package:com.relief.motivationalapp/theme/theme_constants.dart';
import 'package:com.relief.motivationalapp/theme/theme_manager.dart';
import 'package:screenshot/screenshot.dart';


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
    final Directory dir = await getApplicationDocumentsDirectory();
    File imgPath = await File(p.join(dir.path, 'temp.png')).create();
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

// Future<void> saveJournalEntry(JournalEntry entry) async {
//
//   late File file;
//   late String filePath;
//
//   // prepare filename
//   String timeISOString = entry.dateTime!.toIso8601String();
//
//   // prepare data
//   String jsonString = jsonEncode({
//     'dateTime': timeISOString,
//     'title': entry.title,
//     'content': entry.content,
//   });
//
//   if (entry.filePath == null) {
//     String fileName = 'journal_$timeISOString';
//
//     // get the save directory
//     Directory appDir = await getApplicationDocumentsDirectory();
//     String saveDir = File(p.join(appDir.path, 'journal_entries')).path;
//
//     // create the save directory if it does not exist
//     Directory directory = await Directory(saveDir).create(recursive: true);
//     String filePath = p.join(appDir.path, 'journal_entries', fileName);
//     // write the string onto the file
//     file = File(filePath);
//     dev.log('created the directory: $directory');
//   } else {
//     filePath = entry.filePath!;
//     file = File(filePath);
//   }
//
//   await file
//       .writeAsString(jsonString)
//       .then((_) => dev.log('FSS: Journal entry written to file: $filePath'))
//       .catchError((error) => dev.log('Error writing to JSON file $error'));
// }

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