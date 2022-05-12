import 'dart:convert';

class ISimpleClient {
  ISimpleClient({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  factory ISimpleClient.fromRawJson(String str) => ISimpleClient.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ISimpleClient.fromJson(Map<String, dynamic> json) => ISimpleClient(
    id: json["_id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
  };
}
