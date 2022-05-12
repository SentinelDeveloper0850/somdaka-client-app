import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainAppBarLayout extends StatelessWidget implements PreferredSize{

  final String title;
  final bool showAlerts;
  final IconData icon;

  MainAppBarLayout({Key? key, required this.title, required this.showAlerts, required this.icon}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(60);



  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      centerTitle: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 16,
          ),
          const SizedBox(width: 3,),
          Text(
            title.toUpperCase(),
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold
            ),
          )
        ],
      ),
      actions: showAlerts ? [
        IconButton(
          onPressed: (){

          },
          icon: const Icon(
            CupertinoIcons.bell
          ),

        )

      ] : [],
    );
  }

  @override
  // TODO: implement child
  Widget get child => throw UnimplementedError();

}
