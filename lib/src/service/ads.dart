// ignore_for_file: invalid_use_of_protected_member, non_constant_identifier_names

import 'dart:async';

import 'package:all_skin_for_minecraft/main.dart';
import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:facebook_audience_network/ad/ad_native.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/size.dart';

final minecraftNativeAD = Get.put(NativeAD());
final minecraftBannerAD = Get.put(BannerAD());
final native = Get.put(GetNative());
final ADController adController = Get.put(ADController());
final BackADController backADController = Get.put(BackADController());

class NativeAD extends GetxController {
  Future<void> _launchURL(String url) async {
    late Uri uri = Uri(scheme: "https", host: url);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw "Can not launch url";
    }
  }

  Widget getNative(String factoryId, String page) {
    NativeAd? nativeAd;
    var isLoaded = false.obs;
    if (minecraftData.value[page]["minecraft-Native-Type"] == "admob") {
      nativeAd = NativeAd(
        request: const AdManagerAdRequest(),
        adUnitId: minecraftData.value[page]["minecraft-Native"],
        listener: NativeAdListener(
            onAdLoaded: (ad) {
              nativeAd!.load();
              isLoaded.value = true;
            },
            onAdFailedToLoad: (ad, error) {}),
        // factoryId: wantSmallNativeAd ? "listTile" : "listTileMedium",
        factoryId: factoryId,
      );
      nativeAd.load();
    }
    return minecraftData.value[page]["minecraft-Native-Type"] == "admob"
        ? Obx(() => (isLoaded.value)
            ? factoryId == "listTile"
                ? Stack(
                    children: [
                      Container(
                        height: ScreenSize.fSize_150(),
                        width: ScreenSize.fSize_350(),
                        // color: Colors.green,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(1, 1),
                              color: Colors.black26,
                              blurRadius: 5,
                            )
                          ],
                        ),
                        child: AdWidget(
                          ad: nativeAd!,
                        ),
                        // color: Colors.blue,
                      ),
                    ],
                  )
                : Stack(
                    children: [
                      Container(
                        height: ScreenSize.fSize_250(),
                        width: ScreenSize.fSize_350(),
                        // color: Colors.green,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(1, 1),
                              color: Colors.black26,
                              blurRadius: 5,
                            )
                          ],
                        ),
                        child: AdWidget(
                          ad: nativeAd!,
                        ),
                        // color: Colors.blue,
                      ),
                    ],
                  )
            : factoryId == "listTile"
                ? Container(
                    height: ScreenSize.fSize_150(),
                    width: ScreenSize.fSize_350(),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(1, 1),
                          color: Colors.black26,
                          blurRadius: 5,
                        )
                      ],
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Container(
                    height: ScreenSize.fSize_250(),
                    width: ScreenSize.fSize_350(),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(1, 1),
                          color: Colors.black26,
                          blurRadius: 5,
                        )
                      ],
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ))
        : minecraftData.value[page]["minecraft-Native-Type"] == "fb"
            ? Container(
                height: factoryId == "listTile"
                    ? ScreenSize.fSize_150()
                    : ScreenSize.fSize_250(),
                width: ScreenSize.fSize_350(),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 25.0,
                    )
                  ],
                ),
                child: FacebookNativeAd(
                  placementId: minecraftData.value["minecraft-Native-FB"],
                  // placementId:
                  //     "IMG_16_9_APP_INSTALL#2312433698835503_2964953543583512",
                  adType: NativeAdType.NATIVE_AD,
                  height: factoryId == "listTileMedium"
                      ? ScreenSize.fSize_150()
                      : ScreenSize.fSize_250(),
                  width: ScreenSize.fSize_350(),
                  backgroundColor: Colors.white,
                  titleColor: Colors.black,
                  descriptionColor: Colors.grey,
                  buttonTitleColor: Colors.white,
                  buttonColor: const Color(0xFF320B3A).withOpacity(0.8),
                  buttonBorderColor: const Color(0xFFE65A55),
                  listener: (result, value) {
                    // print("Native Banner Ad: $result --> $value");
                  },
                ),
              )
            : minecraftData.value[page]["minecraft-Native-Type"] == "null"
                ? Container()
                : GestureDetector(
                    onTap: () {
                      _launchURL(minecraftData.value[page]["minecraft-Launch"]);
                    },
                    child: Stack(
                      children: [
                        Container(
                          height: factoryId == "listTile"
                              ? ScreenSize.fSize_150()
                              : ScreenSize.fSize_250(),
                          width: ScreenSize.fSize_350(),
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(minecraftData.value[page]
                                      ["minecraft-Image_Link"]))),
                        ),
                        Positioned(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(ScreenSize.fSize_2()))),
                            height: ScreenSize.fSize_16(),
                            width: ScreenSize.fSize_34(),
                            child: Center(
                                child: Text(
                              "Ad",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenSize.fSize_10()),
                            )),
                          ),
                        ),
                      ],
                    ),
                  );
  }
}

