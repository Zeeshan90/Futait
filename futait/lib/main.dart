import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:futait/Constants.dart';
import 'package:futait/Controller/Manager.dart';
import 'package:futait/Pages/SplashPage.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future<void> main() async {

  // Step 2
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp();



  /// FCM Backgroung Listner
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings(
    '@mipmap/ic_launcher',
  );

  var initializationSettingsIOS = const IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,);

  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      );

  runApp(MyApp());
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}


class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final Manager manager = Get.put(Manager(), tag: 'manager');

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Futait',
      theme: ThemeData(
          primaryColor: Constants.primaryColor,
          backgroundColor: Constants.backgroundColor,
          scaffoldBackgroundColor: Constants.backgroundColor,
          appBarTheme: const AppBarTheme(color: Constants.appBarColor)),
      home: const SplashPage(),
    );
  }

  
}




