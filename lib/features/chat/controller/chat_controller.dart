import 'package:chat_app/features/chat/models/chat_model.dart';
import 'package:get/get.dart';

import '../../../services/firestore_services.dart';
import '../../user/model/user_model.dart';

class ChatController extends GetxController {
  final RxList<MessageModel> messageList = <MessageModel>[].obs;

  Future<void> getAllMessages(UserModel user) async {
    final List<MessageModel> result =
        await FireStoreServices().getAllMessage(user);
    messageList.value = result;
  }
}
