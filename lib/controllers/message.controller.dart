import 'package:get/get.dart';
import 'package:somdaka_client/models/message.model.dart';

class MessageController extends GetxController {
  var messages = <Message>[].obs;

  @override
  void onInit() {
    fetchMessages();
    super.onInit();
  }

  void fetchMessages () async {
    await Future.delayed(const Duration(seconds: 1));

    var messageListFromServer = [
      Message(id: '1', author: 'Karen', body: 'Wishing you all a prosperous 2022!', createdAt: '2022-02-06 07:00:00'),
      Message(id: '2', author: 'Aggie', body: 'Aiden isn\'s feeling well today. Can you come pick him up after lunch?', createdAt: '2022-02-11 16:18:04'),
    ];

    messages.value = messageListFromServer;
  }
}