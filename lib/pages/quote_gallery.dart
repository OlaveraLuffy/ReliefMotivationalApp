import 'package:flutter/material.dart';
import 'package:com.relief.motivationalapp/services/ads.dart';
import 'package:com.relief.motivationalapp/services/quotes_data_manager.dart';
import 'package:com.relief.motivationalapp/widgets/appbar.dart';
import 'package:com.relief.motivationalapp/widgets/quote_category.dart';

class QuoteGallery extends StatefulWidget {


  const QuoteGallery({super.key});

  @override
  State<QuoteGallery> createState() => _QuoteGalleryState();
}

class _QuoteGalleryState extends State<QuoteGallery> {

  List<String> categories = [];

  @override
  void initState() {
    super.initState();
    categories = QuoteDataManager.getQuoteCategories();
  }

  @override
  Widget build(BuildContext context) {
    const double cardSize = 170;

    return Scaffold(
      appBar: const ReliefAppBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(30.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Wrap(
                  spacing: 10.0,
                  children: categories.map((category) {
                    return SizedBox(
                      width: cardSize,
                      height: cardSize,
                      child: QuoteCategoryCard(category: category),
                    );
                  }).toList()
                ),
              ),
            ),
          ),
          AdService.bannerAd
        ],
      ),
    );
  }
}
