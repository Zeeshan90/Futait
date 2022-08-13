import 'dart:ui';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:futait/Models/ChannelModels.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../Constants.dart';

class StreamingPage extends StatefulWidget {
  var url = "";
  late Map<String, String> keys;
  late List<Url> urls;
  StreamingPage(this.url, this.keys, this.urls, {Key? key}) : super(key: key);

  @override
  State<StreamingPage> createState() => _StreamingPageState();
}

class _StreamingPageState extends State<StreamingPage> {
  late BetterPlayerController _clearKeyControllerNetwork;
  InterstitialAd? _interstitialAd;

  final BannerAd myBanner = BannerAd(
    adUnitId: Constants.BANNER_ID,
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(),
  );

  _loadIntertialAdd() {
    InterstitialAd.load(
        adUnitId: Constants.INTERITIAL_ID,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            // Keep a reference to the ad so you can show it later.
            _interstitialAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error');
          },
        ));
  }

  @override
  void initState() {
    myBanner.load();
    _loadIntertialAdd();
    BetterPlayerConfiguration betterPlayerConfiguration =
        const BetterPlayerConfiguration(
      aspectRatio: 16 / 12,
      autoPlay: true,
    );
    _clearKeyControllerNetwork =
        BetterPlayerController(betterPlayerConfiguration);

    _setupDataSources();

    super.initState();
  }

  void _setupDataSources() async {
    var clearKeyDataSourceNetwork = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      widget.url,
      drmConfiguration: BetterPlayerDrmConfiguration(
          drmType: BetterPlayerDrmType.clearKey,
          clearKey: BetterPlayerClearKeyUtils.generateKey(widget.keys)),
    );

    _clearKeyControllerNetwork.setupDataSource(clearKeyDataSourceNetwork);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Image.asset(
            "assets/icon.png",
            fit: BoxFit.cover,
            scale: 4,
          ),
        ),
        // backgroundColor: Constants.appBarColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              fit: StackFit.passthrough,
              children: [
                BetterPlayer(
                  controller: _clearKeyControllerNetwork,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      width: 80,
                      height: 60,
                      color: Colors.black87,
                      child: Image.asset(
                        "assets/icon.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
              child: ListView.builder(
                itemCount: widget.urls.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      if (_interstitialAd != null) {
                        _interstitialAd!.show();
                      }

                      var key = widget.urls[index].key != null
                          ? widget.urls[index].key!
                          : "";
                      var newText = key.substring(1, key.length - 1);
                      var parts = newText.split(',');
                      Map<String, String> map = {};
                      map.clear();
                      for (var i = 0; i < parts.length; i++) {
                        var key = parts[i].replaceAll('"', '');
                        var val = parts[i + 1].replaceAll('"', '');
                        Map<String, String> map1 = {key: val};
                        map.addAll(map1);
                        i = i + 1;
                      }
                      setState(() {
                        widget.url = widget.urls[index].subUrl!;
                        widget.keys = map;
                        _setupDataSources();
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Constants.cardColor),
                          height: 50,
                          child: Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                name(index),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16),
                              ),
                            ),
                          )),
                    ),
                  );
                },
              ),
            )),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: myBanner.size.width.toDouble(),
                height: myBanner.size.height.toDouble(),
                child: AdWidget(ad: myBanner),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String name(index) {
  var ind = index + 1;
  return "Server $ind";
}
