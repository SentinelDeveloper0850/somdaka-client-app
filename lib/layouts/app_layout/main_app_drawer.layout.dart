import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:somdaka_client/controllers/auth.controller.dart';

class MainAppDrawerLayout extends StatefulWidget {
  const MainAppDrawerLayout({Key? key}) : super(key: key);

  @override
  _MainAppDrawerLayoutState createState() => _MainAppDrawerLayoutState();
}

class _MainAppDrawerLayoutState extends State<MainAppDrawerLayout> {

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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Image(
                  image: AssetImage("assets/images/logo_sm.png"),
                  width: 30,
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  '${_authController.currentUser.value.name} ${_authController.currentUser.value.surname}',
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(
                  height: 4,
                ),
                // GetX<ChildController>(
                //   builder: (controller){
                //     return Text(
                //       'You have ${controller.children.length} child${controller.children.length != 1 ? 'ren' : ''} enrolled',
                //       style: const TextStyle(color: Colors.white70, fontSize: 11),
                //     );
                //   },
                // )
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              // child: GetX<ChildController>(
              //   builder: (controller){
              //     return  ListView.separated(
              //         padding: EdgeInsets.zero,
              //         itemCount: controller.children.length,
              //         separatorBuilder: (BuildContext context, int index) => const Divider(),
              //         itemBuilder: (BuildContext context, int index) {
              //           return ListTile(
              //               title: Text('${controller.children[index].fullNames} ${controller.children[index].lastname}', style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 12),),
              //               trailing: controller.selectedChildId() == controller.children[index].id ? const Icon(Icons.check, color: Colors.green) : null,
              //               onTap: () {
              //                 controller.setSelectedChild(controller.children[index].id);
              //               }
              //           );
              //         }
              //     );
              //   },
              // ),
            ),
          ),
          const Divider(height: 1,),
          ListTile(
            dense: true,
            leading: Icon(
             Icons.logout,
              size: 14,
              color: Colors.red.shade900,
            ),
            title: const Text('Sign out'),
            onTap: () {
              _authController.signOut();
            },
          ),
          const Divider(height: 1,),
          GetX<AuthController>(
            builder: (controller){
              return ListTile(
                tileColor: const Color.fromRGBO(43, 151, 147, 0.1),
                dense: true,
                title: Text(
                  "app version: ${controller.packageInfo.value.version}",
                  style: const TextStyle(
                      fontStyle: FontStyle.italic
                  ),
                ),
                subtitle: Text(
                  "build ${controller.packageInfo.value.buildNumber}",
                  style: const TextStyle(
                    fontStyle: FontStyle.italic
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

