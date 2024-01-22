import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:com.relief.motivationalapp/services/notifications.dart';
import 'package:com.relief.motivationalapp/services/quotes_data_manager.dart';
import 'package:com.relief.motivationalapp/services/user_preferences.dart';
import 'package:com.relief.motivationalapp/widgets/quote_category_selector.dart';

class MyData {
  int numOfNotifs;
  int hoursBetweenNotifs;
  Map<String, bool> categoriesToggle;
  TimeOfDay startTime;
  String customMsg;

  MyData(
      {required this.numOfNotifs,
      required this.hoursBetweenNotifs,
      required this.categoriesToggle,
      required this.startTime,
      this.customMsg = ''});
}

class MyInheritedWidget extends InheritedWidget {
  final MyData data;

  const MyInheritedWidget({
    super.key,
    required this.data,
    required Widget child,
  }) : super(child: child);

  static MyInheritedWidget of(BuildContext context) {
    final MyInheritedWidget? result =
        context.dependOnInheritedWidgetOfExactType<MyInheritedWidget>();
    assert(result != null, 'No MyInheritedWidget found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(MyInheritedWidget oldWidget) {
    return data != oldWidget.data;
  }
}

class QuoteScheduler extends StatefulWidget {
  const QuoteScheduler({
    super.key,
  });

  @override
  State<QuoteScheduler> createState() => _QuoteSchedulerState();
}

class _QuoteSchedulerState extends State<QuoteScheduler> {
  late List<String> categoriesList;
  late Map<String, bool> categoriesToggle;
  late MyData data;

  @override
  void initState() {
    super.initState();
    categoriesList = QuoteDataManager.getQuoteCategories();
    data = MyData(
      numOfNotifs: 1,
      hoursBetweenNotifs: 24,
      startTime: TimeOfDay.now(),
      categoriesToggle: {
        for (String category in categoriesList) category: true
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    data.categoriesToggle = UserPrefs.getQuoteCategoriesState(categoriesList);
    return MyInheritedWidget(
      data: data,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Container(
          width: MediaQuery.of(context).size.width - 30,
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // LABEL
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'SCHEDULED QUOTE',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                const Card(
                  margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: _SchedulingMenu(),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}

class _SchedulingMenu extends StatefulWidget {
  const _SchedulingMenu();

  @override
  State<_SchedulingMenu> createState() => _SchedulingMenuState();
}

class _SchedulingMenuState extends State<_SchedulingMenu> {
  late MyData data;
  int numOfActiveNotifs = 0;
  bool creatingSchedule = false;

  void _scheduleNotifs() {
    Notifications.scheduleMultipleNotifs(
        numOfNotifs: data.numOfNotifs,
        startTime: data.startTime,
        hoursBetweenNotifs: data.hoursBetweenNotifs,
        customMsg: data.customMsg);
  }

  void _openSchedulingMenu(BuildContext context) async {
    int numOfScheduledNotifs = await Notifications.getNumOfPendingNotifs();
    if (context.mounted) {
      if (numOfScheduledNotifs > 0) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirmation'),
              content: const Text(
                "Are you sure you want to schedule new notifications?\nThis will clear your previous set notifications.",
                style: TextStyle(
                  // Customize text color
                  color: Colors.white, // Change to your desired text color
                ),
              ),
              backgroundColor: const Color(0xFF879d55), // Change to your desired background color
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      creatingSchedule = true;
                    });
                  },
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      } else {
        setState(() {
          creatingSchedule = true;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    data = MyInheritedWidget.of(context).data;
    Notifications.getNumOfPendingNotifs().then((value) {
      setState(() {
        numOfActiveNotifs = value;
      });
    });
    return Builder(builder: (context) {
      if (creatingSchedule) {
        return Column(
          children: [
            const _TimePicker(),
            const Divider(
              height: 3,
              thickness: 1.5,
            ),
            const _NumOfNotifsPicker(),
            const Divider(
              height: 3,
              thickness: 1.5,
            ),
            const _FrequencyPicker(),
            const Divider(
              height: 3,
              thickness: 1.5,
            ),
            const QuoteCategoryToggler(),
            const Divider(
              height: 3,
              thickness: 1.5,
            ),
            const _CustomNotifMsg(),
            const Divider(
              height: 3,
              thickness: 1.5,
            ),
            Row(
              children: [
                const Expanded(child: Text('SCHEDULE NOTIFICATIONS')),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _scheduleNotifs();
                      creatingSchedule = false;
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).colorScheme.secondary),
                  ),
                  child: const Icon(Icons.schedule_rounded),
                ),
              ],
            )
          ],
        );
      } else {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text('Current Scheduled Quotes: $numOfActiveNotifs'),
              ElevatedButton(
                onPressed: () {
                  _openSchedulingMenu(context);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).colorScheme.secondary),
                ),
                child: const Text('Schedule Quotes'),
              ),
            ],
          ),
        );
      }
    });
  }
}

