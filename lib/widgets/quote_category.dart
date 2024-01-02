import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:com.relief.motivationalapp/models/quote.dart';
import 'package:com.relief.motivationalapp/services/quotes_data_manager.dart';

// void precacheImages(BuildContext context) {
//   precacheImage(const AssetImage('assets/images/categories/dreams.png'), context);
//   precacheImage(const AssetImage('assets/images/categories/family.png'), context);
//   precacheImage(const AssetImage('assets/images/categories/friendship.png'), context);
//   precacheImage(const AssetImage('assets/images/categories/future.png'), context);
//   precacheImage(const AssetImage('assets/images/categories/happiness.png'), context);
//   precacheImage(const AssetImage('assets/images/categories/inspirational.png'), context);
//   precacheImage(const AssetImage('assets/images/categories/life.png'), context);
//   precacheImage(const AssetImage('assets/images/categories/love.png'), context);
//   precacheImage(const AssetImage('assets/images/categories/relationship.png'), context);
//   precacheImage(const AssetImage('assets/images/categories/motivational.png'), context);
//   precacheImage(const AssetImage('assets/images/categories/encourage_and_inspire.png'), context);
//   precacheImage(const AssetImage('assets/images/categories/hope.png'), context);
//   precacheImage(const AssetImage('assets/images/categories/bib_inspirational.png'), context);
//   precacheImage(const AssetImage('assets/images/categories/powerful_scriptures_on_faith.png'), context);
//   precacheImage(const AssetImage('assets/images/categories/powerful_verses_to_live_by.png'), context);
//   precacheImage(const AssetImage('assets/images/categories/strength.png'), context);
// }

Map<String, Widget> iconsMap = {
  'dreams': Image.asset('assets/images/categories/dreams.png', scale: 0.5),
  'family': Image.asset('assets/images/categories/family.png', scale: 0.5),
  'friendship': Image.asset('assets/images/categories/friendship.png', scale: 0.5),
  'future': Image.asset('assets/images/categories/future.png', scale: 0.5),
  'happiness': Image.asset('assets/images/categories/happiness.png', scale: 0.5),
  'inspirational': Image.asset('assets/images/categories/inspirational.png', scale: 0.5),
  'life': Image.asset('assets/images/categories/life.png', scale: 0.5),
  'love': Image.asset('assets/images/categories/love.png', scale: 0.5),
  'relationship': Image.asset('assets/images/categories/relationship.png', scale: 0.5),
  'motivational': Image.asset('assets/images/categories/motivational.png', scale: 0.5),
  'bib_encourage_and_inspire': Image.asset('assets/images/categories/encourage_and_inspire.png', scale: 0.5),
  'bib_hope': Image.asset('assets/images/categories/hope.png', scale: 0.5),
  'bib_inspirational': Image.asset('assets/images/categories/bib_inspirational.png', scale: 0.5),
  'bib_powerful_scriptures_on_faith': Image.asset('assets/images/categories/powerful_scriptures_on_faith.png', scale: 0.5),
  'bib_powerful_verses_to_live_by': Image.asset('assets/images/categories/powerful_verses_to_live_by.png', scale: 0.5),
  'bib_strength': Image.asset('assets/images/categories/strength.png', scale: 0.5),
};

String categoryCodeToDisp(String category) {
  List<String> parts = category.split('_');
  if (parts.length > 1 && parts[0] == 'bib') {
    parts.removeAt(0);
  }
  return parts.join(' ');
}


class HomeCategoriesPicker extends StatefulWidget {


  const HomeCategoriesPicker({super.key});

  @override
  State<HomeCategoriesPicker> createState() => _HomeCategoriesPickerState();
}

class _HomeCategoriesPickerState extends State<HomeCategoriesPicker> {

  List<String> quoteCategories = [];

  @override
  void initState() {
    super.initState();
    quoteCategories = QuoteDataManager.getQuoteCategories();
  }

  @override
  Widget build(BuildContext context) {

    // precacheImages(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [

        // TEXT LABEL
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'WHAT ARE YOU FEELING TODAY?',
            style: Theme
                .of(context)
                .textTheme
                .titleSmall,
          ),
        ),

        // MAIN CONTENT
        CarouselSlider(
          options: CarouselOptions(
            height: 150.0,
            viewportFraction: 0.4,
          ),
          items: quoteCategories.map((category) {
            return Builder(
              builder: (BuildContext context) {
                return QuoteCategoryCard(category: category);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}


class QuoteCategoryCard extends StatelessWidget {

  final String category;

  const QuoteCategoryCard({
    super.key,
    required this.category
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.0,
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5.0),
        child: TextButton(
          onPressed: (){
            Quote randQuote = QuoteDataManager.getRandomQuote(category);
            Navigator.pushNamed(context, '/quote', arguments: {
              'quote': randQuote,
              'showMenuButton': false,
            });
          },
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: FractionallySizedBox(
                    widthFactor: 0.8,
                    heightFactor: 0.8,
                    child: Align(
                        alignment: Alignment.center,
                        child: iconsMap[category.toLowerCase()] ?? const Icon(Icons.question_mark_rounded)
                    ),
                  ),
                ),
                Text(
                  categoryCodeToDisp(category).toUpperCase(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
