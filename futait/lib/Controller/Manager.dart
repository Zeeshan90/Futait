import 'dart:math';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:futait/Models/CategoriesModel.dart';
import 'package:futait/Models/ChannelModels.dart';
import 'package:futait/Pages/HomePage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Constants.dart';
import '../Models/NotificationModel.dart';

class Manager extends GetxController {
  // loadings
  var loadingDashboard = false.obs;
  var loadingNotification = false.obs;
  var loadingCategories = false.obs;
  var loadingChannels = false.obs;

  // Models
  NotificationsModel? notificationsModel;
  CategoriesModel? categroiesModel;
  ChannelsModel? channelModel;

  void getAllCategories({isLoading}) async {
    loadingCategories.value = true;
    try {
      var response = await Dio().get(Constants.CATEGORIES_URL,
          options: Options(headers: {"KEY": Constants.HEADER_KEY}));
      categroiesModel = categoriesModelFromJson(response.toString());
      getAllChannels(isLoading: isLoading);
    } catch (e) {
      print(e);
    }
  }

  void getAllChannels({isLoading}) async {
    loadingChannels.value = true;
    try {
      var response = await Dio().get(Constants.CHANNELS_URL,
          options: Options(headers: {"KEY": Constants.HEADER_KEY}));
      channelModel = channelsModelFromJson(response.toString());
      getAllNotifications(isLoading: isLoading);
    } catch (e) {
      print(e);
    }
  }

  void getAllNotifications({isLoading}) async {
    loadingNotification.value = true;
    try {
      var response = await Dio().get(Constants.NOTIFICATION_URL,
          options: Options(headers: {"KEY": Constants.HEADER_KEY}));
      notificationsModel = notificationsModelFromJson(response.toString());

      if (!isLoading) {
        Get.offAll(const HomePage());
      }

      loadingNotification.value = false;
      loadingDashboard.value = false;
      loadingCategories.value = false;
      loadingChannels.value = false;
    } catch (e) {
      print(e);
    }
  }

  var channels = RxList<Channel>().obs;
  var isLoading = true.obs;

  filterVideos(var id) {
    channels.value.clear();
    channelModel?.channels?.forEach((element) {
      if (element.categoryId == id.toString()) {
        channels.value.add(element);
      }
    });
    isLoading.value = false;
  }

  sendFcmToken() async {
    final prefs = await SharedPreferences.getInstance();
    final String? fcmToken = prefs.getString('FCMTOKEN');
    if (fcmToken == null) {
      FirebaseMessaging.instance.getToken().then((value) async {
        String? token = value;
        prefs.setString('FCMTOKEN', token.toString());
        try {
          var response = await Dio().post(Constants.FCM_URL,
              data: {"device_id": token.toString()},
              options: Options(headers: {"KEY": Constants.HEADER_KEY}));
          print(response);
        } catch (e) {
          print(e);
        }
      });
    }
  }
}
