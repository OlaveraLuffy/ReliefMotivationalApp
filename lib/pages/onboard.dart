import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Onboard extends StatefulWidget {
  const Onboard({super.key});

  @override
  State<Onboard> createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> {
  int currentPage = 0;
  late int totalPages;
  List pages = [
    const _Welcome(),
    const _InspirationalQuotes(),
    const _QotdShareAndSave(),
    const _QuoteGallery(),
    const _Journaling(),
    const _JournalInstructions(),
    const _DailyReminders(),
    const _StartYourJourney(),
  ];

  void updatePrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isOnboarded', true);
  }

  void gotoHome() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  void nextPage() {
    setState(() {
      if (currentPage+1 < totalPages) {
        currentPage += 1;
      } else {
        updatePrefs();
        gotoHome();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    totalPages = pages.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 60,),
                  Builder(builder: (context) {
                    return pages[currentPage];
                  }),
                  const SizedBox(height: 80,)
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: SizedBox(
                width: 200,
                height: 60,
                child: FilledButton(
                  onPressed: () {
                    nextPage();
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Next',
                      ),
                      Icon(
                        Icons.arrow_right_alt_rounded,
                        size: 32,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _Welcome extends StatelessWidget {
  const _Welcome();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/icons/relief.png',
          scale: 1.7,
        ),
        Text('Relief',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 56,
                  fontFamily: 'Roboto',
                  color: Theme.of(context).colorScheme.onBackground,
                )),
        const SizedBox(
          height: 12,
        ),
        Text(
          'Live your life,\nthe way you want',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontFamily: 'Roboto',
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
        const SizedBox(
          height: 30,
        ),
        Text(
          'Welcome to Relief',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'Dearest of friends, the following guides are to show you how to navigate through our app.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
      ],
    );
  }
}

class _InspirationalQuotes extends StatelessWidget {
  const _InspirationalQuotes();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            '✨ Inspirational Quotes: Start each day with a fresh burst of motivation. Discover a new inspirational quote every day that\'s tailor-made to uplift your spirits.',
            textAlign: TextAlign.justify,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onBackground
            ),
          ),
        ),
        const SizedBox(height: 20,),
        Image.asset('assets/images/onboarding/qotd.png'),
      ],
    );
  }
}

class _QotdShareAndSave extends StatelessWidget {
  const _QotdShareAndSave();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'You can share a quote by pressing the share button or download a photo of the quote using the download button',
            textAlign: TextAlign.justify,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onBackground
            ),
          ),
        ),
        const SizedBox(height: 20,),
        Image.asset('assets/images/onboarding/qotd_share_and_save.png'),
      ],
    );
  }
}

class _QuoteGallery extends StatelessWidget {
  const _QuoteGallery();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'You can also select a random quote from the quote gallery page.',
            textAlign: TextAlign.justify,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onBackground
            ),
          ),
        ),
        const SizedBox(height: 20,),
        Image.asset('assets/images/onboarding/quote-gallery.png'),
      ],
    );
  }
}



class _Journaling extends StatelessWidget {
  const _Journaling();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            '📚 Journal Your Journey: Pen down your thoughts, dreams, and experiences in our intuitive journaling feature. Capture moments, reflect on challenges, and celebrate victories. Your journey starts here.',
            textAlign: TextAlign.justify,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onBackground
            ),
          ),
        ),
        const SizedBox(height: 20,),
        Image.asset('assets/images/onboarding/journal.png'),
      ],
    );
  }
}

class _JournalInstructions extends StatelessWidget {
  const _JournalInstructions();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'You can edit a journal entry by clicking on it\'s card, delete an entry by clicking the delete button, and create a new entry by clicking the \'+\' button.',
            textAlign: TextAlign.justify,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onBackground
            ),
          ),
        ),
        const SizedBox(height: 20,),
        Image.asset('assets/images/onboarding/journal_instructions.png'),
      ],
    );
  }
}

class _DailyReminders extends StatelessWidget {
  const _DailyReminders();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            '🕒 Daily Reminders: Never miss a moment of self-care. Set personalized reminders to write in your journal at your preferred time, fostering a daily habit of mindfulness.',
            textAlign: TextAlign.justify,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onBackground
            ),
          ),
        ),
        const SizedBox(height: 20,),
        Image.asset('assets/images/onboarding/daily_notifs.png'),
      ],
    );
  }
}

class _StartYourJourney extends StatelessWidget {
  const _StartYourJourney();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            '🚀 Start Your Journey: Embark on a transformative adventure of self-discovery and growth with Relief. Cultivate positivity, set intentions, and uncover the power within you.',
            textAlign: TextAlign.justify,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onBackground
            ),
          ),
        ),
      ],
    );
  }
}
