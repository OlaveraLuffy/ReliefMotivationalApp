import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:com.relief.motivationalapp/models/journal_entry.dart';
import 'package:fleather/fleather.dart';
import 'package:com.relief.motivationalapp/services/file_saving_service.dart';
import 'package:intl/intl.dart';

class JournalPage extends StatefulWidget {
  final JournalEntry journalEntry;
  final bool isScreenshot;

  const JournalPage({
    super.key,
    required this.journalEntry,
    this.isScreenshot = false,
  });

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  late JournalEntry journalEntry;
  String currentDate = DateFormat.yMd().format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
            'assets/images/icons/relief.png',
            height: 40.0),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Display title
              Text(
                widget.journalEntry.title,
                style: const TextStyle(
                  fontSize: 24.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Conditionally display rich text only when there is no image
              if (widget.journalEntry.imagePath == null ||
                  widget.journalEntry.imagePath!.isEmpty)
              RichTextField(
                controller: FleatherController(
                  document: ParchmentDocument.fromJson(
                    json.decode(widget.journalEntry.content),
                  ),
                ),
                backgroundColor: Color(widget.journalEntry.backgroundColor),
              ),
              const SizedBox(height: 10.0),
              // IF IMAGE IS AVAILABLE DISPLAY THIS
              if (widget.journalEntry.imagePath != null &&
                  widget.journalEntry.imagePath!.isNotEmpty)
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Image.file(File(widget.journalEntry.imagePath!)),
                    // Display rich text
                    Positioned.fill(
                      child: RichTextField(
                        controller: FleatherController(
                          document: ParchmentDocument.fromJson(
                              json.decode(widget.journalEntry.content)),
                        ),
                        backgroundColor:
                        Color(widget.journalEntry.backgroundColor)
                            .withAlpha(0),
                      ),
                    ),
                    // Conditionally display text for screenshot mode
                    if (widget.isScreenshot)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Relief Motivational App\nby diarynigracia\n$currentDate',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.normal,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                  ],
                ),
              // Conditionally display the Share button
              if (!widget.isScreenshot)
                TextButton(
                  onPressed: () async {
                    await saveAndShareJournal(widget.journalEntry);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(const Color(0xFF879d55)),
                  ),
                  child: const Text(
                    'Share',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              if (widget.journalEntry.imagePath == null ||
                  widget.journalEntry.imagePath!.isEmpty)
              if (widget.isScreenshot)
                SizedBox(
                  height: 105.0,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Relief Motivational App\nby diarynigracia\n$currentDate',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              const SizedBox(height: 10.0),
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
        border: InputBorder.none,
        filled: true,
        fillColor: backgroundColor,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 15.0, vertical: 10.0
        ),
        hintText: 'Empty',
        hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Theme.of(context).colorScheme.onPrimaryContainer
        ),
      ),
    );
  }
}

