import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:somdaka_client/controllers/auth.controller.dart';

import 'app_layout/main_app_drawer.layout.dart';

class Layout extends StatefulWidget {
  const Layout(
      {Key? key,
      this.tabController,
      this.tabs,
      this.actions,
      this.title,
      required this.child,
      required this.hasDrawer,
      this.hasHeader = false,

      })
      : super(key: key);

  final TabController? tabController;
  final List<Widget>? tabs;
  final List<Widget>? actions;

  final bool hasDrawer;
  final bool? hasHeader;

  final String? title;
  final Widget child;

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {

  late final AuthController _authController;

  @override
  void initState() {
    if(Get.isRegistered<AuthController>()){
      _authController = Get.find<AuthController>();
    }else{
      _authController = Get.put(AuthController());
    }

    super.initState();
  }

  Widget _withDrawer(){
    return Scaffold(
      backgroundColor: const Color(0xfff1f1f1),
      appBar: widget.title != null
          ? AppBar(
        elevation: 1,
        title: Text(
          widget.title!,
          style:
          const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
        ),
        actions: widget.actions ??
            [
              IconButton(
                onPressed: () {
                  print('Tapped');
                  // pushNewScreen(context, screen: BroadcastView(), withNavBar: false);
                },
                iconSize: 18,
                icon: const Icon(Icons.notifications_outlined),
              ),
            ],
        backgroundColor: Theme.of(context).primaryColor,
        bottom: widget.tabController != null
            ? TabBar(
          controller: widget.tabController,
          tabs: widget.tabs!,
          labelColor: Colors.white,
          indicatorColor: Colors.white,
        )
            : null,
      )
          : null,
      body: widget.child,
      drawer: const MainAppDrawerLayout(),
    );
  }

  Widget _withoutDrawer(){
    return Scaffold(
      backgroundColor: const Color(0xfff1f1f1),
      appBar: widget.title != null
          ? AppBar(
        elevation: 1,
        title: Text(
          widget.title!,
          style:
          const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
        ),
        actions: widget.actions ??
            [
              IconButton(
                onPressed: () {
                  print('Tapped');
                  // pushNewScreen(context, screen: BroadcastView(), withNavBar: false);
                },
                iconSize: 18,
                icon: const Icon(Icons.notifications_outlined),
              ),
            ],
        backgroundColor: Theme.of(context).primaryColor,
        bottom: widget.tabController != null
            ? TabBar(
          controller: widget.tabController,
          tabs: widget.tabs!,
          labelColor: Colors.white,
          indicatorColor: Colors.white,
        )
            : null,
      )
          : null,
      body: widget.child,
    );
  }

  @override
  Widget build(BuildContext context) {


    return widget.hasDrawer ? _withDrawer() : _withoutDrawer();
  }
}
