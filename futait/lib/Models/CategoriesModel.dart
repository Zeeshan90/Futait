// To parse this JSON data, do
//
//     final categoriesModel = categoriesModelFromJson(jsonString);

import 'dart:convert';

CategoriesModel categoriesModelFromJson(String str) => CategoriesModel.fromJson(json.decode(str));


class CategoriesModel {
  CategoriesModel({
    this.responseCode,
    this.responseMessage,
    this.categories,
  });

  int? responseCode;
  String? responseMessage;
  List<Category>? categories;

  factory CategoriesModel.fromJson(Map<String, dynamic> json) => CategoriesModel(
    responseCode: json["ResponseCode"] == null ? null : json["ResponseCode"],
    responseMessage: json["ResponseMessage"] == null ? null : json["ResponseMessage"],
    categories: json["categories"] == null ? null : List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
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
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    description: json["description"] == null ? "" : json["description"],
    banner: json["banner"] == null ? "" : json["banner"],
  );
}
