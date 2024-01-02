import 'package:flutter/material.dart';
import 'package:com.relief.motivationalapp/models/journal_entry.dart';
import 'package:com.relief.motivationalapp/services/ads.dart';
import 'package:com.relief.motivationalapp/services/journal_data_manager.dart';
import 'package:com.relief.motivationalapp/services/file_saving_service.dart';
import 'package:com.relief.motivationalapp/widgets/appbar.dart';

class Journal extends StatefulWidget {
  const Journal({super.key});

  @override
  State<Journal> createState() => _JournalState();
}

class _JournalState extends State<Journal> {
  List<JournalEntry> journalEntries = [];

  void updateJournalEntries() async {
    journalEntries = await JournalDataManager.getJournalEntries();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    updateJournalEntries();
    return Scaffold(
      appBar: const ReliefAppBar(),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
            child: Builder(builder: (context) {
              if (journalEntries.isNotEmpty) {
                return ListView(
                  children: journalEntries.map((JournalEntry entry) {
                    return Builder(builder: (BuildContext context) {
                      return _Entry(
                        journal: entry,
                        updateEntries: updateJournalEntries,
                      );
                    });
                  }).toList(),
                );
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(),
                    Text(
                      'No journal entries yet.',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onBackground),
                    ),
                    const Spacer(),
                  ],
                );
              }
            }),
          ),
          const SizedBox(height: 80,),
          AdService.bannerAd
        ],
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 50.0,
            right: 0.0,
            child: FloatingActionButton(
              onPressed: () async {
                await Navigator.pushNamed(context, '/create_journal',
                    arguments: {'showMenuButton': false});
                updateJournalEntries();
              },
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }

}

class _Entry extends StatelessWidget {
  final JournalEntry journal;
  final Function updateEntries;

  const _Entry({required this.journal, required this.updateEntries});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/create_journal',
            arguments: {'journalEntry': journal, 'showMenuButton': false});
      },
      child: Card(
        margin: const EdgeInsets.only(
          left: 10.0,
          right: 10.0,
          bottom: 6.0,
        ),
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    journal.title,
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color:
                            Theme.of(context).colorScheme.onPrimaryContainer),
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        JournalDataManager.deleteEntry(journal.filePath)
                            .then((_) => updateEntries());
                      },
                      icon: Container(
                          width: 45.0,
                          height: 45.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                          child: const Icon(Icons.delete_forever_rounded)),
                      color: Theme.of(context).colorScheme.background)
                ],
              ),
              Text(
                limitStringLength(str: journal.content),
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                convertISOTimeToReadable(journal.strDateTime),
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
