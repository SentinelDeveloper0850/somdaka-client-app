import 'package:intl/intl.dart';

class DateFormatHelpers{

  String formatChatDate(DateTime date){

    int deviceDateTimeOffset = DateTime.now().timeZoneOffset.inHours;
    int messageDateTimeOffset = date.timeZoneOffset.inHours;

    // The server formats the time to UTC + 0
    //Therefore we can assume that the timestamp will always be UTC + 0 when the server fetches it
    // In this case, we must check if the device timezone is greater or lower e.g UTC +2 , UTC -1
    DateTime formattedTime = date;

    if(messageDateTimeOffset != deviceDateTimeOffset){
      //Time is not negative
      if(!deviceDateTimeOffset.isNegative){
        formattedTime = date.add(Duration(hours: deviceDateTimeOffset));
      }else{
        formattedTime = date.subtract(Duration(hours: deviceDateTimeOffset));
      }
    }


    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    String response = "";

    DateTime dateToCheck = DateTime(formattedTime.year, formattedTime.month, formattedTime.day);
    //Check if Date is yesterday
    if(dateToCheck == yesterday){
      response = "Yesterday";
    }
    else if(dateToCheck == today){
      response = DateFormat.Hm().format(formattedTime);

    }
    //Check if date is before yesterday
    else if(dateToCheck.isBefore(yesterday)){
      // response = DateFormat("EEEE").format(date);
      response = DateFormat("yMd").format(formattedTime);
    }

    return response;
  }

}