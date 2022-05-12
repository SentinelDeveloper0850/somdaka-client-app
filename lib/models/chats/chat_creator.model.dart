import 'dart:convert';

class ChatCreator {
  ChatCreator({
    required this.name,
    required this.id,
  });

  String name;
  String id;

  factory ChatCreator.fromRawJson(String str) => ChatCreator.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChatCreator.fromJson(Map<String, dynamic> json) => ChatCreator(
    name: json["name"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,
  };
}