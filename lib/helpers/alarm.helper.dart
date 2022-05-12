import 'package:flutter/material.dart';

class AlarmHelper{

  Color alarmPriorityColor(String priority){
    Color color = Colors.grey;

    switch(priority){

      case 'Critical':{
        color = Colors.red[400] as Color;
        break;
      }
      case 'Urgent':{
        color = Colors.amber[900] as Color;
        break;
      }
      case 'Warning': {
        color = Colors.orangeAccent.shade200;
        break;
      }
      case 'Event': {
        color = Colors.blue.shade400;
        break;
      }

    }

    return color;

  }

}