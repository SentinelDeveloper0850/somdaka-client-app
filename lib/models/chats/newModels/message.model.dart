import 'dart:convert';

import 'chat.dart';

class IMessage {
  IMessage({
    required this.createdAt,
    required this.id,
    required this.from,
    required this.chatId,
    required this.message,
  });

  DateTime createdAt;
  String id;
  IChatUser from;
  String chatId;
  String message;

  factory IMessage.fromRawJson(String str) => IMessage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory IMessage.fromJson(Map<String, dynamic> json) => IMessage(
    createdAt: DateTime.parse(json["created_at"]),
    id: json["_id"],
    from: IChatUser.fromJson(json["from"]),
    chatId: json["chat_id"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "created_at": createdAt.toIso8601String(),
    "_id": id,
    "from": from.toJson(),
    "chat_id": chatId,
    "message": message,
  };
}