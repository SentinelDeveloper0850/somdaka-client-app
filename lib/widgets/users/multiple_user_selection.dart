import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:smileykidsnorkempark/controllers/auth.controller.dart';
import 'package:smileykidsnorkempark/models/auth/user.model.dart';
import 'package:smileykidsnorkempark/services/user.service.dart';

import '../notification/error_message_component.dart';
import 'user_selection_checkbox_item.component.dart';

class MultipleUserSelectionComponent extends StatefulWidget {

  final String clientId;
  final selectionCallback;
  final List<String> existingUserIds;

  const MultipleUserSelectionComponent({Key? key, required this.clientId, this.selectionCallback, required this.existingUserIds}) : super(key: key);

  @override
  _MultipleUserSelectionComponentState createState() => _MultipleUserSelectionComponentState();
}

class _MultipleUserSelectionComponentState extends State<MultipleUserSelectionComponent> {

  final List<IUser> _selectedUsers = [];



  late final Future<List<IUser>> _users = _getUsers();

  Future<List<IUser>> _getUsers() async{

    AuthController _authController = Get.find<AuthController>();

    List<IUser> users = await UserService().getUsersByClientId(widget.clientId);
    List<IUser> filteredUsers = users
        .where((user) => user.id != _authController.currentUser.value.id)
        .toList();

    if(widget.existingUserIds.isNotEmpty){
      for (var element in widget.existingUserIds) {
        filteredUsers.removeWhere((user) => user.id == element);
      }
    }else{
      filteredUsers = users;
    }

    filteredUsers.toSet().toList();


    return filteredUsers;
  }

  void _emitUserSelection(){
    widget.selectionCallback(_selectedUsers.toSet().toList());
  }

  Widget _userList(List<IUser> users){

    return ListView.separated(
        itemBuilder: (BuildContext context, int index){
          return UserSelectionCheckBoxItemComponent(
            user: users[index],
            selectionCallback: (IUser selected){

              setState(() {
                _selectedUsers.add(selected);
              });

              _emitUserSelection();
            },
            unselectionCallback: (IUser selected){

              setState(() {
                _selectedUsers.remove(selected);
              });

              _emitUserSelection();
            },
          );
        },
        separatorBuilder: (BuildContext context, int index){
          return const Divider();
        },
        itemCount: users.length
    );

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _users,
      builder: (BuildContext context, AsyncSnapshot<List<IUser>> snapshot){
        Widget child;

        if(snapshot.hasData){
          child = Column(
            children: [
              Expanded(
                child: _userList(snapshot.data!),
              ),
              // Container(
              //   height: 100,
              //   padding: EdgeInsets.all(35),
              //   child: SizedBox(
              //     height: 30,
              //     width: double.infinity,
              //     child: ElevatedButton(
              //       style: ButtonStyle(
              //
              //       ),
              //       onPressed: () {},
              //       child: const Text('Done'),
              //     ),
              //   ),
              // ),
            ],
          );
        }
        else if(snapshot.hasError){
          print(snapshot.stackTrace);
          child = const ErrorMessageComponent(
              title: "Failed to load Users",
              message: "Service Desk failed to load your users, please check your internet connection and try again",
              errorType: 1
          );
        }
        else{
          child = SpinKitWave(
            color: Theme.of(context).primaryColor,
            size: 50.0,
          );
        }
        return child;
      },
    );
  }
}
