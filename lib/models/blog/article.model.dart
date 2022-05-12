import 'dart:convert';

import 'package:somdaka_client/models/simple_client.model.dart';

class IArticle {
  IArticle({
    required this.id,
    required this.body,
    required this.categories,
    required this.createdAt,
    required this.title,
    required this.subtitle,
    required this.author,
    required this.readDuration,
    required this.clientDetails,
  });

  String id;
  List<String> body;
  List<String> categories;
  DateTime createdAt;
  String title;
  String subtitle;
  String author;
  String readDuration;
  ISimpleClient clientDetails;

  factory IArticle.fromRawJson(String str) => IArticle.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory IArticle.fromJson(Map<String, dynamic> json) => IArticle(
    id: json["_id"],
    body: List<String>.from(json["body"].map((x) => x)),
    categories: List<String>.from(json["categories"].map((x) => x)),
    createdAt: DateTime.parse(json["created_at"]),
    title: json["title"],
    subtitle: json["subtitle"],
    author: json["author"],
    readDuration: json["read_duration"],
    clientDetails: ISimpleClient.fromJson(json["client_details"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "body": List<dynamic>.from(body.map((x) => x)),
    "categories": List<dynamic>.from(categories.map((x) => x)),
    "created_at": createdAt.toIso8601String(),
    "title": title,
    "subtitle": subtitle,
    "author": author,
    "read_duration": readDuration,
    "client_details": clientDetails.toJson(),
  };
}