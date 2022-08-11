import 'dart:ui';
import 'package:flutter/material.dart';
import 'Models/NotificationModel.dart';

class Constants{

  static const primaryColor = Color(0XFF54a556);
  static const backgroundColor = Color(0XFF010101);
  static const cardColor = Color(0XFF0d1019);
  static const iconColor = Color(0XFF90928f);
  static const appBarColor = Color(0XFF0d1019);

  static const Base_URL = "https://livestream.codelogixs.com/public/";
  static var placeHolderImageURL = 'https://media.istockphoto.com/vectors/image-preview-icon-picture-placeholder-for-website-or-uiux-design-vector-id1222357475?k=20&m=1222357475&s=612x612&w=0&h=jPhUdbj_7nWHUp0dsKRf4DMGaHiC16kg_FSjRRGoZEI=';
  static const NOTIFICATION_URL = 'https://livestream.codelogixs.com/public/api/get-all-notifications';
  static const CATEGORIES_URL = 'https://livestream.codelogixs.com/public/api/getCategories';
  static const CHANNELS_URL = 'https://livestream.codelogixs.com/public/api/getChannels';
  static const HEADER_KEY = 'cfOiC2i+nw7K7VXH1+eUkVmzULbq2Wdo/lfTzMCht9w=';



  static const BANNER_ID = "ca-app-pub-5362074492136950/3055674376";
  static const INTERITIAL_ID = "ca-app-pub-5362074492136950/9237939344";
  static const NATIVE_ID = "ca-app-pub-5362074492136950/3602469280";

}


Widget Spaccer({width, height}){
 return SizedBox(
    width: width??0.0,
   height: height??0.0,
  );
}