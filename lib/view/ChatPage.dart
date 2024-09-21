import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        title: const Text('Mr John'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: [
                _buildMessageBubble('Hello, how are you?', true),
                _buildMessageBubble('I\'m fine, thank you!', false),
                _buildMessageBubble('What about you?', false),
                _buildMessageBubble('I\'m good too, thanks!', true),
              ],
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  // Widget create message
  Widget _buildMessageBubble(String message, bool isSentByMe) {
    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: isSentByMe ? Colors.blueAccent : Colors.grey[300],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isSentByMe ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  // Widget create input message
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Type a message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.send),
            color: Colors.blue,
            onPressed: () {
              // send message
            },
          ),
        ],
      ),
    );
  }
}
