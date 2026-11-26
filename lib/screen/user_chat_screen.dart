import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_ollama_projects/const/const_api.dart';
import 'package:my_ollama_projects/services/ollama_api_services.dart';

import '../model/RequestOllamaApi.dart';
import '../model/ResponseOllamaApi.dart';

class UserChatScreen extends StatefulWidget {
  const UserChatScreen({super.key});

  @override
  State<UserChatScreen> createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {
  final TextEditingController _userPromptController = TextEditingController();
  final List<Message> _message = [];
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();

  final OllamaApiServices _ollamaApiServices = OllamaApiServices();

  @override
  void dispose() {
    _userPromptController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 500),
        child: Scaffold(
          drawer: kIsWeb ? Drawer() : SizedBox(),
          appBar: AppBar(
            title: Text(
              "Ollama AI Agent",
              style: GoogleFonts.alikeAngular(color: Colors.white),
            ),

            backgroundColor: Colors.teal,
            toolbarHeight: 80,
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Develop by Yanzyy',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _message.length + (isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _message.length) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.teal,
                              child: Text(
                                "Y",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              "Yanzy AI is thinking...",
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey,
                              ),
                            ),
                            const Spacer(),
                            const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.teal,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    Message message = _message[index];

                    bool isSender = message.role == "user";
                    return BubbleSpecialThree(
                      color: isSender ? Colors.blueAccent : Colors.orange,
                      textStyle: isSender
                          ? TextStyle(color: Colors.white)
                          : TextStyle(color: Colors.black),
                      text: message.content ?? "",
                      isSender: isSender,
                    );
                  },
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _userPromptController,
                    decoration: InputDecoration(
                      labelText: "Ask a question to Ollama Ai Agent...",
                      suffixIcon: IconButton(
                        onPressed: () {
                          if (_userPromptController.text.trim().isNotEmpty) {
                            sendMessage(_userPromptController.text);
                          }
                        },
                        icon: Icon(Icons.send, color: Colors.teal, size: 30),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.teal, width: 2),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void sendMessage(String prompt) {
    _userPromptController.clear();
    setState(() {
      isLoading = true;
      _message.add(Message(role: "user", content: prompt));
      scrollToBottom();
    });

    Message answer = Message(role: "assistant", content: "");
    bool isReceived = true;
    _ollamaApiServices
        .sendUserMessage(
          requestApi: RequestOllamaApi(
            model: ConstApi.modelName,
            messages: [
              Messages(
                role: ConstApi.systemMessage["role"],
                content: ConstApi.systemMessage["content"],
              ),
              ..._message.map(
                (m) => Messages(role: m.role, content: m.content),
              ),
            ],
            stream: true,
          ),
        )
        .listen((chunk) {
          setState(() {
            isLoading = false;

            if (isReceived == true) {
              _message.add(answer);
              isReceived = false;
            }
            answer.content =
                ((answer.content ?? "") + (chunk.message?.content ?? ""));
          });
          scrollToBottom();
        });
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
