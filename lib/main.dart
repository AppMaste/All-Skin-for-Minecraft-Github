// ignore_for_file: non_constant_identifier_names, invalid_use_of_protected_member

import 'dart:convert';

import 'package:all_skin_for_minecraft/demo.dart';
import 'package:all_skin_for_minecraft/src/screen/home%20screen/home%20screen.dart';
import 'package:all_skin_for_minecraft/src/screen/splash%20screens/splash%20screen.dart';
import 'package:all_skin_for_minecraft/src/service/notification%20service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'src/screen/home screen/firebase data config/data config.dart';

final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
RxMap minecraftData = {}.obs;

Future initConfig() async {
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(seconds: 1),
    minimumFetchInterval: const Duration(seconds: 10),
  ));
  await remoteConfig.fetchAndActivate();
  // Data();
  configDataController.Data();
}

AppOpenAd? appOpenAd;

loadAd() {
  AppOpenAd.load(
    adUnitId: minecraftData.value["minecraft-AppOpen"],
    orientation: AppOpenAd.orientationPortrait,
    request: const AdManagerAdRequest(),
    adLoadCallback: AppOpenAdLoadCallback(
      onAdLoaded: (ad) {
        print("Ad Loadede.................................");
        appOpenAd = ad;
        ad.show();
      },
      onAdFailedToLoad: (error) {
        AppOpenAd.load(
          adUnitId: minecraftData.value["minecraft-AppOpen"],
          orientation: AppOpenAd.orientationPortrait,
          request: const AdManagerAdRequest(),
          adLoadCallback: AppOpenAdLoadCallback(
            onAdLoaded: (ad) {
              print("Ad Loadede.................................");
              appOpenAd = ad;
              // isLoaded=true;
              ad.show();
            },
            onAdFailedToLoad: (error) {},
          ),
        );
      },
    ),
  );
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  NotificationService().initNotification();
  MobileAds.instance.initialize();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(
          (message) => firebasemessgingBackgroundMessagingHandler(message));
  // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  initConfig().whenComplete(() {
    minecraftData.value = json.decode(remoteConfig.getString('minecraft'));
    loadAd();
  });
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) =>  SplashScreen(),
        '/HomeScreen': (context) =>   HomeScreen(),
      },
    ),
  );
}

// void main() {
//   return runApp(
//     const GetMaterialApp(
//       home: MyHomePage(),
//     ),
//   );
// }
