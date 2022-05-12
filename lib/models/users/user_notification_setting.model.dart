import 'dart:convert';

class IUserNotificationSetting {
  IUserNotificationSetting({
    required this.userId,
    required this.priorities,
    required this.siteIds,
  });

  String userId;
  List<String> priorities;
  List<int> siteIds;

  factory IUserNotificationSetting.fromRawJson(String str) => IUserNotificationSetting.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory IUserNotificationSetting.fromJson(Map<String, dynamic> json) => IUserNotificationSetting(
    userId: json["user_id"],
    priorities: List<String>.from(json["priorities"].map((x) => x)),
    siteIds: List<int>.from(json["site_ids"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "priorities": List<dynamic>.from(priorities.map((x) => x)),
    "site_ids": List<dynamic>.from(siteIds.map((x) => x)),
  };
}