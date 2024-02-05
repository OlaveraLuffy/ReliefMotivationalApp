import 'package:flutter/material.dart';
import 'package:com.relief.motivationalapp/models/quote.dart';
import 'package:com.relief.motivationalapp/services/user_preferences.dart';
import 'package:com.relief.motivationalapp/services/file_saving_service.dart';
import 'package:com.relief.motivationalapp/widgets/quote_category.dart';

class Qotd extends StatefulWidget {
  const Qotd({
    super.key,
  });

  @override
  State<Qotd> createState() => _QotdState();
}

class _QotdState extends State<Qotd> {

  late Quote quote;

  @override
  void initState() {
    super.initState();
    quote = UserPrefs.getQotd();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                'QUOTE OF THE DAY',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/quote', arguments: {
                  'quote': quote,
                  'showMenuButton': false,
                });
              },
              child: _QuoteCard(quote: quote)
            )
          ],
        ),
      ),
    );
  }
}

class _QuoteCard extends StatelessWidget {
  final Quote quote;

  const _QuoteCard({required this.quote});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // ICON
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                child: const Icon(
                  Icons.format_quote,
                  size: 60.0,
                ),
              ),

              // QUOTE TEXT
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return Center(
                        child: Text(
                          quote.quote,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                              fontSize: _calculateFontSize(
                                constraints.maxWidth,
                                Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .fontSize!,
                              )),
                        ),
                      );
                    },
                  )),

              const SizedBox(height: 8.0),

              // AUTHOR TEXT
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  quote.author,
                  textAlign: TextAlign.end,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

              const Divider(
                indent: 30.0,
                endIndent: 30.0,
              ),

              // CATEGORY TEXT
              Padding(
                padding: const EdgeInsets.only(
                  left: 30.0,
                  right: 20.0,
                  bottom: 10.0,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        categoryCodeToDisp(quote.category).toUpperCase(),
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                    const SizedBox(width: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          child: IconButton(
                              onPressed: () async {
                                await saveAndShareQuote(quote);
                              },
                              icon: const Icon(Icons.share_rounded)),
                        ),
                        const SizedBox(width: 10),
                      ],
                    )
                  ],
                ),
              ),
            ],
          )
      ),
    );
  }

  double _calculateFontSize(double width, double baseFontSize) {
    const double maxWidth = 200;
    const double scaleFactor = 0.8;
    double scaledFontSize = baseFontSize;

    if (width < maxWidth) {
      scaledFontSize = width * scaleFactor / maxWidth * baseFontSize;
    }

    return scaledFontSize;
  }
}
