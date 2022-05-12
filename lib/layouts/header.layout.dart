import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class HeaderLayout extends StatelessWidget {
  const HeaderLayout(
      {Key? key,
      this.tabController,
      this.tabs,
      this.actions,
      required this.title,
      required this.header,
      this.headerHeight = 240,
      required this.child,
      this.hasBottomNav = false})
      : super(key: key);

  final TabController? tabController;
  final List<Widget>? tabs;
  final List<Widget>? actions;

  final bool? hasBottomNav;

  final String title;
  final Widget child;
  final Widget header;
  final double? headerHeight;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              snap: false,
              floating: false,
              expandedHeight: headerHeight,
              stretch: true,
              title: Text(title,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16
                ),
              ),
              actions: [
                IconButton(
                  onPressed: (){

                  },
                  iconSize: 18,
                  icon: const Icon(Icons.notifications_outlined),
                ),
              ],
              backgroundColor: Theme.of(context).colorScheme.primaryVariant,
              flexibleSpace: FlexibleSpaceBar(
                background: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        width: double.maxFinite,
                        margin: const EdgeInsets.only(top: 84),
                        child: header,
                      ),
                    ),
                    tabController != null ? TabBar(
                      controller: tabController,
                      tabs: tabs!,
                      labelColor: Colors.white,
                      indicatorColor: Colors.white,
                    ) : Container(),
                  ],
                ),
              ),
            ),
            SliverFillRemaining(
              child: SizedBox(
                height: double.maxFinite,
                width: double.maxFinite,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: child,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: Container(
            height: 50.0,
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(2.0),
          child: FloatingActionButton(
            onPressed: () {},
            tooltip: 'Increment Counter',
            backgroundColor: Theme.of(context).colorScheme.primaryVariant,
            child: const Icon(Icons.menu),
          ),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.centerDocked);
  }
}
