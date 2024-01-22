import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {

  static BannerAdDisp bannerAd = const BannerAdDisp();
  static bool adsEnabled = false;

  static Future<void> init() async {
    MobileAds.instance.initialize();
    adsEnabled = true;
  }

}

class BannerAdDisp extends StatefulWidget {
  const BannerAdDisp({super.key});

  @override
  State<BannerAdDisp> createState() => _BannerAdDispState();
}

class _BannerAdDispState extends State<BannerAdDisp> with TickerProviderStateMixin {

  final AdSize adSize = const AdSize(width: 320, height: 50);
  static BannerAd? _bannerAd;
  bool _isLoaded = false;
  // TODO: change to production adUnitID
  //final bannerAdUnitId = 'ca-app-pub-8634651641429291/2517842118'; // production banner adUnitID
   final bannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111'; // test banner adUnitId

  @override
  void initState() {
    super.initState();
    loadAd();
  }

  /// Loads a banner ad.
  void loadAd() {
    if (AdService.adsEnabled) {
      _bannerAd = BannerAd(
        adUnitId: bannerAdUnitId,
        request: const AdRequest(),
        size: AdSize.banner,
        listener: BannerAdListener(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            debugPrint('$ad loaded.');
            setState(() {
              _isLoaded = true;
            });
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (ad, err) {
            debugPrint('BannerAd failed to load: $err');
            // Dispose the ad here to free resources.
            ad.dispose();
          },
        ),
      )..load();
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (_bannerAd != null) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: SafeArea(
            child: SizedBox(
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
          ),
        );
      } else {
        return SizedBox(height: adSize.height.toDouble(), width: adSize.width.toDouble(),);
      }
    });
  }
}
