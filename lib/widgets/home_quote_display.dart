import 'package:flutter/material.dart';

import '../models/quote.dart';

class HomeQuoteDisplay extends StatelessWidget {

  final Quote quote;

  const HomeQuoteDisplay({super.key, required this.quote});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5.0),
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
            Expanded(
                child: Container(
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
                    ))),

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
                  Text(
                    quote.category.toUpperCase(),
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const Spacer(),
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
                            onPressed: () {},
                            icon: const Icon(Icons.share_rounded)),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        child: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.save_alt_rounded)),
                      ),
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
