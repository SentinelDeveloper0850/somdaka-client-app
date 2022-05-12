import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:somdaka_client/helpers/formatters.helper.dart';
import 'package:somdaka_client/models/chats/newModels/chat.dart';
import 'package:somdaka_client/models/chats/newModels/message.model.dart';
import '../app.config.dart';

class ChatService{

  final String _chatServiceUrl = AppConfig.CHAT_SERVICE_URL + 'api/';

  Future<List<IChat>> getUserChats(String userID) async{
    final Uri endpoint = Uri.parse(_chatServiceUrl + "chats/user/$userID");

    final response = await http.get(endpoint);

    print(endpoint);

    if(response.statusCode == 200){

      try{
        List<IChat> chats = [];

        List<dynamic> data = json.decode(response.body);
        for (var element in data) {
          IChat chat = IChat.fromJson(element);
          chats.add(chat);
        }
        return chats;
      }
      catch(e){
        print(e);
        throw Exception("Failed to get user Chats");
      }


    }else{
      print(json.decode(response.body));

      throw Exception("Failed to get user Chats");
    }
  }

  Future<List<IMessage>> getChatMessages(String chatID) async{
    final Uri endpoint = Uri.parse(_chatServiceUrl + "messages/chat_messages/$chatID");

    final response = await http.get(endpoint);
    if(response.statusCode == 200){

      List<IMessage> messages = [];
      List<dynamic> data = json.decode(response.body);
      for (var element in data) {
        IMessage message = IMessage.fromJson(element);
        messages.add(message);
      }

      return messages;

    }else{
      throw Exception("Failed to Chat Messages");
    }
  }

  Future<bool> sendMessage(IMessage message) async{
    final Uri endpoint = Uri.parse(_chatServiceUrl + "messages/");

    final response = await http.post(endpoint, body: json.encode(message),
        headers: FormatterHelper().formatHttpHeader("Content-Type", "application/json"));
    if(response.statusCode == 201){

      return true;

    }else{
      return false;
    }
  }

  Future<bool> sendTaskMessage(IMessage message, String taskID) async{
    final Uri endpoint = Uri.parse(_chatServiceUrl + "messages/task/$taskID");

    final response = await http.post(endpoint, body: json.encode(message),
        headers: FormatterHelper().formatHttpHeader("Content-Type", "application/json"));
    if(response.statusCode == 201){

      return true;

    }else{
      return false;
    }
  }

  Future<bool> createNewChat(IChat chat) async{
    final Uri endpoint = Uri.parse(_chatServiceUrl + "chats/");

    final response = await http.post(endpoint, body: chat.toRawJson(),
        headers: FormatterHelper().formatHttpHeader("Content-Type", "application/json"));
    
    print(json.encode(response.body));
    
    if(response.statusCode == 201){
      return true;

    }else{
      return false;
    }
  }

  Future<bool> updateChat(IChat chat) async{
    final Uri endpoint = Uri.parse(_chatServiceUrl + "chats/${chat.id}");

    final response = await http.put(endpoint, body: chat.toRawJson(),
        headers: FormatterHelper().formatHttpHeader("Content-Type", "application/json"));
    if(response.statusCode == 200){

      return true;

    }else{
      return false;
    }
  }

  Future<bool> removeParticipant(String chatID, String userID) async{
    final Uri endpoint = Uri.parse(_chatServiceUrl + "chats/remove_participant/$chatID/$userID");

    final response = await http.post(endpoint,
        headers: FormatterHelper().formatHttpHeader("Content-Type", "application/json"));
    if(response.statusCode == 200){
      return true;
    }else{
      return false;
    }
  }

  Future<bool> addParticipant(IChatUser participant, String chatID) async{
    final Uri endpoint = Uri.parse(_chatServiceUrl + "chats/add_participant/$chatID");

    final response = await http.post(endpoint, body: participant.toRawJson(),
        headers: FormatterHelper().formatHttpHeader("Content-Type", "application/json"));
    if(response.statusCode == 200){
      return true;
    }else{
      return false;
    }
  }

  Future<bool> deleteChat(String chatID) async{
    final Uri endpoint = Uri.parse(_chatServiceUrl + "chats/$chatID");
    final response = await http.delete(endpoint);
    if(response.statusCode == 200){
      return true;
    }else{
      return false;
    }

  }

}
