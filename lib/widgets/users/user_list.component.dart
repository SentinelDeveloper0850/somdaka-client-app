import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:somdaka_client/models/auth/user.model.dart';
import 'package:somdaka_client/services/user.service.dart';

class UserListComponent extends StatefulWidget {
  final String clientId;
  final List<String> existingUserIds;
  final selectionCallback;

  const UserListComponent({Key? key, required this.clientId, this.selectionCallback, required this.existingUserIds}) : super(key: key);

  @override
  _UserListComponentState createState() => _UserListComponentState();
}

class _UserListComponentState extends State<UserListComponent> {

  late final List<IUser> _originalUserList;
  late List<IUser> _users;
  late TextEditingController _textController;
  bool _loadingUserList = true;

  @override
  void initState() {
    _textController = TextEditingController();
    _getUsers();
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _getUsers() async{

    List<IUser> users = await UserService().getUsersByClientId(widget.clientId);
    print(json.encode(users));
    List<IUser> filteredUsers = users;

    if(widget.existingUserIds.isNotEmpty){
      
      for (var element in widget.existingUserIds) {
        filteredUsers.removeWhere((user) => user.id == element);
       
      }
    }else{
      filteredUsers = users;
    }


    //TODO:: Prevent Parent role users from being present in the chat list
    filteredUsers.removeWhere((element) => element.role.name == "Parent");
    
    filteredUsers.toSet().toList();

   setState(() {
     _originalUserList = filteredUsers;
     _users = filteredUsers;
     _loadingUserList = false;
   });

  }

  void _filterList(String searchText){

    setState(() {
      _users = _originalUserList
          .where((user) => user.name.toLowerCase().contains(searchText)
          || user.surname.toLowerCase().contains(searchText)
          || user.emailAddress.toLowerCase().contains(searchText))
          .toList();
    });

  }

  Widget _userList(){

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(0),
          width: double.infinity,
          child: TextField(
            controller: _textController,
            decoration: const InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              contentPadding: EdgeInsets.all(12),
              hintText: "Search",
              prefixIcon: Icon(
                Icons.search_rounded,
                color: Colors.blueGrey,
                size: 18,
              ),

            ),
            onChanged: (String value){

              _filterList(value.toLowerCase());

            },
          ),
        ),
        const Divider(height: 1,),
        Expanded(
          child: _users.isNotEmpty? ListView(
            shrinkWrap: true,
            children: ListTile.divideTiles(
                context: context,
                tiles: _users.map((IUser user){
                  return ListTile(
                    dense: true,
                    title: Text(
                        "${user.name} ${user.surname}"
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            user.emailAddress
                        ),
                        Text(
                            user.role.name
                        ),
                      ],
                    ),
                    onTap: (){
                      widget.selectionCallback(user);
                      Navigator.pop(context);
                    },
                  );
                })
            ).toList(),
          ) : _allUsersAddedAlert() ,
        )
      ],
    );

  }

  Widget _allUsersAddedAlert(){

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          CupertinoIcons.info,
          color: Colors.blue.shade200,
          size: 100,
        ),
        const Text(
          "All potential users have already been added",
          style: TextStyle(
              fontSize: 16
          ),
        )
      ],
    );

  }

  @override
  Widget build(BuildContext context) {

    return !_loadingUserList
        ? _userList()
        : SpinKitWave(
      color: Theme.of(context).primaryColor,
      size: 50.0,
    );

  }
}
