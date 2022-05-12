import 'dart:convert';

class IRole {
  IRole({
    // required this.createdAt,
    // required this.updatedAt,
    required this.id,
    required this.name,
  });

  // DateTime createdAt;
  // DateTime updatedAt;
  String id;
  String name;

  factory IRole.fromRawJson(String str) => IRole.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory IRole.fromJson(Map<String, dynamic> json) => IRole(
    // createdAt: DateTime.parse(json["created_at"]),
    // updatedAt: json["updated_at"] != null ? DateTime.parse(json["updated_at"]) : DateTime.now(),
    id: json["_id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    // "created_at": createdAt.toIso8601String(),
    // "updated_at": updatedAt,
    "_id": id,
    "name": name,
  };
}