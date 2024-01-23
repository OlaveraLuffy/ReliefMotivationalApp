import 'package:flutter/material.dart';
import 'package:com.relief.motivationalapp/pages/journal.dart';
import 'package:com.relief.motivationalapp/pages/loading.dart';
import 'package:com.relief.motivationalapp/pages/home.dart';
import 'package:com.relief.motivationalapp/pages/settings.dart';
import 'package:com.relief.motivationalapp/pages/onboard.dart';
import 'package:com.relief.motivationalapp/pages/menu.dart';
import 'package:com.relief.motivationalapp/pages/quote_page.dart';
import 'package:com.relief.motivationalapp/pages/quote_gallery.dart';
import 'package:com.relief.motivationalapp/pages/create_journal.dart';
import 'package:com.relief.motivationalapp/pages/text_page.dart';
import 'package:com.relief.motivationalapp/pages/report.dart';
import 'package:com.relief.motivationalapp/services/journal_data_manager.dart';
import 'package:com.relief.motivationalapp/services/notifications.dart';
import 'package:com.relief.motivationalapp/services/quotes_data_manager.dart';
import 'package:com.relief.motivationalapp/services/user_preferences.dart';
import 'package:com.relief.motivationalapp/theme/theme_constants.dart';
import 'package:com.relief.motivationalapp/theme/theme_manager.dart';

import 'package:com.relief.motivationalapp/services/ads.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await QuoteDataManager.init();
  await JournalDataManager.init();
  await Notifications.init();
  await UserPrefs.init();
  // TODO: enable ads here on production, change also the id in build.gradle
  AdService.init();

  runApp(ReliefApp());
}

class ReliefApp extends StatefulWidget {

  ReliefApp({super.key});

  final ThemeManager _themeManager = ThemeManager();

  @override
  State<ReliefApp> createState() => _ReliefAppState();
}

class _ReliefAppState extends State<ReliefApp> {
  @override
  void initState() {
    widget._themeManager.addListener(themeListener);
    super.initState();

  }

  @override
  void dispose() {
    widget._themeManager.removeListener(themeListener);
    super.dispose();
  }

  void themeListener() {
    if (mounted) {
      setState(() {
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Relief',
      navigatorKey: navigatorKey,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: widget._themeManager.themeMode,
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const Loading(),
        '/home': (context) => const Home(),
        '/journal': (context) => const Journal(),
        '/gallery': (context) => const QuoteGallery(),
        '/menu': (context) => const Menu(),
        '/settings': (context) => const Settings(),
        '/quote': (context) => const QuotePage(),
        '/onboard':(context) => const Onboard(),
        '/create_journal':(context) => const CreateJournal(),
        '/text_page':(context) => const TextPage(),
        '/report':(context) => const Report(),
      },
    );
  }
}

