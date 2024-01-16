import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:com.relief.motivationalapp/models/journal_entry.dart';
import 'package:fleather/fleather.dart';
import 'package:com.relief.motivationalapp/services/file_saving_service.dart';

class JournalPage extends StatelessWidget {
  final JournalEntry journalEntry;

  const JournalPage({Key? key, required this.journalEntry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share Journal'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Display title
              Text(
                journalEntry.title,
                style: const TextStyle(
                  fontSize: 24.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10.0),

              // Display rich text
              RichTextField(
                controller: FleatherController(
                  document: ParchmentDocument.fromJson(json.decode(journalEntry.content)),
                ),
                backgroundColor: Color(journalEntry.backgroundColor),
              ),

              const SizedBox(height: 10.0),

              // Display image if available
              if (journalEntry.imagePath != null && journalEntry.imagePath!.isNotEmpty)
                Image.file(File(journalEntry.imagePath!)),

              const SizedBox(height: 10.0),

              TextButton(
                  onPressed: () async {
                    await saveAndShareJournal(journalEntry);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(const Color(0xFF879d55)),
                  ),
                  child: const Text(
                    'Share',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RichTextField extends StatelessWidget {
  final FleatherController controller;
  final Color backgroundColor;

  const RichTextField({Key? key, required this.controller, required this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FleatherField(
      controller: controller,
      readOnly: true,
      showCursor: false,
      enableInteractiveSelection: false,
      decoration: InputDecoration(
        filled: true,
        fillColor: backgroundColor,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 15.0, vertical: 10.0
        ),
        hintText: 'How\'s your heart?',
        hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Theme.of(context).colorScheme.onPrimaryContainer
        ),
      ),
    );
  }
}

