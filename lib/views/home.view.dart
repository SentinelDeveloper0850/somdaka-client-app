import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:somdaka_client/controllers/auth.controller.dart';
import 'package:somdaka_client/controllers/blog.controller.dart';
import 'package:somdaka_client/layouts/app_layout/app_layout.controller.dart';
import 'package:somdaka_client/layouts/main.layout.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  void getData() {
  //  TODO: Fetch data through controller here...
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Layout(
      title: 'Dashboard',
      hasDrawer: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.25,
            child: Column(
              children: [
                GetX<AuthController>(
                  builder: (controller){
                    return ListTile(
                      dense: true,
                      title: Text(
                        controller.clientDetails.value.name,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      subtitle: Text(
                        "Welcome back ${controller.currentUser.value.name} ${controller.currentUser.value.surname}",
                        style: const TextStyle(
                          fontSize: 14
                        ),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
