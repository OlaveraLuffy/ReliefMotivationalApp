import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:com.relief.motivationalapp/widgets/appbar.dart';

Map<String, String> fileMap = {
  'about the app': 'about_app.txt',
  'about us': 'about_us.txt',
  'privacy policy': 'privacy_policy.txt',
  'terms of use': 'terms_of_use.txt',
};

class TextPage extends StatefulWidget {

  const TextPage({super.key});

  @override
  State<TextPage> createState() => _TextPageState();
}

class _TextPageState extends State<TextPage> {

  String _pageName = '';
  String _pageText = '';

  void getPageText(String pageName) async {
    rootBundle.loadString('assets/text/${fileMap[pageName.toLowerCase()]}').then((String text) {
      setState(() {
        _pageText = text;
      });
    }).onError((error, stackTrace) {
      dev.log(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    // get data from routing
    final Map<String, dynamic>? arguments =
    ModalRoute
        .of(context)
        ?.settings
        .arguments as Map<String, dynamic>?;

    _pageName = arguments?['pageName'] ?? 'The title for this page is missing.';
    getPageText(_pageName);

    return Scaffold(
        appBar: const ReliefAppBar(),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _pageName.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onBackground
                  ),
                ),
                const SizedBox(height: 10.0,),
                Text(
                  _pageText,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onBackground
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}
