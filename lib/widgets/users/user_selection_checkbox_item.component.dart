import 'package:flutter/material.dart';
import 'package:smileykidsnorkempark/models/auth/user.model.dart';

class UserSelectionCheckBoxItemComponent extends StatefulWidget {

  final IUser user;
  final selectionCallback;
  final unselectionCallback;

  const UserSelectionCheckBoxItemComponent(
      {Key? key, this.selectionCallback, this.unselectionCallback,required this.user}
      ) : super(key: key);

  @override
  _UserSelectionCheckBoxItemComponentState createState() => _UserSelectionCheckBoxItemComponentState();
}

class _UserSelectionCheckBoxItemComponentState extends State<UserSelectionCheckBoxItemComponent> {


  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return  CheckboxListTile(
      title: Text(
        "${widget.user.name} ${widget.user.surname}"
      ),
      value: _isSelected,
      onChanged: (bool? value) {
        setState(() {
         _isSelected = value!;
        });

        if(value!){
          widget.selectionCallback(widget.user);
        }else{
          widget.unselectionCallback(widget.user);
        }
      },
      secondary: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        // backgroundImage: NetworkImage("https://zos.alipayobjects.com/rmsportal/ODTLcjxAfvqbxHnVXCYX.png"),
        child: const Icon(
          Icons.person,
          color: Colors.white,
        ),
      ),
    );
  }
}
