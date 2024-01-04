import 'package:flutter/material.dart';
import 'package:com.relief.motivationalapp/models/quote.dart';
import 'package:com.relief.motivationalapp/services/ads.dart';
import 'package:com.relief.motivationalapp/services/file_saving_service.dart';
import 'package:com.relief.motivationalapp/widgets/appbar.dart';

class QuotePage extends StatefulWidget {

  final bool isScreenshot;
  final Quote? quote;

  const QuotePage({
    super.key,
    this.isScreenshot = false,
    this.quote
  });

  @override
  State<QuotePage> createState() => _QuotePageState();
}

class _QuotePageState extends State<QuotePage> {

  late Quote _quote;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arguments =
    ModalRoute
        .of(context)
        ?.settings
        .arguments as Map<String, dynamic>?;
    if (widget.quote == null) {
      _quote = arguments?['quote'] ?? Quote();
    } else {
      _quote = widget.quote ?? Quote();
    }

    return Scaffold(
        appBar: ReliefAppBar(isScreenshot: widget.isScreenshot),
        body: MediaQuery(
          data: const MediaQueryData(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // QUOTE
              Expanded(
                child: Center(
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 45.0),
                    color: Theme.of(context).colorScheme.background,
                    shadowColor: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // QUOTATION MARK
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.format_quote_rounded,
                            size: 68,
                            color: Theme
                                .of(context)
                                .colorScheme
                                .onBackground,
                          ),
                        ),
                        const SizedBox(height: 25.0),

                        // QUOTE TEXT
                        Text(
                          _quote.quote,
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                            color: Theme
                                .of(context)
                                .colorScheme
                                .onBackground,
                          ),
                        ),
                        const SizedBox(height: 10.0),

                        // AUTHOR TEXT
                        Text(
                          _quote.author,
                          textAlign: TextAlign.right,
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .onBackground,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // BUTTONS
              Builder(builder: (BuildContext context) {
                if (!widget.isScreenshot) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 30,
                          ),
                          Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme
                                    .of(context)
                                    .colorScheme
                                    .secondary,
                              ),
                              child: IconButton(
                                  onPressed: () {
                                    saveQuoteImage(_quote).then((info) {
                                      if (info['success']) {
                                        showAlert(context, 'Image Saved!');
                                      } else {
                                        showAlert(context, 'An error has occurred.');
                                      }
                                    });
                                  },
                                  icon: const Icon(Icons.download_rounded))),
                          const SizedBox(
                            width: 30,
                          ),
                          Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme
                                    .of(context)
                                    .colorScheme
                                    .secondary,
                              ),
                              child: IconButton(
                                  onPressed: () async {
                                    await saveAndShareQuote(_quote);
                                  },
                                  icon: const Icon(Icons.share_rounded)
                              )
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0,),
                      AdService.bannerAd
                    ],
                  );
                } else {
                  return SizedBox(
                    height: 105.0,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Relief Motivational App\nby MGHS',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.normal
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
              }),
            ],
          ),
        )
    );
  }

}
