import 'package:flutter/material.dart';
import 'package:com.relief.motivationalapp/models/quote.dart';
import 'package:com.relief.motivationalapp/services/quotes_data_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as dev;

class UserPrefs {

  static late final SharedPreferences _prefs;
  static late bool isOnboarded;
  static late bool recvNotifs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    isOnboarded = _prefs.getBool('isOnboarded') != true ? false : true;
    recvNotifs = _prefs.getBool('recvNotifs') != true ? false : true;
  }

  static Future<void> resetPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('isOnboarded');
    prefs.remove('recvNotifs');
    prefs.remove('notifHour');
    prefs.remove('notifMinute');
    prefs.remove('qotd');
  }

  static TimeOfDay getNotifTime() {
    int hour = _prefs.getInt('notifHour') ?? 0;
    int minute  = _prefs.getInt('notifMinute') ?? 0;
    TimeOfDay notifTime = TimeOfDay(hour: hour, minute: minute);
    return notifTime;
  }

  static Future<void> updateQotd(Quote qotd) async {
    String now = DateTime.now().toIso8601String();
    List<String> qotdStringList = [qotd.author, qotd.quote, qotd.category, now];
    _prefs.setStringList('qotd', qotdStringList);
  }

  static Quote getQotd() {
    late Quote qotd;
    List<String>? qotdStringList = _prefs.getStringList('qotd');

    try {
      // check if there is saved qotd data
      if (qotdStringList != null) {
        DateTime qotdLastUpdatedDate = DateTime.parse(qotdStringList[3]);
        DateTime now = DateTime.now();
        bool qotdOutdated = now.day > qotdLastUpdatedDate.day;
        dev.log('qotd last update: $qotdLastUpdatedDate, now: $now');

        if (!qotdOutdated) {
          // use the quote saved in the preferences as the qotd
          qotd = Quote(
            author: qotdStringList[0],
            quote: qotdStringList[1],
            category: qotdStringList[2],
          );

          // check if the saved quote is in the enabled categories
          List<String> enabledCategories = getEnabledQuoteCategories();
          bool qotdInEnabledCategory = enabledCategories.contains(qotd.category);
          if (qotdInEnabledCategory) {
            return qotd;
          }
        }
      }
    } on RangeError {
      qotd = QuoteDataManager.getRandomQuote();
      updateQotd(qotd);
      return qotd;
    } catch (e) {
      dev.log('An error has occured while trying to get qotd: $e');
    }

    qotd = QuoteDataManager.getRandomQuote();
    updateQotd(qotd);
    return qotd;
  }

  static void setNotifTime(TimeOfDay notifTime) async {
    _prefs.setInt('notifHour', notifTime.hour);
    _prefs.setInt('notifMinute', notifTime.minute);
  }

  static Map<String, bool> getQuoteCategoriesState(List<String> categories) {
    Map<String, bool> categoriesState = {};
    for (String category in categories) {
      categoriesState[category] = _prefs.getBool(category) ?? true;
    }
    return categoriesState;
  }

  static List<String> getEnabledQuoteCategories() {
    // returns a list of enabled categories
    List<String> categories = QuoteDataManager.getQuoteCategories();
    Map<String, bool> categoriesState = getQuoteCategoriesState(categories);
    List<String> enabledQuoteCategories = [];
    for (var entry in categoriesState.entries) {
      if (entry.value == true) {
        enabledQuoteCategories.add(entry.key);
      }
    }
    return enabledQuoteCategories;
  }

  static void setQuoteCategory(String category, bool value) async {
    _prefs.setBool(category, value);
  }
}
