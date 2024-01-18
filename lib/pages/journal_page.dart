import 'dart:convert';
import 'dart:io';
import 'package:com.relief.motivationalapp/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:com.relief.motivationalapp/models/journal_entry.dart';
import 'package:fleather/fleather.dart';
import 'package:com.relief.motivationalapp/services/file_saving_service.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReliefAppBar(isScreenshot: widget.isScreenshot),
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

              const SizedBox(height: 10.0),

              // Display rich text
              RichTextField(
                controller: FleatherController(
                  document: ParchmentDocument.fromJson(json.decode(widget.journalEntry.content)),
                ),
                backgroundColor: Color(widget.journalEntry.backgroundColor),
              ),

              const SizedBox(height: 10.0),

              // Display image if available
              if (widget.journalEntry.imagePath != null &&
                  widget.journalEntry.imagePath!.isNotEmpty)
                Image.file(File(widget.journalEntry.imagePath!)),

              const SizedBox(height: 10.0),


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
        hintText: 'Empty',
        hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Theme.of(context).colorScheme.onPrimaryContainer
        ),
      ),
    );
  }
}

