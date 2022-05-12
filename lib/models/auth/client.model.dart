import 'dart:convert';

class IClient {
  IClient({
    required this.id,
    required this.services,
    required this.activated,
    required this.emailAddress,
    required this.isLegacy,
    required this.clientId,
    required this.createdAt,
    required this.name,
    required this.v,
    required this.logo,
    required this.updatedAt,
  });

  String id;
  List<dynamic> services;
  bool activated;
  String emailAddress;
  String isLegacy;
  int clientId;
  DateTime createdAt;
  String name;
  int v;
  String logo;
  DateTime updatedAt;

  factory IClient.fromRawJson(String str) => IClient.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory IClient.fromJson(Map<String, dynamic> json) => IClient(
    id: json["_id"],
    services: List<dynamic>.from(json["services"].map((x) => x )),
    activated: json["activated"],
    emailAddress: json["email_address"] ?? "",
    isLegacy: json["is_legacy"] != null ? json["is_legacy"] : "false",
    clientId: json["client_id"] ?? 0,
    createdAt: json["created_at"] != null?  DateTime.parse(json["created_at"]) : DateTime.parse(json["createdAt"]),
    name: json["name"],
    v: json["__v"],
    logo: json["logo"] ?? "",
    updatedAt: json["updated_at"] != null ? DateTime.parse(json["updated_at"]) : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "services": List<dynamic>.from(services.map((x) => x.toJson())),
    "activated": activated,
    "email_address": emailAddress,
    "is_legacy": isLegacy,
    "client_id": clientId,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "name": name,
    "__v": v,
    "logo": logo,
    "updatedAt": updatedAt.toIso8601String(),
  };
}

