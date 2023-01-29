import 'package:chat_gpt/repositories/chat_gpt_repository.dart';
import 'package:flutter/material.dart';
import '../repositories/chat_gpt_repository_imp.dart';
import '../service/dio_service_imp.dart';

class ChatGptController with ChangeNotifier {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final List<Map<String, dynamic>> messages = [];
  final ChatGptRepository _chatGptRepository = ChatgptRepositoryImp(DioServiceImp());

  addMessages(String message) async {
    messages.add({'data': DateTime.now(), 'message': message, 'me': true});
    scrollController;
    notifyListeners();
    final response = await _chatGptRepository.promptMessage(message);
    messages.add({'data': DateTime.now(), 'message': response, 'me': false});
    scrollController;
    notifyListeners();
  }

  void scrollToBottom() {
   Future.delayed(const Duration(milliseconds: 300), () {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  void clear() {
    messages.clear();
    notifyListeners();
  }
}
