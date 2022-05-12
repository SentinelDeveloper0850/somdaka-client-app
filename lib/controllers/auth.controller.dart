import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jwt_decode/jwt_decode.dart' as jwt;
import 'package:localstorage/localstorage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:somdaka_client/models/auth/auth_request.model.dart';
import 'package:somdaka_client/models/auth/client.model.dart';
import 'package:somdaka_client/models/auth/role.model.dart';
import 'package:somdaka_client/models/auth/user.model.dart';
import 'package:somdaka_client/services/auth.service.dart';
import 'package:somdaka_client/services/user.service.dart';

import '../app.config.dart';

class AuthController extends GetxController{

  var isPerformingAuthCheck = true.obs;
  var userIsLoggedIn = false.obs;

  final _userProfilePicture = "".obs;

  late LocalStorage _storage;

  var packageInfo = PackageInfo(
      appName: "",
      packageName: "",
      version: "",
      buildNumber: "").obs;

  var currentUser = IUser(
      id: "",
      activated: false,
      createdAt: DateTime.now(),
      clientId: "",
      name: "",
      surname: "",
      emailAddress: "",
      contactNumber: "",
      role: IRole(
          id: "",
          name: ""
      ),
      clientName: "",
      socialMediaAuthDetails: [],
      profilePicture: "",
      updatedAt: DateTime.now()
  ).obs;

  var clientDetails = IClient(
    id: "",
    services: [],
    activated: false,
    emailAddress: "",
    isLegacy: "",
    clientId: 0,
    createdAt:  DateTime.now(),
    name: "",
    v: 0,
    logo: "",
    updatedAt:  DateTime.now(),
  ).obs;

  @override
  void onInit(){
    super.onInit();
    _storage = LocalStorage(AppConfig.LOCAL_STORAGE_DB_NAME);
    _storage.ready.then((value) async{
      isPerformingAuthCheck.value = value;
      checkIfSignedIn();
    });

    _getPackageDetails();

  }

  Widget getProfilePicture(){

    Widget response = const Icon(CupertinoIcons.person, size: 30, color: Colors.white,);

    Uint8List bytes = const Base64Decoder().convert(_userProfilePicture.value);

    if(bytes.isNotEmpty){
      response = Image.memory(bytes);
    }

    return response;
  }

  Future<bool> signIn(IAuthRequest authRequest) async{
    bool res = false;

    try{
      IAuthResponse authResponse = await AuthService().performSignIn(authRequest);
      _storage.setItem("jwt", authResponse.token);
      currentUser.value = await AuthService().getSignedInUserInfo();
      clientDetails.value = await AuthService().getClientDetails(currentUser.value.clientId);

      _userProfilePicture.value = await UserService().getUserProfilePicture(currentUser.value.id);

      res = true;
    }
    catch(e){
      debugPrintStack();
      if(e.toString().contains("Failed to get profile picture")){
        res = true;
      }
      else if(e.toString().contains("Invalid Credentials")){
        Get.snackbar(
            "Sign In Failed",
            "Invalid Credentials Provided",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white
        );
        res = false;
      }
      else{
        Get.snackbar(
            "Sign In Failed",
            "Invalid Credentials Provided",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white
        );
        res = false;
      }

    }

    return res;
  }

  void checkIfSignedIn() async{
    try{
      String token = await _storage.getItem("jwt");
      Map<String, dynamic> rawJwt = jwt.Jwt.parseJwt(token);
      IJwtToken tokenData = IJwtToken.fromJson(rawJwt);

      currentUser.value = await AuthService().getSignedInUserInfo();
      clientDetails.value = await AuthService().getClientDetails(currentUser.value.clientId);

      await AuthService().sendProductAnalytics();

      userIsLoggedIn.value = true;
    }
    catch(e){
      userIsLoggedIn.value = false;
      isPerformingAuthCheck.value = false;
    }

    update();
  }

  void _getPackageDetails() async{

    packageInfo.value = await PackageInfo.fromPlatform();

  }

  void signOut() async{
    await _storage.clear();
    // FirebaseService().unsubscribeFromTopics();
    Get.offAllNamed("/login");
    // Get.deleteAll();

  }
}