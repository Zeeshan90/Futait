import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:futait/Constants.dart';
import 'package:futait/Controller/Manager.dart';
import 'package:futait/Pages/DashboardPage.dart';
import 'package:futait/Pages/NotificationPage.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Manager manager = Get.find(tag: 'manager');
  InterstitialAd? _interstitialAd;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myBanner.load();
    myNative!.load();
    _loadIntertialAdd();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        Get.snackbar(message.notification!.title!, message.notification!.body!);
      }

    });
  }

  final BannerAd myBanner = BannerAd(
    adUnitId: Constants.BANNER_ID,
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(),
  );

  final NativeAd? myNative = NativeAd(
    adUnitId: Constants.NATIVE_ID,
    factoryId: 'adFactoryExample',
    request: AdRequest(),
    listener: NativeAdListener(),
  );

  Widget loadNativeAd() {
    if (myNative != null) {
      return AdWidget(ad: myNative!);
    } else {
      return const SizedBox();
    }
  }

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
              manager.getAllCategories(isLoading: true);
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
              () => manager.loadingCategories.value
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : manager.categroiesModel!.categories!.isNotEmpty
                      ? ListView.builder(
                          itemCount:
                              manager.categroiesModel!.categories!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                if (_interstitialAd != null) {
                                  _interstitialAd!.show();
                                }

                                Get.to(DashboardPage(manager
                                    .categroiesModel!.categories![index].id!));
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
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(40),
                                        child: CachedNetworkImage(
                                          height: 80,
                                          width: 80,
                                          imageUrl: Constants.Base_URL +
                                              manager.categroiesModel!
                                                  .categories![index].banner!,
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
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
                                            manager.categroiesModel!
                                                .categories![index].name!,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Spaccer(height: 6.0),
                                          Text(
                                            manager
                                                        .categroiesModel!
                                                        .categories![index]
                                                        .description!
                                                        .length >=
                                                    100
                                                ? '${manager.categroiesModel!.categories![index].description?.substring(0, 100)}...'
                                                : manager
                                                        .categroiesModel!
                                                        .categories![index]
                                                        .description ??
                                                    "",
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
          // TODO: Display a banner when ready
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
    );
  }
}