class BannerAD extends GetxController {
  late BannerAd bannerAd;
  int a = 1;

  // var bannerLoaded = false.obs;

  Widget getBanner(String page) {
    if (minecraftData.value[page]["minecraft-Banner-Type"] == "admob") {
      bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: minecraftData.value[page]["minecraft-Banner"],
        // adUnitId: "ca-app-pub-3940256099942544/6300978111",
        listener: BannerAdListener(
            onAdLoaded: (ad) {
              // print("Banner ad Loaded${a++}");
            },
            onAdFailedToLoad: (ad, error) {}),
        request: const AdRequest(),
      );
      bannerAd.load();
    }

    return minecraftData.value[page]["minecraft-Banner-Type"] == "fb"
        ? Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              // color: Colors.black12,
              height: 50,
              child: FacebookBannerAd(
                  // placementId: "YOUR_PLACEMENT_ID",
                  placementId: minecraftData.value["minecraft-Banner-FB"],
                  bannerSize: BannerSize.STANDARD,
                  listener: (result, value) {
                    // print("Banner Ad: $result -->  $value");
                  }),
            ),
          )
        : Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              // color: Colors.redAccent,
              height: 50,
              child: AdWidget(
                ad: bannerAd,
              ),
            ),
          );
  }
}

class GetNative {
  Future<dynamic> getData(String page) {
    NativeAd? ads;
    final completer = Completer();
    ads = NativeAd(
      adUnitId: minecraftData.value[page]["minecraft-Native"],
      // adUnitId: "/6499/example/native",
      factoryId: "listTileMedium",
      request: const AdManagerAdRequest(),
      listener: NativeAdListener(
          onAdLoaded: (ad) {
            completer.complete(ads);
          },
          onAdFailedToLoad: (ad, error) {}),
    )..load();
    // return Future.delayed(Duration(seconds: 2));
    return completer.future;
  }
}

class ADController extends GetxController {
  Future<void> _launchURL(String url) async {
    late Uri uri = Uri(scheme: "https", host: url);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw "Can not launch url";
    }
  }

  Rx Count = 1.obs;

  adButton(BuildContext context, String nextPageName, String currentPagename,
      var aa) async {
    // clickCount.value++;
    // ignore: unrelated_type_equality_checks
    if (minecraftData.value["minecraft-Count"] == Count.value) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: Center(
              child: AlertDialog(
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                        width: ScreenSize.fSize_30(),
                        height: ScreenSize.fSize_30(),
                        child: const CircularProgressIndicator()),
                    Text(
                      "Ad is loading...",
                      style:
                          GoogleFonts.chakraPetch(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
      if (minecraftData.value[currentPagename]["minecraft-Interstitial-Type"] ==
          'admob') {
        InterstitialAd.load(
          adUnitId: minecraftData.value[currentPagename]
              ["minecraft-Interstitial"],
          // adUnitId: "/6499/example/interstitial",
          request: const AdManagerAdRequest(),
          adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
            ad.show();
            Navigator.pop(context);
            nextPageName != 'stop'
                ? Get.toNamed(nextPageName, arguments: aa)
                : null;
            Count.value = 1;
          }, onAdFailedToLoad: (error) {
            InterstitialAd.load(
              adUnitId: minecraftData.value[currentPagename]
                  ["minecraft-Interstitial"],
              // adUnitId: "/6499/example/interstitial",
              request: const AdManagerAdRequest(),
              adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
                ad.show();
                Navigator.pop(context);
                nextPageName != 'stop'
                    ? Get.toNamed(nextPageName, arguments: aa)
                    : null;
                Count.value = 1;
              }, onAdFailedToLoad: (error) {
                Navigator.pop(context);
                nextPageName != 'stop'
                    ? Get.offNamed(nextPageName, arguments: aa)
                    : null;
                Count.value = 1;
              }),
            );
          }),
        );
      }

      if (minecraftData.value[currentPagename]["minecraft-Interstitial-Type"] ==
          'fb') {
        FacebookInterstitialAd.loadInterstitialAd(
          placementId: minecraftData.value["minecraft-Interstitial_FB"],
          // placementId: "IMG_16_9_APP_INSTALL#2312433698835503_2650502525028617",
          listener: (result, value) {
            if (result == InterstitialAdResult.LOADED) {
              FacebookInterstitialAd.showInterstitialAd();
              Navigator.pop(context);
              nextPageName != 'stop'
                  ? Get.toNamed(nextPageName, arguments: aa)
                  : null;
              Count.value = 1;
            }
            if (result == InterstitialAdResult.ERROR) {
              Navigator.pop(context);
              nextPageName != 'stop'
                  ? Get.toNamed(nextPageName, arguments: aa)
                  : null;
              Count.value = 1;
            }
          },
        );
      }
      if (minecraftData.value[currentPagename]["minecraft-Interstitial-Type"] ==
          "url") {
        _launchURL(minecraftData.value[currentPagename]["minecraft-Image"]);
        Future.delayed(
          const Duration(seconds: 2),
          () {
            Navigator.pop(context);
            nextPageName != 'stop'
                ? Get.toNamed(nextPageName, arguments: aa)
                : null;
            Count.value = 1;
          },
        );
      }
    } else {
      // Get.to(() => const FirstPage());
      nextPageName != 'stop' ? Get.toNamed(nextPageName, arguments: aa) : null;
      Count.value++;
      // controller.incrementClickCount(context, 'FirstPage');
    }
  }
}

