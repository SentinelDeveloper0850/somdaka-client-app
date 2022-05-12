import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:somdaka_client/controllers/auth.controller.dart';
import 'package:somdaka_client/models/blog/article.model.dart';
import 'dart:convert';
import '../app.config.dart';

class BlogService{

  final String _baseUrl = AppConfig.BLOG_SERVICE_URL;

  Future<List<IArticle>> getClientArticles() async{
    final AuthController _authController = Get.find<AuthController>();
    Uri endpoint = Uri.parse(_baseUrl + 'articles/client/${_authController.clientDetails.value.id}');

    final response = await http.get(endpoint);

    if(response.statusCode == 200){
      return List<IArticle>.from(json.decode(response.body).map( (e) => IArticle.fromJson(e)));

    }else{
      print(json.decode(response.body) + " " + response.statusCode);
      throw Exception("Failed to get client Articles");
    }

  }

}