import 'dart:convert';

class IUserProfilePicture {
  IUserProfilePicture({
    required this.data,
    required this.id,
    required this.length,
    required this.chunkSize,
    required this.uploadDate,
    required this.filename,
    required this.contentType,
  });

  String data;
  String id;
  int length;
  int chunkSize;
  DateTime uploadDate;
  String filename;
  String contentType;

  factory IUserProfilePicture.fromRawJson(String str) => IUserProfilePicture.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory IUserProfilePicture.fromJson(Map<String, dynamic> json) => IUserProfilePicture(
    data: json["data"],
    id: json["_id"],
    length: json["length"],
    chunkSize: json["chunkSize"],
    uploadDate: DateTime.parse(json["uploadDate"]),
    filename: json["filename"],
    contentType: json["contentType"],
  );

  Map<String, dynamic> toJson() => {
    "data": data,
    "_id": id,
    "length": length,
    "chunkSize": chunkSize,
    "uploadDate": uploadDate.toIso8601String(),
    "filename": filename,
    "contentType": contentType,
  };
}