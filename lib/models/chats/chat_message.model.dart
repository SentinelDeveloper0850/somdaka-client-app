import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'chat_user.model.dart';

class ChatMessage {
  ChatMessage({
    required this.createdAt,
    required this.id,
    required this.chatId,
    required this.userDetails,
    required this.message,
    required this.readBy
  });

  DateTime createdAt;
  String id;
  String chatId;
  ChatUser userDetails;
  String message;
  List<String> readBy;



  factory ChatMessage.fromRawJson(String str) => ChatMessage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    createdAt: json["created_at"] != "" ? DateTime.parse(json["created_at"]) : DateTime.now(),
    id: (json["_id"] != null) ? json["_id"] : "" ,
    chatId: json["chat_id"],
    userDetails: ChatUser.fromJson(json["user_details"]),
    message: json["message"],
    readBy: (json["read_by"]  != null ) ? List<String>.from(json["read_by"]) : [],
  );

  Map<String, dynamic> toJson() => {
    "_id": id.toString(),
    "created_at": createdAt.toIso8601String(),
    "chat_id": chatId,
    "user_details": userDetails.toJson(),
    "message": message,
    "read_by": readBy,
  };
}

