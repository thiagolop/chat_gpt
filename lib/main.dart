import 'package:chat_gpt/screens/chat_gpt_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ChatGPT());
}

class ChatGPT extends StatelessWidget {
  const ChatGPT({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat GPT',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ChatGptScreen(),
    );
  }
}
