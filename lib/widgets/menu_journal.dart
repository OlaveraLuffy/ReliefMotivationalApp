import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:com.relief.motivationalapp/models/journal_entry.dart';
import 'package:com.relief.motivationalapp/services/journal_data_manager.dart';
import 'package:com.relief.motivationalapp/services/file_saving_service.dart';

class MenuJournal extends StatefulWidget {
  const MenuJournal({super.key});

  @override
  State<MenuJournal> createState() => _MenuJournalState();
}

class _MenuJournalState extends State<MenuJournal> {
  int masEntriesToDisplay = 3;
  List<JournalEntry> journalEntries = [];

  void updateJournalEntries() async {
    List<JournalEntry> allEntries =
        await JournalDataManager.getJournalEntries();
    setState(() {
      int lastItemIndex = allEntries.length > masEntriesToDisplay
          ? masEntriesToDisplay
          : allEntries.length;
      journalEntries = allEntries.sublist(0, lastItemIndex);
    });
  }

  @override
  void initState() {
    super.initState();
    updateJournalEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'GOT SOMETHING ON YOUR MIND?',
            style: Theme.of(context).textTheme.titleSmall,
            textAlign: TextAlign.left,
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                    bottom: 10.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('JOURNAL'),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorDark,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/create_journal',
                                    arguments: {'showMenuButton': false})
                                .then((value) => updateJournalEntries());
                          },
                          icon: const Icon(Icons.add),
                        ),
                      )
                    ],
                  ),
                ),
                Column(
                  children: journalEntries.map((JournalEntry entry) {
                    return Builder(
                        builder: (BuildContext context) => _Entry(
                              journal: entry,
                              updateEntries: updateJournalEntries,
                            ));
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Entry extends StatelessWidget {
  final JournalEntry journal;
  final Function updateEntries;

  const _Entry({required this.journal, required this.updateEntries});

  String extractReadableContent(List<dynamic> contentList) {
    String journalContent = '';
    for (dynamic contentItem in contentList) {
      if (contentItem is Map<String, dynamic> && contentItem.containsKey("insert")) {
        journalContent += contentItem["insert"].toString();
      }
    }
    return journalContent;
  }

  @override
  Widget build(BuildContext context) {
    // Decode the JSON-encoded content
    List<dynamic> decodedContent = json.decode(journal.content);
    String journalContent = extractReadableContent(decodedContent);

    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/create_journal',
                arguments: {'journalEntry': journal, 'showMenuButton': false})
            .then((value) => updateEntries());
      },
      child: Card(
        margin: const EdgeInsets.only(
          left: 10.0,
          right: 10.0,
          bottom: 6.0,
        ),
        color: Theme.of(context).canvasColor,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // DATE TEXT
              Text(
                convertISOTimeToReadable(journal.strDateTime),
                textAlign: TextAlign.left,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Theme.of(context).primaryColor),
              ),

              // TITLE TEXT
              Text(
                limitStringLength(str: journal.title, length: 10),
                textAlign: TextAlign.left,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: Theme.of(context).primaryColor),
              ),

              // CONTENT TEXT
              Text(
                limitStringLength(str: journalContent.trim(), length: 20),
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
