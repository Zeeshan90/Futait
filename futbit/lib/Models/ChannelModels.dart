// To parse this JSON data, do
//
//     final channelsModel = channelsModelFromJson(jsonString);

import 'dart:convert';

import 'package:futait/Models/CategoriesModel.dart';

ChannelsModel channelsModelFromJson(String str) =>
    ChannelsModel.fromJson(json.decode(str));

class ChannelsModel {
  ChannelsModel({
    this.responseCode,
    this.responseMessage,
    this.channels,
  });

  int? responseCode;
  String? responseMessage;
  List<ChannelList>? channels;

  factory ChannelsModel.fromJson(Map<String, dynamic> json) => ChannelsModel(
        responseCode: json["ResponseCode"],
        responseMessage: json["ResponseMessage"],
        channels: List<ChannelList>.from(
            json["channels"].map((x) => ChannelList.fromJson(x))),
      );
}

class ChannelList {
  ChannelList({
    this.id,
    this.categoryId,
    this.channelId,
    this.category,
    this.channel,
  });

  int? id;
  String? categoryId;
  String? channelId;
  Category? category;
  Channel? channel;

  factory ChannelList.fromJson(Map<String, dynamic> json) => ChannelList(
        id: json["id"],
        categoryId: json["category_id"],
        channelId: json["channel_id"],
        category: Category.fromJson(json["category"]),
        channel: Channel.fromJson(json["channel"]),
      );
}

class Channel {
  Channel({
    this.id,
    this.name,
    this.url,
    this.keys,
    this.image,
    this.urls,
  });

  int? id;
  String? name;
  String? url;
  String? keys;
  String? image;
  List<Url>? urls;

  factory Channel.fromJson(Map<String, dynamic> json) => Channel(
        id: json["id"],
        name: json["name"] ?? "",
        url: json["url"] ?? "",
        keys: json["keys"] ?? "",
        image: json["image"] ?? "",
        urls: List<Url>.from(json["urls"].map((x) => Url.fromJson(x))),
      );
}

class Url {
  Url({
    this.id,
    this.channelId,
    this.subUrl,
    this.key,
  });

  int? id;
  String? channelId;
  String? subUrl;
  String? key;

  factory Url.fromJson(Map<String, dynamic> json) => Url(
        id: json["id"],
        channelId: json["channel_id"],
        subUrl: json["sub_url"],
        key: json["key"],
      );
}
