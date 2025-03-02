import 'dart:convert';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../utils/helper.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  List<ChatMessage> messages = [];
  ChatUser currentUser = ChatUser(id: "0", firstName: "You");
  ChatUser geminiUser = ChatUser(id: "1", firstName: "SGGS AI", profileImage: "assets/images/avatar.jpg");

  bool isLoading = false; // Track loading state

  @override
  void initState() {
    super.initState();
    messages = [
      ChatMessage(
        user: geminiUser,
        createdAt: DateTime.now(),
        text: "Hi, how can I help you today?",
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat with AI")),
      body: Column(
        children: [
          Expanded(
            child: DashChat(
              currentUser: currentUser,
              onSend: onSend,
              messages: messages,
            ),
          ),
          if (isLoading) // Show loading indicator
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: ThreeDotsLoading(), // Custom widget for three dots animation
              ),
            ),
        ],
      ),
    );
  }

  Future<void> onSend(ChatMessage chatMessage) async {
    FocusScope.of(context).unfocus();

    // Add user's message to chat
    setState(() {
      messages = [chatMessage, ...messages];
      isLoading = true; // Show loading
    });

    // ML Model
    ChatMessage responseMessage = ChatMessage(
              user: geminiUser,
              createdAt: DateTime.now(),
              text: "I Cant answer you currently",
            );

            setState(() {
              messages = [responseMessage, ...messages];
            });
    }
  }

// Custom loading animation (three dots)
class ThreeDotsLoading extends StatefulWidget {
  @override
  _ThreeDotsLoadingState createState() => _ThreeDotsLoadingState();
}

class _ThreeDotsLoadingState extends State<ThreeDotsLoading> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 1), vsync: this)..repeat();
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 2),
              child: Opacity(
                opacity: (_animation.value - index / 3).clamp(0, 1),
                child: const CircleAvatar(radius: 4, backgroundColor: Colors.grey),
              ),
            );
          }),
        );
      },
    );
  }
}
