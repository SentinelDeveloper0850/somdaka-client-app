import 'dart:convert';

class ChatUser {
  ChatUser({
    required this.id,
    required this.userName,
    required this.emailAddress,
  });

  String id;
  String userName;
  String emailAddress;

  factory ChatUser.fromRawJson(String str) => ChatUser.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChatUser.fromJson(Map<String, dynamic> json) => ChatUser(
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

class ChatUserList{
  List<ChatUser> users;

  ChatUserList({required this.users});

  factory ChatUserList.fromJson(List<dynamic> userList){

    List<ChatUser> list = [];
    list = userList.map((i)=> ChatUser.fromJson(i)).toList();

    return new ChatUserList(
      users: list,
    );
  }


}