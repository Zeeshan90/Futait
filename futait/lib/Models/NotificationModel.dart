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

  dynamic responseCode;
  dynamic responseMessage;
  List<NotificationData>? notifications;

  factory NotificationsModel.fromJson(Map<String, dynamic> json) =>
      NotificationsModel(
        responseCode: json["ResponseCode"],
        responseMessage: json["ResponseMessage"] ?? 'null',
        notifications: json["notifications"] == null
            ? []
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

  dynamic id;
  dynamic title;
  dynamic body;
  dynamic image;

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      NotificationData(
        id: json["id"] ?? 'null',
        title: json["title"] ?? 'null',
        body: json["body"] ?? 'null',
        image: json["image"] ?? Constants.placeHolderImageURL,
      );
}
