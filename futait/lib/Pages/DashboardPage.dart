import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:futait/Constants.dart';
import 'package:futait/Controller/Manager.dart';
import 'package:futait/Pages/NotificationPage.dart';
import 'package:futait/Pages/StreamingPage.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class DashboardPage extends StatefulWidget {
  var id;
  DashboardPage(this.id, {Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Manager dashboard = Get.find(tag: 'manager');
  InterstitialAd? _interstitialAd;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dashboard.filterVideos(widget.id);
    myBanner.load();
    _loadIntertialAdd();
  }


  final BannerAd myBanner = BannerAd(
    adUnitId: Constants.BANNER_ID,
    size: AdSize.banner,
    request: const AdRequest(),
    listener: const BannerAdListener(),
  );

  _loadIntertialAdd(){
    InterstitialAd.load(
        adUnitId: Constants.INTERITIAL_ID,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            // Keep a reference to the ad so you can show it later.
            _interstitialAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print(
                'InterstitialAd failed to load: $error');
          },
        ));
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
        // backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          InkWell(
            onTap: () {
              dashboard.filterVideos(widget.id);
            },
            child: Image.asset(
              "assets/refresh.png",
              color: Constants.iconColor,
              height: 30,
              width: 30,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 10),
            child: InkWell(
              onTap: () {
                Get.to(const NotificationPage());
              },
              child: Image.asset(
                "assets/notification.png",
                color: Constants.iconColor,
                height: 30,
                width: 30,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => dashboard.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : dashboard.channels.value.isNotEmpty
                      ? ListView.builder(
                          itemCount: dashboard.channels.value.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                if (_interstitialAd != null){
                                  _interstitialAd!.show();
                                }

                                var key = dashboard.channels.value[index].keys != null
                                    ? dashboard.channels.value[index].keys!
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
                                // _interstitialAd.dispose();
                                Get.to(
                                  StreamingPage(dashboard.channels.value[index].url!,
                                      map, dashboard.channels.value[index].urls!),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Container(
                                  padding:
                                      const EdgeInsets.only(bottom: 15, left: 15),
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        Constants.Base_URL +
                                            dashboard.channels.value[index].image!,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        dashboard.channels.value[index].name!,
                                        style: const TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : const Center(child: Text('No items')),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: myBanner.size.width.toDouble(),
              height: myBanner.size.height.toDouble(),
              child: AdWidget(ad: myBanner),
            ),
          ),
        ],
      ),
    );
  }
}