class _TimePicker extends StatefulWidget {
  const _TimePicker();

  @override
  State<_TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<_TimePicker> {
  late MyData data;
  TimeOfDay selectedTime = UserPrefs.getNotifTime();

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime =
        await showTimePicker(context: context, initialTime: selectedTime);

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
        data.startTime = selectedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    data = MyInheritedWidget.of(context).data;
    return Row(
      children: [
        Expanded(
          child: Text(
            'NOTIFICATION TIME: ${selectedTime.format(context)}',
          ),
        ),
        IconButton(
            onPressed: () => _selectTime(context),
            icon: const Icon(Icons.edit_rounded))
      ],
    );
  }
}

class _NumOfNotifsPicker extends StatefulWidget {
  const _NumOfNotifsPicker();

  @override
  State<_NumOfNotifsPicker> createState() => _NumOfNotifsPickerState();
}

class _NumOfNotifsPickerState extends State<_NumOfNotifsPicker> {
  late MyData data;

  void _increment() {
    setState(() {
      data.numOfNotifs++;
    });
  }

  void _decrement() {
    if (data.numOfNotifs > 1) {
      setState(() {
        data.numOfNotifs--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    data = MyInheritedWidget.of(context).data;
    return Row(
      children: [
        const Expanded(child: Text('NUMBER OF NOTIFICATIONS')),
        TextButton(
            onPressed: () => _decrement(), child: const Icon(Icons.remove)),
        Text(data.numOfNotifs.toString()),
        TextButton(onPressed: () => _increment(), child: const Icon(Icons.add)),
      ],
    );
  }
}

class _CustomNotifMsg extends StatefulWidget {
  const _CustomNotifMsg();

  @override
  State<_CustomNotifMsg> createState() => _CustomNotifMsgState();
}

class _CustomNotifMsgState extends State<_CustomNotifMsg> {
  late MyData data;
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

  @override
  Widget build(BuildContext context) {
    data = MyInheritedWidget.of(context).data;
    return TextField(
      controller: _textController,
      maxLength: 24,
      cursorColor: Theme.of(context).colorScheme.onPrimaryContainer,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      decoration: InputDecoration(
        counterText: '',
        filled: true,
        fillColor: Theme.of(context).colorScheme.primaryContainer,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
        hintText: 'SET A CUSTOM MESSAGE',
        hintStyle: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer, fontWeight: FontWeight.normal),
      ),
      style: Theme.of(context)
          .textTheme
          .bodyMedium!
          .copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer, fontWeight: FontWeight.normal),
      onChanged: (value) {
        data.customMsg = value;
      },
    );
  }
}

class _FrequencyPicker extends StatefulWidget {
  const _FrequencyPicker();

  @override
  State<_FrequencyPicker> createState() => _FrequencyPickerState();
}

class _FrequencyPickerState extends State<_FrequencyPicker> {
  late MyData data;
  String selectedOption = 'DAILY';
  Map<String, int> options = {
    'HOURLY': 1,
    'DAILY': 24,
    'WEEKLY': 168,
  };

  @override
  Widget build(BuildContext context) {
    data = MyInheritedWidget.of(context).data;
    return Row(
      children: [
        const Expanded(child: Text('FREQUENCY')),
        DropdownButton(
          value: selectedOption,
          items: options.keys.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              selectedOption = newValue ?? 'DAILY';
              data.hoursBetweenNotifs = options[selectedOption]!;
            });
          },
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
          dropdownColor: Theme.of(context).colorScheme.primaryContainer,
        ),
      ],
    );
  }
}

class _HoursBetweenNotifsPicker extends StatefulWidget {
  const _HoursBetweenNotifsPicker();

  @override
  State<_HoursBetweenNotifsPicker> createState() =>
      _HoursBetweenNotifsPickerState();
}

class _HoursBetweenNotifsPickerState extends State<_HoursBetweenNotifsPicker> {
  late MyData data;

  void _increment() {
    setState(() {
      data.hoursBetweenNotifs++;
    });
  }

  void _decrement() {
    if (data.hoursBetweenNotifs > 1) {
      setState(() {
        data.hoursBetweenNotifs--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    data = MyInheritedWidget.of(context).data;
    return Row(
      children: [
        const Expanded(child: Text('Hours between Notifications')),
        TextButton(
            onPressed: () => _decrement(), child: const Icon(Icons.remove)),
        Text(data.hoursBetweenNotifs.toString()),
        TextButton(onPressed: () => _increment(), child: const Icon(Icons.add)),
      ],
    );
  }
}
