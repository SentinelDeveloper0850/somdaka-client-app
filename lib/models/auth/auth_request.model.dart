import 'dart:convert';

class IAuthResponse{

  final String token;
  final String role;
  final bool use2FA;

  IAuthResponse({
    required this.token,
    required this.role,
    required this.use2FA
  });

  factory IAuthResponse.fromJson(Map<String, dynamic> json){
    return IAuthResponse
      (
        token: json["token"],
        role: json["role"],
        use2FA: json["use2FA"]
    );
  }

}

class IAuthRequest {

  String email;
  String password;
  String product;

  IAuthRequest({
    required this.email,
    required this.password,
    required this.product
  });

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson(){
    Map<String, dynamic> map = {
      'email': email.trim().toLowerCase(),
      'password': password,
      "product": product
    };

    return map;
  }

}

class IJwtToken {
  IJwtToken({
    required this.user,
    required this.iat,
  });

  IJwtUser user;
  int iat;

  factory IJwtToken.fromRawJson(String str) => IJwtToken.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory IJwtToken.fromJson(Map<String, dynamic> json) => IJwtToken(
    user: IJwtUser.fromJson(json["user"]),
    iat: json["iat"],
  );

  Map<String, dynamic> toJson() => {
    "user": user.toJson(),
    "iat": iat,
  };
}

class IJwtUser {
  IJwtUser({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  factory IJwtUser.fromRawJson(String str) => IJwtUser.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory IJwtUser.fromJson(Map<String, dynamic> json) => IJwtUser(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
