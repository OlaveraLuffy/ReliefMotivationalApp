import 'package:flutter/material.dart';
import 'package:com.relief.motivationalapp/services/email_service.dart';
import 'package:com.relief.motivationalapp/services/notifications.dart';
import 'package:com.relief.motivationalapp/services/user_preferences.dart';
import 'package:com.relief.motivationalapp/widgets/appbar.dart';
import 'package:com.relief.motivationalapp/widgets/quote_category_selector.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ReliefAppBar(),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 10.0,
              ),
              Text(
                'Settings',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).primaryColorDark,
                    fontWeight: FontWeight.bold),
              ),
              const _MainSettings(),
              const _About(),
              const _Feedback(),
              const _Legal(),
            ],
          ),
        ),
      ),
    );
  }
}

class _MainSettings extends StatelessWidget {
  const _MainSettings();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      shadowColor: Theme.of(context).colorScheme.shadow,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
        child: const Column(
          children: [
            _RcvNotifs(),
            Divider(height: 3.0, thickness: 2.0),
            QuoteCategoryToggler(),
          ],
        ),
      ),
    );
  }
}

class _RcvNotifs extends StatefulWidget {
  const _RcvNotifs();

  @override
  State<_RcvNotifs> createState() => _RcvNotifsState();
}

class _RcvNotifsState extends State<_RcvNotifs> {
  TimeOfDay selectedTime = UserPrefs.getNotifTime();
  bool receiveNotifications = UserPrefs.recvNotifs;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime =
        await showTimePicker(context: context, initialTime: selectedTime);

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
        UserPrefs.setNotifTime(pickedTime);
        Notifications.scheduleNotification(
            time: pickedTime, destinationRoute: '/create_journal');
      });
    }
  }

  Future<void> _toggleDailyNotifs() async {
    if (receiveNotifications) {
      Notifications.scheduleNotification(
          time: selectedTime, destinationRoute: '/create_journal');
    } else {
      Notifications.cancelScheduledNotification(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: Text(
                'RECEIVE NOTIFICATIONS',
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.left,
              ),
            ),
            Switch(
                value: receiveNotifications,
                onChanged: (bool value) {
                  setState(() {
                    receiveNotifications = value;
                    _toggleDailyNotifs();
                  });
                }),
          ],
        ),
        Builder(builder: (context) {
          return receiveNotifications
              ? const Divider(height: 3.0, thickness: 2.0)
              : const SizedBox.shrink();
        }),
        Builder(builder: (context) {
          if (receiveNotifications) {
            return Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: Text(
                    'Daily Notification: ${selectedTime.format(context)}',
                    style: Theme.of(context).textTheme.labelLarge,
                    textAlign: TextAlign.left,
                  ),
                ),
                IconButton(
                    onPressed: () => _selectTime(context),
                    icon: const Icon(Icons.edit_rounded))
              ],
            );
          } else {
            return const SizedBox.shrink();
          }
        }),
      ],
    );
  }
}

class _About extends StatelessWidget {
  const _About();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20.0),
        Text(
          'ABOUT',
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).primaryColorDark,
              fontWeight: FontWeight.bold),
        ),
        Card(
          margin: const EdgeInsets.symmetric(vertical: 5.0),
          shadowColor: Theme.of(context).colorScheme.shadow,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
            child: Column(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/text_page', arguments: {
                      'pageName': 'about the app',
                      'showMenuButton': false
                    });
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'ABOUT THE APP',
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ),
                const Divider(height: 3.0, thickness: 2.0),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/text_page', arguments: {
                      'pageName': 'about us',
                      'showMenuButton': false
                    });
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'ABOUT US',
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Feedback extends StatelessWidget {
  const _Feedback();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20.0),
        Text(
          'FEEDBACK',
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).primaryColorDark,
              fontWeight: FontWeight.bold),
        ),
        Card(
          margin: const EdgeInsets.symmetric(vertical: 5.0),
          shadowColor: Theme.of(context).colorScheme.shadow,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
            child: Column(
              children: [
                TextButton(
                  onPressed: ExternalUrlService.openAppStore,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'RATE OUR APP',
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  )
                ),
                const Divider(height: 3.0, thickness: 2.0),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/report', arguments: {
                      'showMenuButton': false
                    });
                  },
                  // onPressed: null,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'REPORT A PROBLEM',
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Legal extends StatelessWidget {
  const _Legal();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20.0),
        Text(
          'LEGAL',
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).primaryColorDark,
              fontWeight: FontWeight.bold),
        ),
        Card(
          margin: const EdgeInsets.symmetric(vertical: 5.0),
          shadowColor: Theme.of(context).colorScheme.shadow,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
            child: Column(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/text_page', arguments: {
                      'pageName': 'privacy policy',
                      'showMenuButton': false
                    });
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'PRIVACY POLICY',
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ),
                const Divider(height: 3.0, thickness: 2.0),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/text_page', arguments: {
                      'pageName': 'terms of use',
                      'showMenuButton': false
                    });
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'TERMS OF USE',
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
