// ignore_for_file: unused_import

import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:com.relief.motivationalapp/services/email_service.dart';
import 'package:com.relief.motivationalapp/widgets/appbar.dart';

Map<String, String> fileMap = {
  'about the app': 'about_app.txt',
  'about us': 'about_us.txt',
  'privacy policy': 'privacy_policy.txt',
  'terms of use': 'terms_of_use.txt',
};

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void sendEmail() async {

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const ReliefAppBar(),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10.0),
            child: Center(
              child: Column(
                children: [
                  Text(
                    'REPORT A PROBLEM',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                  TextField(
                    controller: _textController,
                    maxLength: 1000,
                    maxLines: null,
                    cursorColor:
                        Theme.of(context).colorScheme.onPrimaryContainer,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.primaryContainer,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10.0),
                      hintText: 'Enter your problem.',
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer),
                    ),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color:
                            Theme.of(context).colorScheme.onPrimaryContainer),
                  ),
                ],
              ),
            )),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            ExternalUrlService.sendEmail(_textController.text);
            Navigator.pop(context);
          },
          child: const Icon(Icons.send_rounded)),
    );
  }
}
