import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:localstorage/localstorage.dart';
import 'package:somdaka_client/helpers/formatters.helper.dart';
import 'package:somdaka_client/models/auth/auth_request.model.dart';
import 'package:somdaka_client/models/auth/client.model.dart';
import 'package:somdaka_client/models/auth/user.model.dart';

import '../app.config.dart';


class AuthService{

  late LocalStorage _storage;

  AuthService(){
    _storage = LocalStorage(AppConfig.LOCAL_STORAGE_DB_NAME);
  }

  Future<IAuthResponse>
  performSignIn(IAuthRequest authRequest) async{

    Uri endpoint = Uri.parse(AppConfig.AUTH_URL + 'auth');
    var payload = jsonEncode(authRequest);
    final response = await http.post(
      endpoint,
      body: payload,
      headers:  FormatterHelper().formatHttpHeader('Content-Type', 'application/json; charset=UTF-8')
    );


    if(response.statusCode == 200){
      IAuthResponse authResponse = IAuthResponse.fromJson(json.decode(response.body));

      return authResponse;

    }else{
      print(json.decode(response.body));
      throw Exception("Failed to Perform Sign IN");
    }
  }

  Future<IUser> getSignedInUserInfo() async{

    Uri endpoint = Uri.parse(AppConfig.AUTH_URL + 'auth');
    String token = await _storage.getItem("jwt");
    final response = await http.get(endpoint, headers: {
      'Authorization': 'Bearer $token',
    });

    if(response.statusCode == 200){

      return IUser.fromJson(json.decode(response.body));

    }else{
      print(json.decode(response.body));
      throw Exception("Failed to get USER INFO");
    }

  }

  Future<IClient> getClientDetails(String clientId) async{
    Uri endpoint = Uri.parse(AppConfig.AUTH_URL + 'clients/$clientId');
    String token = await _storage.getItem("jwt");
    final response = await http.get(
        endpoint,
        headers: FormatterHelper().formatHttpAuthHeader(token)
    );

    if(response.statusCode == 200){
      return IClient.fromJson(json.decode(response.body));
    }
    else{
      print(json.decode(response.body));
      throw Exception("Failed to get Client INFO");
    }
  }

  Future<void> sendProductAnalytics() async{
    Uri endpoint = Uri.parse(AppConfig.AUTH_URL + 'auth/analytics/');
    String token = await _storage.getItem("jwt");
    await http.post(
        endpoint,
        body: {
          "product": AppConfig.PRODUCT_NAME
        },
        headers: FormatterHelper().formatHttpAuthHeader(token)
    );
  }
}