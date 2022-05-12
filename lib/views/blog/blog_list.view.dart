import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:somdaka_client/widgets/large_divider.component.dart';
import 'package:somdaka_client/controllers/auth.controller.dart';
import 'package:somdaka_client/controllers/blog.controller.dart';
import 'package:somdaka_client/layouts/main.layout.dart';
import 'package:somdaka_client/views/blog/blog_post.view.dart';

class BlogListView extends StatefulWidget {
  const BlogListView({Key? key}) : super(key: key);

  @override
  _BlogListViewState createState() => _BlogListViewState();
}

class _BlogListViewState extends State<BlogListView> {

  BlogController _blogController = Get.find<BlogController>();

  @override
  Widget build(BuildContext context) {
    return Layout(
      hasDrawer: true,
      title: "Articles",
      child: Column(
        children: [
          ListTile(
            dense: true,
            title: const Text(
              "Articles",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            ),
            subtitle: GetX<AuthController>(
              builder: (controller){
                return Text(
                  controller.clientDetails.value.name
                );
              },
            ),
          ),
          const Divider(height: 1,),
          ListTile(
            dense: true,
            title: Text(
                "Recommended",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary
              ),
            ),
          ),
          // Container(
          //   margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
          //   width: MediaQuery.of(context).size.width,
          //   height: MediaQuery.of(context).size.height * 0.25,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(10),
          //     color: Colors.white,
          //   ),
          //   child: ,
          // ),
          GetX<BlogController>(
            builder: (controller){

              return Container(
                height: MediaQuery.of(context).size.height * 0.25,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                margin: const EdgeInsets.all(18),
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Expanded(
                      child: ListTile(
                        // dense: true,
                        // contentPadding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                        trailing: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 30,
                          child: Image.asset("assets/icons/articles_icon.png"),
                        ),
                        isThreeLine: true,
                        title: Text(
                          controller.articles[0].title,
                          style: const TextStyle(
                            // fontSize: 16,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\n' + controller.articles[0].subtitle,
                              overflow: TextOverflow.fade,
                            ),
                            const SizedBox(height: 10,),
                            Text(
                              controller.articles[0].categories[0],
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 12
                              ),
                            )
                          ],
                        ),

                      ),
                    ),
                    ListTile(
                      dense: true,
                      visualDensity: VisualDensity.compact,
                      onTap: (){
                        _blogController.setSelectedArticle(0);
                        pushNewScreen(context, screen: const BlogPostView(), withNavBar: false);
                      },
                      title: Text(
                        "Read this article",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 12
                        ),
                      ),
                      trailing: const Icon(
                        CupertinoIcons.chevron_right,
                        size: 14,
                      ),
                    ),
                  ],
                ),
              );

              // return Card(
              //   elevation: 0,
              //   child: InkWell(
              //     child: SizedBox(
              //       width: MediaQuery.of(context).size.width * 0.80,
              //       // height: MediaQuery.of(context).size.height * 0.25,
              //       child: ,
              //     ),
              //     onTap: (){
              //       _blogController.setSelectedPost(0);
              //       pushNewScreen(context, screen: const BlogPostView(), withNavBar: false);
              //     },
              //   ),
              // );

            },
          ),
          const LargeDividerComponent(),
          ListTile(
            dense: true,
            title: Text(
              "Browse more",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary
              ),
            ),
          ),
          const Divider(height: 2, color: Color.fromRGBO(43, 151, 147, 0.1), thickness: 2,),
          Expanded(
            child: GetX<BlogController>(
              builder: (controller){
                return ListView.separated(
                  
                  itemBuilder: (BuildContext context, int i){
                    return ListTile(
                      contentPadding: const EdgeInsets.all(10),
                      minLeadingWidth: 20,
                      dense: true,
                      leading: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: Image.asset("assets/icons/articles_icon.png"),
                        radius: 40,
                      ),
                      title: Text(
                        controller.articles[i].title,
                        style: const TextStyle(

                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.articles[i].readDuration,
                            style: TextStyle(
                                fontSize: 10,
                                color: Theme.of(context).colorScheme.onSecondary
                            ),
                          ),
                          Text(
                            DateFormat.yMMMEd().format(controller.articles[i].createdAt),
                            style: const TextStyle(
                                fontSize: 10
                            ),
                          ),
                        ],
                      ),
                      trailing: const Icon(
                        CupertinoIcons.chevron_right,
                        size: 16,
                      ),
                      onTap: (){
                        _blogController.setSelectedArticle(i);
                        pushNewScreen(context, screen: const BlogPostView(), withNavBar: false);
                      },
                    );
                  },
                  separatorBuilder: (BuildContext context, int i) => const Divider(height: 1,),
                  itemCount: controller.articles.length,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
