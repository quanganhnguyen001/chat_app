import 'package:chat_app/features/chat/models/chat_model.dart';
import 'package:get/get.dart';

import '../../../services/firestore_services.dart';
import '../../user/model/user_model.dart';

class ChatController extends GetxController {
  final RxList<MessageModel> messageList = <MessageModel>[].obs;

  @override
  void onInit() {
    getAllMessages();
    // TODO: implement onInit
    super.onInit();
  }

  Future<void> getAllMessages() async {
    final List<MessageModel> result = await FireStoreServices().getAllMessage();
    messageList.value = result;
    messageList.add(MessageModel(
        toId: 'xyz',
        msg: 'Hii',
        read: '',
        type: Type.text,
        fromId: FireStoreServices.firebaseAuth.currentUser!.uid,
        sent: '12:00 AM'));
    messageList.add(MessageModel(
        toId: FireStoreServices.firebaseAuth.currentUser!.uid,
        msg: 'Hello',
        read: '',
        type: Type.text,
        fromId: 'xyz',
        sent: '12:05 AM'));
  }
}
