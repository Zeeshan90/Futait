import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/Manager.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Manager manager = Get.find(tag: 'manager');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    manager.getAllCategories(isLoading: false);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        Get.snackbar(message.notification!.title!, message.notification!.body!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            // color: Colors.red,
            height: Get.height / 1.59,
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              "assets/icon.png",
              height: 200,
              width: 200,
            ),
          ),
          const SizedBox(
              height: 40,
              child: Text(
                "powered by nodoapps.com",
                style: TextStyle(color: Colors.grey),
              ))
        ],
      ),
    );
  }
}
