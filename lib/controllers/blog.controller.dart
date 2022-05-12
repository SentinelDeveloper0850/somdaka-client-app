import 'package:get/get.dart';
import 'package:somdaka_client/models/blog/article.model.dart';
import 'package:somdaka_client/models/simple_client.model.dart';
import 'package:somdaka_client/services/blog.service.dart';

class BlogController extends GetxController{


  var selectedArticle = IArticle(
    id: "",
    body: [],
    categories: [],
    createdAt: DateTime.now(),
    title: "",
    subtitle: "",
    author: "",
    readDuration: "",
    clientDetails: ISimpleClient(id: "", name: ""),
  ).obs;

  var articles = List<IArticle>.empty().obs;

  var articleCategories = List<String>.empty().obs;

  @override
  void onInit() {
    articleCategories.value = [
      "Homework", "Social Skills", "Misc"
    ];
    getArticles();
    super.onInit();
  }

  void getArticles() async{
    articles.value = await BlogService().getClientArticles();
    articles.refresh();
    print("Articles:${articles.length} ");
  }

  void setSelectedArticle(int i){
    selectedArticle.value = articles[i];
  }

}