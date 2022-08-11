import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:futait/Constants.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../Controller/Manager.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  Manager manager = Get.find(tag: 'manager');
  InterstitialAd? _interstitialAd;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myBanner.load();
    _loadIntertialAdd();
  }

  final BannerAd myBanner = BannerAd(
    adUnitId: Constants.BANNER_ID,
    size: AdSize.banner,
    request: const AdRequest(),
    listener: const BannerAdListener(),
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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Notifications"),
        ),
        body: Column(
          children: [
            Expanded(
              child: Obx(
                () => manager.loadingNotification.value
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : manager.notificationsModel!.notifications!.isNotEmpty
                        ? ListView.builder(
                            itemCount: manager
                                .notificationsModel!.notifications!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  _interstitialAd!.show();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    height: 120,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Constants.cardColor),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/app_icon.jpeg',
                                          height: 80,
                                          width: 80,
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              manager.notificationsModel!
                                                  .notifications![index].title,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Spaccer(height: 6.0),
                                            Text(
                                              manager
                                                          .notificationsModel!
                                                          .notifications![index]
                                                          .body
                                                          .length >=
                                                      100
                                                  ? '${manager.notificationsModel!.notifications![index].body.substring(0, 100)}...'
                                                  : manager
                                                      .notificationsModel!
                                                      .notifications![index]
                                                      .body,
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ))
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
              child: SizedBox(
                width: myBanner.size.width.toDouble(),
                height: myBanner.size.height.toDouble(),
                child: AdWidget(ad: myBanner),
              ),
            ),
          ],
        ));
  }
}
