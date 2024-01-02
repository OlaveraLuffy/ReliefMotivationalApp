import 'package:flutter/material.dart';
import 'package:com.relief.motivationalapp/models/quote.dart';
import 'package:com.relief.motivationalapp/services/quotes_data_manager.dart';
import 'package:com.relief.motivationalapp/services/user_preferences.dart';
import 'package:com.relief.motivationalapp/services/file_saving_service.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:com.relief.motivationalapp/main.dart';
import 'dart:developer' as dev;

class Notifications {
  static final FlutterLocalNotificationsPlugin notifPlugin =
      FlutterLocalNotificationsPlugin();
  static const NotificationDetails notifDetails = NotificationDetails(
      android: AndroidNotificationDetails('relief_0', 'relief_notifications',
          importance: Importance.max,
          priority: Priority.high,
          sound: RawResourceAndroidNotificationSound('fairy_glitter'),
          playSound: true,
          enableVibration: true,
          icon: '@mipmap/relief'));

  static Future<void> init() async {
    tz.initializeTimeZones();

    notifPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('relief');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await notifPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  static Future<void> onDidReceiveNotificationResponse(
      NotificationResponse response) async {
    String? route = response.payload != '' ? response.payload : null;
    if (route != null) {
      if (route == '/create_journal') {
        navigatorKey.currentState?.pushNamed(route);
      } else if (route == '/quote') {
        List<String> quoteCategories =
          UserPrefs.getEnabledQuoteCategories();
        String randomCategory = getRandomItem(quoteCategories);
        Quote randomQuote = QuoteDataManager.getRandomQuote(randomCategory);
        navigatorKey.currentState
            ?.pushNamed(route, arguments: {'quote': randomQuote});
      }
    }
  }

  static Future<void> sendNotification({String? destinationRoute}) async {
    await notifPlugin.show(0, 'Relief',
        'How was your day? It\'s time for your daily journal!', notifDetails,
        payload: destinationRoute);
  }

  static Future<void> scheduleNotification(
      {required TimeOfDay time, String? destinationRoute}) async {
    DateTime now = DateTime.now();
    DateTime scheduledTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);

    if (scheduledTime.difference(now).inSeconds <= 0) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    Duration timeBeforeNotif = scheduledTime.difference(now);

    tz.TZDateTime tzScheduledTime =
        tz.TZDateTime.now(tz.local).add(timeBeforeNotif);

    await notifPlugin.zonedSchedule(
        0,
        'Relief',
        'How was your day? It\'s time for your daily journal!',
        tzScheduledTime,
        notifDetails,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: destinationRoute);
  }

  static Future<void> cancelScheduledNotification(int id) async {
    await notifPlugin.cancel(id);
  }

  static void scheduleMultipleNotifs({
    required int numOfNotifs,
    required TimeOfDay startTime,
    required int hoursBetweenNotifs,
    String customMsg = '',
  }) async {
    // clear any existing notifications
    List<PendingNotificationRequest> pendingNotifs =
        await notifPlugin.pendingNotificationRequests();
    if (pendingNotifs.length > 1) {
      for (int i = 1; i <= pendingNotifs.length; i++) {
        cancelScheduledNotification(i);
      }
    }

    DateTime now = DateTime.now();
    DateTime scheduledTime = DateTime(
        now.year, now.month, now.day, startTime.hour, startTime.minute);

    if (scheduledTime.difference(now).inSeconds <= 0) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    for (int i = 1; i <= numOfNotifs; i++) {
      Duration timeBeforeNotif = scheduledTime.difference(now);
      Duration offset = Duration(hours: hoursBetweenNotifs * (i - 1));
      tz.TZDateTime tzScheduledTime =
          tz.TZDateTime.now(tz.local).add(timeBeforeNotif + offset);
      await notifPlugin
          .zonedSchedule(
              i,
              'Relief - Scheduled Quotes',
              customMsg == '' ? 'Time for your scheduled quote!' : customMsg,
              tzScheduledTime,
              notifDetails,
              androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
              uiLocalNotificationDateInterpretation:
                  UILocalNotificationDateInterpretation.absoluteTime,
              payload: '/quote')
          .then((value) {
        dev.log('notification scheduled at $tzScheduledTime');
      });
    }
  }

  static Future<int> getNumOfPendingNotifs() async {
    List<PendingNotificationRequest> pendingNotifs =
        await notifPlugin.pendingNotificationRequests();
    int numOfPendingNotifs = 0;
    for (PendingNotificationRequest notif in pendingNotifs) {
      if (notif.id != 0) {
        numOfPendingNotifs += 1;
      }
    }
    return numOfPendingNotifs;
  }
}
