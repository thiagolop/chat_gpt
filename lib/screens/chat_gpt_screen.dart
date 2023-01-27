import 'package:chat_gpt/core/app_theme.dart';
import 'package:chat_gpt/models/chat_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../repositories/chat_gpt_repository.dart';

class ChatGptScreen extends StatefulWidget {
  const ChatGptScreen({Key? key}) : super(key: key);

  @override
  State<ChatGptScreen> createState() => _ChatGptScreenState();
}

class _ChatGptScreenState extends State<ChatGptScreen> {
  final _inputController = TextEditingController();
  final _repository = ChatGptRepository(Dio());
  final _messages = <ChatModel>[];
  final _scrollController = ScrollController();

  void _scrollDown() {
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        title: const Text('Chat GPT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SizedBox.expand(
        child: Container(
          padding: const EdgeInsets.all(10),
          color: AppTheme.primaryColor,
          child: Column(children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (_, index) {
                  return Row(
                    children: [
                      if (_messages[index].messageFrom == MessageFrom.me) const Spacer(),
                      Container(
                        margin: const EdgeInsets.all(8),
                        width: MediaQuery.of(context).size.width * 0.8,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _messages[index].messageFrom == MessageFrom.me ? Colors.white : AppTheme.primaryLightColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          _messages[index].message,
                          style: TextStyle(color: _messages[index].messageFrom == MessageFrom.me ? Colors.black : Colors.white, fontSize: 20),
                        ),
                      ),
                      if (_messages[index].messageFrom == MessageFrom.bot) const Expanded(child: SizedBox()),
                    ],
                  );
                },
              ),
            ),
            TextField(
                onTap: () => _scrollDown(),
                style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                maxLines: 4,
                minLines: 1,
                controller: _inputController,
                decoration: InputDecoration(
                  hintText: 'Digite sua mensagem',
                  hintStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                  border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  filled: true,
                  suffixIcon: IconButton(
                    onPressed: () async {
                      if (_inputController.text.isNotEmpty) {
                        final prompt = _inputController.text;
                        setState(() {
                          _messages.add(ChatModel(
                            message: prompt,
                            messageFrom: MessageFrom.me,
                          ));
                          _inputController.text = '';
                          _scrollDown();
                        });
                        final chatResponse = await _repository.promptMessage(prompt);
                        setState(() {
                          _messages.add(ChatModel(
                            message: chatResponse,
                            messageFrom: MessageFrom.bot,
                          ));
                          _scrollDown();
                        });
                      }
                    },
                    icon: const Icon(Icons.send, color: Colors.white),
                  ),
                )),
          ]),
        ),
      ),
    );
  }
}
