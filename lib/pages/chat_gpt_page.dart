import 'package:flutter/material.dart';
import '../controller/chat_gpt_controller.dart';
import '../core/app_theme.dart';

class ChatGptPage extends StatefulWidget {
  const ChatGptPage({Key? key}) : super(key: key);

  @override
  State<ChatGptPage> createState() => _ChatGptPageState();
}

class _ChatGptPageState extends State<ChatGptPage> {
  final ChatGptController controller = ChatGptController();
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.primaryColor,
          title: const Text('Chat GPT'),
          centerTitle: true,
          elevation: 10,
          actions: [
            IconButton(
              onPressed: () {
                controller.clear();
              },
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ),
        backgroundColor: AppTheme.primaryLightColor,
        body: AnimatedBuilder(
          animation: controller,
          builder: (_, child) => SizedBox.expand(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: controller.messages.length,
                    itemBuilder: (_, index) {
                      final message = controller.messages[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Column(
                          crossAxisAlignment: message['me'] ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: message['me'] ? MainAxisAlignment.end : MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(left: 10, top: 5, right: 10),
                                  child: Text(
                                    '${message['data'].day}/${message['data'].month}/${message['data'].year}',
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: message['me'] ? AppTheme.messageMe : AppTheme.messageBOT,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    message['message'],
                                    style: TextStyle(color: message['me'] ? Colors.black : Colors.white, fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 10, top: 5, right: 10),
                              child: Text(
                                '${message['data'].hour}:${message['data'].minute}',
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onTap: () {
                            controller.scrollController;
                          },
                          style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                          maxLines: 4,
                          minLines: 1,
                          controller: messageController,
                          decoration: const InputDecoration(
                            hintText: 'Digite uma mensagem',
                            border: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.primaryColor)),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: () {
                          controller.addMessages(messageController.text);
                          messageController.clear();
                        },
                        icon: const Icon(Icons.send, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
