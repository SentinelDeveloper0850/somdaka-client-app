import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:http/http.dart' as http;
import 'package:somdaka_client/helpers/formatters.helper.dart';
import 'package:somdaka_client/models/auth/user.model.dart';
import 'package:somdaka_client/models/users/user_profile_picture.model.dart';
import 'dart:convert';

import '../app.config.dart';

class UserService{

  late LocalStorage _storage;
  final String _baseUrl = "${ AppConfig.AUTH_URL}users/";

  UserService(){
    _storage = LocalStorage(AppConfig.LOCAL_STORAGE_DB_NAME);
  }

  Future<String> getUserProfilePicture(String userID) async{
    Uri endpoint = Uri.parse(_baseUrl + "picture/$userID");

    String token = await _storage.getItem("jwt");

    final response = await http.get(endpoint,
        headers: FormatterHelper().formatHttpAuthHeader(token));

    if(response.statusCode == 200){
      IUserProfilePicture _rawData = IUserProfilePicture
          .fromJson(json.decode(response.body));

      return _rawData.data;
    }else{
      return "";
    }

  }

  Future<Widget> convertUserProfilePicture(String userID) async{

    String imageData = await getUserProfilePicture(userID);

    Widget response = const Icon(CupertinoIcons.person, size: 30, color: Colors.white,);

    Uint8List bytes = const Base64Decoder().convert(imageData);

    if(bytes.isNotEmpty){
      response = Image.memory(bytes);
    }

    return response;
  }

  Future<List<IUser>> getUsersByClientId(String clientID) async{
    // /users/byClient/6017ec1617377d09e584d4a7
    Uri endpoint = Uri.parse(_baseUrl + "byClient/$clientID");

    final response = await http.get(endpoint);

    if(response.statusCode == 200){

      List<dynamic> jsonList = json.decode(response.body);


      List<IUser> users = List<IUser>.from(
          jsonList.map((e) => IUser.fromJson(e))
      );

      return users;

    }else{

      throw Exception("Cannot Get Users by client ID");
    }

  }

  Future<dynamic> getParentID(String emailAddress) async{
    final String _smileyKidsServiceUrl = AppConfig.SMILEY_KIDS_SERVICE_URL + 'api/';

    final Uri endpoint = Uri.parse(_smileyKidsServiceUrl + "parents");

    final response = await http.post(
      endpoint,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'emailAddress': emailAddress
      }),
    );

    if(response.statusCode == 200){

      try{
        var jsonData = json.decode(response.body);

        var parentDetails = jsonData['parent'];

        var parentID = parentDetails['_id'];

        if (kDebugMode) {
          print('Parent ID $parentID');
        }

        return parentID;
      }
      catch(e){
        if (kDebugMode) {
          print(e);
        }
        throw Exception("Failed to get Parent Details");
      }


    }else{
      if (kDebugMode) {
        print(json.decode(response.body));
      }
      throw Exception("Failed to get Parent Details");
    }
  }
}