import 'package:com.relief.motivationalapp/services/user_preferences.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'dart:math';
import 'package:com.relief.motivationalapp/models/quote.dart';

class QuoteDataManager {

  static Map<String, List<Quote>> _quotes = {};
  // static final List<Quote> _bibleVerses = [];

  static Map<String, List<Quote>> get quotes => _quotes;
  // static List<Quote> get bibleVerses  => _bibleVerses;

  static Future<void> init() async {
    await getQuotesData();
    // await getBibleVerseData();
  }

  static Quote getRandomQuote([String? category]) {
    late Quote randomQuote;
    Random random = Random();
    late int randomIndex;

    if (category == null) {
      List<String> enabledCategories = UserPrefs.getEnabledQuoteCategories();
      randomIndex = random.nextInt(enabledCategories.length);
      category = enabledCategories[randomIndex];
    } else {
      category = category.toLowerCase();
    }

    randomIndex = random.nextInt(_quotes[category]!.length);
    randomQuote = _quotes[category]![randomIndex];

    // if the quote is too long, find another one
    if (randomQuote.quote.length > 200) {
      return getRandomQuote(category);
    }
    return randomQuote;
  }

  static Future<Map<String, List<Quote>>> getQuotesData() async {
    final jsonString = await rootBundle.loadString('assets/json/quotes.json');
    final jsonData = json.decode(jsonString) as Map<String, dynamic>;

    Map<String, List<Quote>> parsedData = {};
    jsonData.forEach((category, quoteList) {
      if (quoteList is List<dynamic>) {
        List<Quote> parsedList = [];
        for (var quote in quoteList) {
          if (quote is Map<String, dynamic>) {
            parsedList.add(Quote(
              category: category,
              quote: quote['quote'],
              author: quote['author']
            ));
          }
        }
        parsedData[category] = parsedList;
      }
    });
    _quotes = parsedData;
    return parsedData;
  }

  static List<String> getQuoteCategories() {
    List<String> categories = _quotes.keys.toList();
    return categories;
  }

}