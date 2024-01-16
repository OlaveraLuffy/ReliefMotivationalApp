import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:com.relief.motivationalapp/models/journal_entry.dart';
import 'package:com.relief.motivationalapp/services/ads.dart';
import 'package:com.relief.motivationalapp/widgets/appbar.dart';
import 'package:com.relief.motivationalapp/services/journal_data_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:fleather/fleather.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:com.relief.motivationalapp/theme/theme_constants.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:developer' as dev;
import 'package:quill_delta/quill_delta.dart';
import 'dart:ffi';
import 'package:com.relief.motivationalapp/widgets/quote_category.dart';

import 'package:com.relief.motivationalapp/services/file_saving_service.dart';
import 'package:com.relief.motivationalapp/pages/journal_page.dart';

class CreateJournal extends StatefulWidget {
  const CreateJournal({super.key});

  @override
  State<CreateJournal> createState() => _CreateJournalState();
}

class _CreateJournalState extends State<CreateJournal> {
  late JournalEntry journalEntry;
  late TextEditingController _titleController;
  late FleatherController _controller;
  late FocusNode _focusNode;
  File ? _selectedImage;
  late Color _selectedBackgroundColor;
  late String _selectedImagePath;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _controller = FleatherController();
    _focusNode = FocusNode();
    journalEntry = JournalEntry();
    _selectedBackgroundColor = const Color(0xFF879d55);
    _selectedImagePath = '';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadEntry();
  }

  Future<void> saveEntryField(ParchmentDocument document) async {
    final content = json.encode(document.toDelta().toList());
    await JournalDataManager.saveEntry(JournalEntry(
      dateTime: journalEntry.dateTime,
      title: _titleController.text,
      content: content,
      filePath: journalEntry.filePath,
      backgroundColor: _selectedBackgroundColor.value,
      imagePath: _selectedImagePath,
    ));
    // show a snackbar upon successful save
    Future.delayed(Duration.zero, () {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Entry saved.')),
      );
    });
  }

  Future<void> loadEntry() async {
    final Map<String, dynamic>? arguments =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (arguments?['journalEntry'] != null) {
      journalEntry = arguments!['journalEntry'];
      _titleController.text = journalEntry.title;
      ParchmentDocument? document;
      document = ParchmentDocument.fromJson(json.decode(journalEntry.content));
      _controller = FleatherController(document: document);
      _selectedBackgroundColor = Color(journalEntry.backgroundColor);

      if (journalEntry.imagePath != null && journalEntry.imagePath!.isNotEmpty) {
        _selectedImage = File(journalEntry.imagePath!);
        _selectedImagePath = journalEntry.imagePath!;
      }

    } else {
      journalEntry = JournalEntry();
    }
  }

  Future<void> _pickImage() async {
    final returnedImage = await ImagePicker().pickImage(source: ImageSource.gallery); // You can also use ImageSource.camera
    setState(() {
      _selectedImage = File(returnedImage!.path); // _selectedImage actual output of selected image
      _selectedImagePath = returnedImage.path; // convert to String of returnedImage.path to be able to save
    });
  }

  Future<void> _showColorPickerDialog() async {
    Color? selectedColor = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Background Color'),
          content: SingleChildScrollView(
            child: MaterialPicker(
              pickerColor: _selectedBackgroundColor, //every click of color chosen
              onColorChanged: (Color color) {
                setState(() {
                  _selectedBackgroundColor = color; //set state to color chosen
                });
              },
              enableLabel: true,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); //accept or change color chosen once ok is clicked
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(const Color(0xFF879d55)),
              ),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    if (selectedColor != null) {
      setState(() {
        _selectedBackgroundColor = selectedColor;
      });
    }
  } // _showColorPickerDialog()

  Future<void> _openPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JournalPage(journalEntry: journalEntry),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ReliefAppBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // TITLE FIELD
                  TextField(
                    controller: _titleController,
                    maxLength: 24,
                    cursorColor: Theme.of(context).colorScheme.onPrimaryContainer,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.primaryContainer,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10.0),
                      hintText: 'Title',
                      hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer),
                    ),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer),
                  ),

                  const SizedBox(height: 10.0),

                  // JOURNAL FIELD
                  // Toolbar
                  Theme(
                    data: Theme.of(context).copyWith(
                        canvasColor: const Color(0xFF879d55),
                        primaryIconTheme: const IconThemeData(color: Colors.white), //used for toggled icons
                        iconTheme: const IconThemeData(color: Colors.black54, size: 100.0)), //used for not toggled icons

                    child: FleatherToolbar.basic(
                      controller: _controller,
                      hideDirection: true,
                      hideHorizontalRule: true,
                      hideLink: true,
                      hideQuote: true,
                      hideCodeBlock: true,
                      hideInlineCode: true,
                      hideIndentation: true,
                      hideUndoRedo: true,
                    ),
                  ),

                  FleatherField(
                    controller: _controller,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: _selectedBackgroundColor,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10.0),
                      hintText: 'How\'s your heart?',
                      hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer),
                    ),
                  ),

                  const SizedBox(height: 10),
                  _selectedImage != null
                      ? Image.file(_selectedImage!)
                      : const Text("Please select an image"),

                  const SizedBox(height: 10),

                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Center the row horizontally
                      children: [
                        FloatingActionButton(
                          heroTag: 'share',
                          onPressed: () async {
                            // Handle the 'openPage' button press
                            dev.log('pressed');
                            _openPage();
                          },
                          mini: true, // Set to true to make the button smaller
                          child: const Icon(Icons.share),
                        ),
                        const SizedBox(width: 16.0), // Add some spacing between the buttons
                        FloatingActionButton(
                          heroTag: 'saveToDevice',
                          onPressed: () {
                            // Handle the 'saveToDevice' button press
                            dev.log('pressed');

                          },
                          mini: true, // Set to true to make the button smaller
                          child: const Icon(Icons.download_for_offline),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 80,),
          AdService.bannerAd
        ],
      ),
      floatingActionButton: Stack(
        children: [
          // SAVE BUTTON
          Positioned(
            bottom: 50,
            right: 0.0,
            child: FloatingActionButton(
              heroTag: 'saveButton',
              onPressed: () async {
                await saveEntryField(_controller.document);
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Icon(Icons.save_as_sharp),
            ),
          ),
          // UPLOAD IMAGE BUTTON
          Positioned(
            bottom: 120,
            right: 0,
            child: FloatingActionButton(
              heroTag: 'uploadButton',
              onPressed: () {
                _pickImage();
              },
              child: const Icon(Icons.upload),
            ),
          ),
          // PICK BG COLOR BUTTON
          Positioned(
            bottom: 50,
            left: 35,
            child: FloatingActionButton(
              heroTag: 'bgColor',
              onPressed: () {
                _showColorPickerDialog();
              },
              child: const Icon(Icons.color_lens_outlined),
            ),
          ),
        ],
      ),
    );
  }
}


