import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:futait/Constants.dart';
import 'package:futait/Controller/Manager.dart';
import 'package:futait/Pages/SplashPage.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {

  // Step 2
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  // Step 3
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(MyApp()));

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  runApp(MyApp());
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

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

