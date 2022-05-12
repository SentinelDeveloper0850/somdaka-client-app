import 'dart:convert';

import 'role.model.dart';


class IUser {
  IUser({
    required this.id,
    required this.activated,
    required this.createdAt,
    required this.clientId,
    required this.name,
    required this.surname,
    required this.emailAddress,
    required this.contactNumber,
    required this.role,
    required this.clientName,
    required this.socialMediaAuthDetails,
    required this.profilePicture,
    required this.updatedAt,
  });

  String id;
  bool activated;
  DateTime createdAt;
  String clientId;
  String name;
  String surname;
  String emailAddress;
  String contactNumber;
  IRole role;
  String clientName;
  List<dynamic> socialMediaAuthDetails;
  String profilePicture;
  DateTime updatedAt;

  factory IUser.fromRawJson(String str) => IUser.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory IUser.fromJson(Map<String, dynamic> json) => IUser(
    id: json["_id"],
    activated: json["activated"],
    createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : DateTime.now() ,
    clientId: json["client_id"],
    name: json["name"],
    surname: json["surname"],
    emailAddress: json["email_address"],
    contactNumber: json["contact_number"] ?? "",
    role: IRole.fromJson(json["role"]),
    clientName: json["client_name"],
    socialMediaAuthDetails: json["social_media_auth_details"] != null ?
    List<dynamic>.from(json["social_media_auth_details"].map((x) => x)) : [],
    profilePicture: json["profile_picture"] ?? "",
    updatedAt:json["updated_at"] != null ? DateTime.parse(json["updated_at"]) : DateTime.now(),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "activated": activated,
    "created_at": createdAt.toIso8601String(),
    "client_id": clientId,
    "name": name,
    "surname": surname,
    "email_address": emailAddress,
    "contact_number": contactNumber,
    "role": role.toJson(),
    "client_name": clientName,
    "social_media_auth_details": List<dynamic>.from(socialMediaAuthDetails.map((x) => x)),
    "profile_picture": profilePicture,
    "updatedAt": updatedAt.toIso8601String(),
  };
}
