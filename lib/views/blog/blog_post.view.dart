import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:somdaka_client/widgets/large_divider.component.dart';
import 'package:somdaka_client/controllers/blog.controller.dart';
import 'package:somdaka_client/layouts/main.layout.dart';

class BlogPostView extends StatelessWidget {
  const BlogPostView({Key? key}) : super(key: key);

  final bool _isBookedMarked = true;

  @override
  Widget build(BuildContext context) {
    return Layout(
      hasDrawer: false,
      title: "Article",
      actions: [],
      child: GetX<BlogController>(
        builder: (controller){
          return Column(
            children: [
             SizedBox(
               height: 120,
               child:  ListTile(
                 contentPadding: const EdgeInsets.all(20),
                 title: Text(
                   controller.selectedArticle.value.title,
                   style: const TextStyle(
                       fontSize: 18,
                       fontWeight: FontWeight.w700
                   ),
                   textAlign: TextAlign.start,
                 ),
                 subtitle: Text(
                   controller.selectedArticle.value.subtitle,
                   style: TextStyle(
                     fontStyle: FontStyle.italic,
                     color: Theme.of(context).primaryColor
                   ),
                 ),
               ),
             ),

              // const LargeDividerComponent(),
              const Divider(height: 5, thickness: 2, color: Color.fromRGBO(43, 151, 147, 0.1), ),
              
              Expanded(
                child: Container(
                  // margin: const EdgeInsets.only(top: 10),
                  height: double.infinity,
                  padding: const EdgeInsets.only(left: 18,right: 18,bottom: 18, top: 20),
                  child: ListView.separated(

                    shrinkWrap: true,
                    itemCount: controller.selectedArticle.value.body.length,
                    itemBuilder: (BuildContext context, int i){

                      return Container(
                        padding: const EdgeInsets.all(2),
                        child:  Text(
                          controller.selectedArticle.value.body[i],
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey.shade600
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 10,);
                    },
                  ),
                ),
              ),
              const Divider(height: 2, color: Color.fromRGBO(43, 151, 147, 0.1), thickness: 2,),
              ListTile(
                dense: true,
                minLeadingWidth: 12,
                visualDensity: VisualDensity.compact,
                leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 30,
                  child: Image.asset("assets/icons/default_user_icon.png"),
                ),
                title: Text(
                  controller.selectedArticle.value.author,
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat.yMMMEd().format(controller.selectedArticle.value.createdAt),
                      style: const TextStyle(
                          fontStyle: FontStyle.italic
                      ),
                    ),
                    Text(
                      controller.selectedArticle.value.readDuration,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontStyle: FontStyle.italic
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                // color: const Color.fromRGBO(43, 151, 147, 0.1),
                color: Colors.transparent,
                padding: const EdgeInsets.only(left: 30, right: 40),
                // child: Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: controller.selectedArticle.value.categories.map((e) => Text(
                //     e,
                //     style: const TextStyle(
                //       fontStyle: FontStyle.italic,
                //       fontSize: 12
                //     ),
                //   )).toList(),
                // ),
              ),
            ],
          );
        },
      )
    );
  }
}
