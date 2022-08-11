// To parse this JSON data, do
//
//     final notificationsModel = notificationsModelFromJson(jsonString);

import 'dart:convert';

import 'package:futait/Constants.dart';

NotificationsModel notificationsModelFromJson(String str) =>
    NotificationsModel.fromJson(json.decode(str));

class NotificationsModel {
  NotificationsModel({
    this.responseCode,
    this.responseMessage,
    this.notifications,
  });

  int? responseCode;
  String? responseMessage;
  List<NotificationData>? notifications;

  factory NotificationsModel.fromJson(Map<String, dynamic> json) =>
      NotificationsModel(
        responseCode:
            json["ResponseCode"] == null ? null : json["ResponseCode"],
        responseMessage:
            json["ResponseMessage"] == null ? null : json["ResponseMessage"],
        notifications: json["notifications"] == null
            ? null
            : List<NotificationData>.from(
                json["notifications"].map((x) => NotificationData.fromJson(x))),
      );
}

class NotificationData {
  NotificationData({
    required this.id,
    required this.title,
    required this.body,
    required this.image,
  });

  int id;
  String title;
  String body;
  String image;

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      NotificationData(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        body: json["body"] == null ? null : json["body"],
        image: json["image"] == null ? Constants.placeHolderImageURL : json["image"],
      );
}
