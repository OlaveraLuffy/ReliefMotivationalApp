import 'package:flutter/material.dart';
import 'package:com.relief.motivationalapp/models/quote.dart';
import 'package:com.relief.motivationalapp/services/quotes_data_manager.dart';
import 'package:com.relief.motivationalapp/services/user_preferences.dart';
import 'package:com.relief.motivationalapp/services/file_saving_service.dart';
import 'package:com.relief.motivationalapp/widgets/quote_category.dart';

class QuoteCategoryToggler extends StatefulWidget {
  const QuoteCategoryToggler({super.key});

  @override
  State<QuoteCategoryToggler> createState() => _QuoteCategoryTogglerState();
}

class _QuoteCategoryTogglerState extends State<QuoteCategoryToggler> {
  bool _isExpanded = false;
  late List<String> categoriesList;
  late Map<String, bool> categoriesToggle;

  Future<void> _toggleQuoteCategoryUserPrefs(String category, bool value) async {
    // Toggle the category
    UserPrefs.setQuoteCategory(category, value);

    List<String> enabledCategoriesAfterToggle = UserPrefs.getEnabledQuoteCategories();

    if (!value && enabledCategoriesAfterToggle.isEmpty) {
      // If the category is being toggled off and no categories are left,
      // prevent the last remaining category from being deselected.
      UserPrefs.setQuoteCategory(category, true);
    }

    List<String> enabledCategories = UserPrefs.getEnabledQuoteCategories();
    late Quote quote;
    if (enabledCategories.isNotEmpty) {
      String randomCategory = getRandomItem(enabledCategories);
      quote = QuoteDataManager.getRandomQuote(randomCategory);
    } else {
      quote = Quote(category: "Default Category", author: "Default Author", quote: "Default Quote");
    }
    setState(() {
      UserPrefs.updateQotd(quote);
    });
  }

  @override
  void initState() {
    super.initState();
    categoriesList = QuoteDataManager.getQuoteCategories();
    categoriesToggle = UserPrefs.getQuoteCategoriesState(categoriesList);
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      elevation: 0.0,
      expandedHeaderPadding: EdgeInsets.zero,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      children: [
        ExpansionPanel(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          headerBuilder: (context, isExpanded) {
            return Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1.0),
                child: Text(
                  'QUOTE CATEGORIES',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            );
          },
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: categoriesList.map((String category) {
              String categoryStr = categoryCodeToDisp(category).toUpperCase();
              return Column(children: [
                const Divider(
                  height: 5.0,
                  thickness: 1.2,
                ),
                Row(
                  children: [
                    Expanded(child: Text(categoryStr)),
                    Switch(
                      value: categoriesToggle[category] ?? true,
                      onChanged: (bool value) {
                        setState(() {
                          categoriesToggle[category] = value;
                          _toggleQuoteCategoryUserPrefs(category, value);
                        });
                      },
                      activeColor: Colors.white,
                      inactiveTrackColor: Colors.grey,
                      inactiveThumbColor: Colors.white,
                    ),
                  ],
                ),
              ]);
            }).toList(),
          ),
          isExpanded: _isExpanded,
        ),
      ],
    );
  }
}