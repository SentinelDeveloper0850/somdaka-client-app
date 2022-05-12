import 'dart:convert';

class IChat {
  IChat({
    required this.members,
    required this.createdAt,
    required this.id,
    required this.type,
    required this.name,
    required this.clientId,
    required this.creator,
    required this.attachedToTask
  });

  List<IChatUser> members;
  DateTime createdAt;
  String id;
  String type;
  String name;
  String clientId;
  IChatUser creator;
  bool attachedToTask;

  factory IChat.fromRawJson(String str) => IChat.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory IChat.fromJson(Map<String, dynamic> json) => IChat(
    members: List<IChatUser>.from(json["members"].map((x) => IChatUser.fromJson(x))),
    createdAt: DateTime.parse(json["created_at"]),
    id: json["_id"],
    type: json["type"],
    name: '${json["name"]}',
    clientId: json["client_id"],
    creator: IChatUser.fromJson(json["creator"]),
    attachedToTask: json["attached_to_task"]
  );

  Map<String, dynamic> toJson() => {
    "members": List<IChatUser>.from(members.map((x) => x)),
    "created_at": createdAt.toIso8601String(),
    "_id": id,
    "type": type,
    "name": name,
    "client_id": clientId,
    "creator": creator.toJson(),
    "attached_to_task": attachedToTask
  };
}

class IChatUser {
  IChatUser({
    required this.id,
    required this.userName,
    required this.emailAddress,
  });

  String id;
  String userName;
  String emailAddress;

  factory IChatUser.fromRawJson(String str) => IChatUser.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory IChatUser.fromJson(Map<String, dynamic> json) => IChatUser(
    id: json["id"],
    userName: json["user_name"],
    emailAddress: json["email_address"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_name": userName,
    "email_address": emailAddress,
  };
}
