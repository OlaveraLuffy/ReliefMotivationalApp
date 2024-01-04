import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:com.relief.motivationalapp/models/journal_entry.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart';

class JournalDataManager {

  static Future<void> init() async {
    getJournalEntries();
  }

  static Future<String> generateEncryptionKey() async {
    const secureStorage = FlutterSecureStorage();
    // generate and store secret key using the keystore system
    final random = Random.secure();
    final keyBytes = List<int>.generate(32, (index) => random.nextInt(256));
    final key = base64Encode(keyBytes);
    await secureStorage.write(key: 'encryption_key', value: key);
    return key;
  }

  static Future<String> retrieveEncryptionKey() async {
    const secureStorage = FlutterSecureStorage();
    String key = await secureStorage.read(key: 'encryption_key') ?? await generateEncryptionKey();
    return key;
  }

  static Future<void> saveEntry(JournalEntry entry) async {

    String timeISOString = entry.dateTime!.toIso8601String();

    // get encryption key
    final String encryptionKey = await retrieveEncryptionKey();
    final Uint8List keyBytes = base64.decode(encryptionKey);

    // prepare data
    String jsonString = jsonEncode({
      'dateTime': timeISOString,
      'title': entry.title,
      'content': entry.content,
      'backgroundColor': entry.backgroundColor,
    });

    // encrypt data
    final IV iv = IV.fromLength(16);
    final Encrypter encrypter = Encrypter(AES(Key(keyBytes)));
    final Encrypted encryptedJson = encrypter.encrypt(jsonString, iv: iv);

    // generate filepath
    late final File file;
    late final String filePath;
    if (entry.filePath == null) {
      String fileName = 'journal_$timeISOString';

      // get the save directory
      Directory appDir = await getApplicationDocumentsDirectory();
      String saveDir = File(p.join(appDir.path, 'journal_entries')).path;

      // create the save directory if it does not exist
      Directory directory = await Directory(saveDir).create(recursive: true);
      filePath = p.join(appDir.path, 'journal_entries', fileName);

      dev.log('created the directory: $directory');
    } else {
      filePath = entry.filePath!; // get the filePath from the JournalEntry
    }

    file = File(filePath);
    await file
        .writeAsBytes(encryptedJson.bytes)
        .then((_) => dev.log('JDG: Journal entry written to file: $filePath'))
        .catchError((error) => dev.log('JDG: Error writing to JSON file $error'));
  }

  static Future<String> loadEntry(String filePath) async {
    // get key
    final String key = await retrieveEncryptionKey();
    final keyBytes = base64.decode(key);

    // read file
    final File file = File(filePath);
    final Uint8List encryptedJson = await file.readAsBytes();

    // decrypt file
    final IV iv = IV.fromLength(16);
    final Encrypter encrypter = Encrypter(AES(Key(keyBytes)));
    final String decryptedJson = encrypter.decrypt(Encrypted(encryptedJson), iv: iv);
    return decryptedJson;

  }

  static Future<List<JournalEntry>> getJournalEntries() async {

    // get the save directory
    Directory appDir = await getApplicationDocumentsDirectory();
    String journalDir = File(p.join(appDir.path, 'journal_entries')).path;
    Directory directory = Directory(journalDir);

    List<String> filePaths = [];

    if (directory.existsSync()) {
      List<FileSystemEntity> files = directory.listSync();
      files
          .sort((a, b) => a.statSync().changed.compareTo(b.statSync().changed));

      filePaths = files.whereType<File>().map((file) => file.path).toList();
    } else {
      dev.log('Journal directory not found');
    }

    // load journal entries
    List<JournalEntry> loadJournalEntries = [];
    for (String filePath in filePaths) {
      try {
        String jsonString = await loadEntry(filePath);

        Map<String, dynamic> jsonData = jsonDecode(jsonString);

        loadJournalEntries.add(JournalEntry(
            title: jsonData['title'],
            content: jsonData['content'],
            dateTime: DateTime.parse(jsonData['dateTime']),
            filePath: filePath,
            backgroundColor: jsonData['backgroundColor'],
        ));
      } catch (e) {
        dev.log('Error reading JSON file: $e');
      }
    }

    // sort by dateTime
    loadJournalEntries.sort((JournalEntry a, JournalEntry b) {
      DateTime firstDateTime = a.dateTime as DateTime;
      DateTime secondDateTime = b.dateTime as DateTime;
      return secondDateTime.compareTo(firstDateTime);
    });

    return loadJournalEntries;
  }

  // delete entries
  static Future<void> deleteEntry(String? filePath) async {
    if (filePath == null) {
      return;
    }

    File file = File(filePath);

    if (file.existsSync()) {
      file.deleteSync();
      dev.log('DELETED journal entry $filePath');
    } else {
      dev.log('DOES NOT EXIST journal entry $filePath');
    }
  }
}
