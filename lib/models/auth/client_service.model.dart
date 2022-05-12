import 'dart:convert';

class IClientService {
  IClientService({
    required this.id,
    required this.name,
    required this.description,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;
  String name;
  String description;
  String createdBy;
  DateTime createdAt;
  DateTime updatedAt;

  factory IClientService.fromRawJson(String str) => IClientService.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory IClientService.fromJson(Map<String, dynamic> json) => IClientService(
    id: json["_id"],
    name: json["name"],
    description: json["description"],
    createdBy: json["created_by"] ?? "",
    createdAt: json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : DateTime.now(),
    updatedAt: json["updatedAt"] != null ? DateTime.parse(json["updatedAt"]) : DateTime.now(),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "description": description,
    "created_by": createdBy,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}