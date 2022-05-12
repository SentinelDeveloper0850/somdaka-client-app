import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smileykidsnorkempark/components/users/multiple_user_selection.dart';
import 'package:smileykidsnorkempark/controllers/auth.controller.dart';
import 'package:smileykidsnorkempark/models/auth/user.model.dart';
import 'package:smileykidsnorkempark/models/chats/newModels/chat.dart';
import 'package:smileykidsnorkempark/services/chat.service.dart';


class CreateGroupChatComponent extends StatefulWidget {
  const CreateGroupChatComponent({Key? key}) : super(key: key);

  @override
  _CreateGroupChatComponentState createState() => _CreateGroupChatComponentState();
}

class _CreateGroupChatComponentState extends State<CreateGroupChatComponent> {

  int _stepIndex = 0;
  late IUser _currentUser;
  late String _clientId;

  final TextEditingController _groupNameTextController = TextEditingController();
  String groupName = "";

  List<IUser> _selectedUsers = [];

  @override
  void initState(){
    super.initState();
    final AuthController _authController = Get.find<AuthController>();
    _currentUser = _authController.currentUser.value;
    _clientId = _authController.clientDetails.value.id;

  }

  void _createGroup() async{
    List<IChatUser> members = _selectedUsers.map((user){
      return IChatUser(
          id: user.id,
          userName: "${user.name} ${user.surname}",
          emailAddress: user.emailAddress
      );
    }).toList();

    IChat chat = IChat(
        members: [
          ...members,
          IChatUser(
              id: _currentUser.id,
              userName: "${_currentUser.name} ${_currentUser.surname}",
              emailAddress: _currentUser.emailAddress
          )
        ],
        createdAt: DateTime.now(),
        id: "",
        type: "group",
        name: groupName,
        clientId: _clientId,
        creator:  IChatUser(
            id: _currentUser.id,
            userName: "${_currentUser.name} ${_currentUser.surname}",
            emailAddress: _currentUser.emailAddress
        ),
      attachedToTask: false
    );


    try{
      await ChatService()
          .createNewChat(chat);

      Navigator.pop(context);

    }
    catch(e){
      final snackBar = SnackBar(
          content: Text(
              e.toString()
          )
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "New Group Chat"
        ),
      ),
      body: SafeArea(
        child: Stepper(
          type: StepperType.horizontal,
          currentStep: _stepIndex,
          controlsBuilder:
              (BuildContext context, ControlsDetails controlsDetails) {


            Widget userSelectionActions = Row(
              children:  [
                TextButton(
                  onPressed: (_stepIndex == 0 && _selectedUsers.isNotEmpty) ? controlsDetails.onStepContinue : null ,
                  child: const Text('NEXT'),
                ),
              ],
            );

            Widget groupDetailsActions = Row(
              children:  [
                TextButton(
                  onPressed: (groupName.isNotEmpty) ? controlsDetails.onStepContinue : null ,
                  child: const Text('FINISH'),
                ),
                TextButton(
                  onPressed: controlsDetails.onStepCancel,
                  child: const Text(
                    "BACK",
                    style: TextStyle(
                      color: Colors.redAccent,
                    ),
                  ),

                ),
              ],
            );

            return
              _stepIndex == 0 ? userSelectionActions : groupDetailsActions;
          },
          onStepContinue: () {

            switch(
            _stepIndex){
              case 0: {
                setState(() {

                  _stepIndex++;
                });
                break;
              }
              case 1: {
                _createGroup();
                break;
              }
            }
          },
          onStepCancel: (){

            if(
            _stepIndex == 1){
             setState(() {

               _stepIndex = 0;
             });
            }
          },
          steps: [
            Step(
              isActive:
              _stepIndex >= 0,
              state:
              _stepIndex > 0 ? StepState.complete : StepState.disabled,
              title: const Text('Select Users'),
              content: SizedBox(
                height: MediaQuery.of(context).size.height * 0.65,
                child: MultipleUserSelectionComponent(
                  existingUserIds: [],
                  clientId: _clientId,
                  selectionCallback: (List<IUser> selectedUsers) async{

                    setState(() {
                      _selectedUsers = selectedUsers;
                    });
                  },
                ),
              ),
            ),
            Step(
              title: const Text('Group Details'),
              content: SizedBox(
                height: MediaQuery.of(context).size.height * 0.65,
                child: Column(
                  children: [
                    TextField(
                      textInputAction: TextInputAction.done,
                      controller: _groupNameTextController,
                      autocorrect: true,
                      minLines: null,
                      maxLines: null,
                      style: const TextStyle(
                          color: Colors.black
                      ),
                      obscureText: false,
                      decoration: InputDecoration(

                        contentPadding: const EdgeInsets.all(10),
                        hintText: "Group Name...",
                        hintStyle: const TextStyle(color: Colors.black),
                        fillColor: Colors.white,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1.0),

                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1.0
                          ),
                        ),

                      ),
                      onChanged: (String text){
                        setState(() {
                          groupName = text;
                        });
                      },
                    ),
                    const Divider(),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.all(15),
                      width: double.infinity,
                      child: Text(
                        "Selected Users: ${_selectedUsers.length}",
                        textAlign: TextAlign.start,
                      ),
                    ),
                    const Divider(),
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children: ListTile.divideTiles(
                            context: context,
                            tiles: _selectedUsers.map((user){
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Theme.of(context).primaryColor,
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                  // backgroundImage: NetworkImage("https://zos.alipayobjects.com/rmsportal/ODTLcjxAfvqbxHnVXCYX.png"),
                                ),
                                title: Text(
                                  "${user.name} ${user.surname}"
                                ),
                                subtitle: Text(
                                    user.role.name
                                ),
                              );
                            })
                        ).toList(),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
