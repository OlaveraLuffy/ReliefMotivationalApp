import 'package:flutter/material.dart';
import 'package:com.relief.motivationalapp/services/ads.dart';
import 'package:com.relief.motivationalapp/widgets/appbar.dart';
import 'package:com.relief.motivationalapp/widgets/quote_category.dart';
import 'package:com.relief.motivationalapp/widgets/menu_journal.dart';
import 'package:com.relief.motivationalapp/widgets/qotd.dart';
import 'package:com.relief.motivationalapp/widgets/quote_scheduler.dart';
import 'package:com.relief.motivationalapp/widgets/music_player.dart';

class Home extends StatefulWidget {

  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ReliefAppBar(),
      body: Stack(
        children: [
          const SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Qotd(),
                HomeCategoriesPicker(),
                QuoteScheduler(),
                MenuJournal(),
                SizedBox(height: 80,)
              ],
            ),
          ),
          AdService.bannerAd
        ],
      ),
      bottomNavigationBar: const MusicPlayer(),
    );
  }
}