class BackADController extends GetxController {
  Future<void> _launchURL(String url) async {
    late Uri uri = Uri(scheme: "https", host: url);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw "Can not launch url";
    }
  }

  Rx backCount = 1.obs;

  adButton(BuildContext context, String currentPagename) async {
    // clickCount.value++;
    // ignore: unrelated_type_equality_checks
    if (minecraftData.value["minecraft-BackCount"] == backCount.value) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: Center(
              child: AlertDialog(
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                        width: ScreenSize.fSize_30(),
                        height: ScreenSize.fSize_30(),
                        child: const CircularProgressIndicator()),
                    Text(
                      "Ad is loading...",
                      style:
                          GoogleFonts.chakraPetch(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
      if (minecraftData.value[currentPagename]["minecraft-Back-Interstitial-Type"] ==
          'admob') {
        InterstitialAd.load(
          adUnitId: minecraftData.value[currentPagename]
              ["minecraft-Interstitial"],
          // adUnitId: "/6499/example/interstitial",
          request: const AdManagerAdRequest(),
          adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
            ad.show();
            Navigator.pop(context);
            Navigator.pop(context);
            // nextPageName != 'stop'
            //     ? Get.toNamed(nextPageName, arguments: aa)
            //     : null;
            backCount.value = 1;
          }, onAdFailedToLoad: (error) {
            InterstitialAd.load(
              adUnitId: minecraftData.value[currentPagename]
                  ["minecraft-Interstitial"],
              // adUnitId: "/6499/example/interstitial",
              request: const AdManagerAdRequest(),
              adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
                ad.show();
                Navigator.pop(context);
                Navigator.pop(context);
                // nextPageName != 'stop'
                //     ? Get.toNamed(nextPageName, arguments: aa)
                //     : null;
                backCount.value = 1;
              }, onAdFailedToLoad: (error) {
                Navigator.pop(context);
                Navigator.pop(context);
                // nextPageName != 'stop'
                //     ? Get.offNamed(nextPageName, arguments: aa)
                //     : null;
                backCount.value = 1;
              }),
            );
          }),
        );
      }

      if (minecraftData.value[currentPagename]["minecraft-Back-Interstitial-Type"] ==
          'fb') {
        FacebookInterstitialAd.loadInterstitialAd(
          placementId: minecraftData.value["minecraft-Interstitial_FB"],
          // placementId: "IMG_16_9_APP_INSTALL#2312433698835503_2650502525028617",
          listener: (result, value) {
            if (result == InterstitialAdResult.LOADED) {
              FacebookInterstitialAd.showInterstitialAd();
              Navigator.pop(context);
              Navigator.pop(context);
              // nextPageName != 'stop'
              //     ? Get.toNamed(nextPageName, arguments: aa)
              //     : null;
              backCount.value = 1;
            }
            if (result == InterstitialAdResult.ERROR) {
              Navigator.pop(context);
              Navigator.pop(context);
              // nextPageName != 'stop'
              //     ? Get.toNamed(nextPageName, arguments: aa)
              //     : null;
              backCount.value = 1;
            }
          },
        );
      }
      if (minecraftData.value[currentPagename]["minecraft-Back-Interstitial-Type"] ==
          "url") {
        _launchURL(minecraftData.value[currentPagename]["minecraft-Image"]);
        Future.delayed(
          const Duration(seconds: 2),
          () {
            Navigator.pop(context);
            Navigator.pop(context);
            // nextPageName != 'stop'
            //     ? Get.toNamed(nextPageName, arguments: aa)
            //     : null;
            backCount.value = 1;
          },
        );
      }
    } else {
      // Get.to(() => const FirstPage());
      Navigator.pop(context);
      // nextPageName != 'stop' ? Get.toNamed(nextPageName, arguments: aa) : null;
      backCount.value++;
      // controller.incrementClickCount(context, 'FirstPage');
    }
  }
}
