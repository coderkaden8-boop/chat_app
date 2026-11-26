import 'package:flutter/material.dart';
import 'package:my_ollama_projects/screen/user_chat_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserChatScreen(),
    );
  }
}
