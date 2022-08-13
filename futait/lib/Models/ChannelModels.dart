// To parse this JSON data, do
//
//     final channelsModel = channelsModelFromJson(jsonString);

import 'dart:convert';

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
  List<Channel>? channels;

  factory ChannelsModel.fromJson(Map<String, dynamic> json) => ChannelsModel(
        responseCode: json["ResponseCode"],
        responseMessage: json["ResponseMessage"],
        channels: json["channels"] == null
            ? null
            : List<Channel>.from(
                json["channels"].map((x) => Channel.fromJson(x))),
      );
}

class Channel {
  Channel({
    this.id,
    this.categoryId,
    this.name,
    this.url,
    this.keys,
    this.image,
    this.category,
    this.urls,
  });

  int? id;
  String? categoryId;
  String? name;
  String? url;
  String? keys;
  String? image;
  Category? category;
  List<Url>? urls;

  factory Channel.fromJson(Map<String, dynamic> json) => Channel(
        id: json["id"],
        categoryId: json["category_id"],
        name: json["name"] ?? "",
        url: json["url"] ?? "",
        keys: json["keys"],
        image: json["image"],
        category: json["category"] == null
            ? null
            : Category.fromJson(json["category"]),
        urls: json["urls"] == null
            ? null
            : List<Url>.from(json["urls"].map((x) => Url.fromJson(x))),
      );
}

class Category {
  Category({
    this.id,
    this.name,
    this.description,
    this.banner,
  });

  int? id;
  String? name;
  String? description;
  String? banner;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"] ?? "",
        description: json["description"] ?? "",
        banner: json["banner"] ?? "",
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
      key: json["key"]);
}
