import 'dart:convert';

import 'chat_creator.model.dart';
import 'chat_message.model.dart';
import 'chat_user.model.dart';

class Chat {
  Chat({
    required this.createdAt,
    required this.users,
    required this.id,
    required this.name,
    required this.organisationId,
    required this.creator,
    required this.isP2P,
    required this.lastMessage
  });

  DateTime createdAt;
  List<ChatUser> users;
  String id;
  String name;
  bool isP2P;
  String organisationId;
  ChatCreator creator;
  ChatMessage lastMessage;

  factory Chat.fromRawJson(String str) => Chat.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
    createdAt: DateTime.parse(json["created_at"]),
    users: List<ChatUser>.from(json["users"].map((x) => ChatUser.fromJson(x))),
    id: json["_id"],
    name: json["name"],
    isP2P: json["is_p2p"],
    organisationId: json["organisation_id"],
    creator: ChatCreator.fromJson(json["creator"]),
    lastMessage: (json["last_message"] != null) ? ChatMessage.fromJson(json["last_message"]) : ChatMessage(
        id: "",
        message: "No Message",
        chatId: "",
        createdAt: DateTime.now(),
        userDetails: ChatUser(
            id: "",
            userName: "",
            emailAddress: ""
        ), readBy: []
    )
  );

  Map<String, dynamic> toJson() => {
    "created_at": createdAt.toIso8601String(),
    "users": users,
    "name": name,
    "is_p2p": isP2P.toString(),
    "organisation_id": organisationId,
    "creator": creator.toJson(),
    "last_message": lastMessage,
  };

}