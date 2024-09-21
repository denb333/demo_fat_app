import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class LiveStreamPage extends StatefulWidget {
  const LiveStreamPage({super.key});

  @override
  _LiveStreamPageState createState() => _LiveStreamPageState();
}

class _LiveStreamPageState extends State<LiveStreamPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // ignore: deprecated_member_use
    _controller = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4', 
    )
      ..initialize().then((_) {
        setState(() {}); 
      })
      ..play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            BackButton(color: Colors.black),
            Spacer(),
            Text(
              'Mr John',
              style: TextStyle(color: Colors.black),
            ),
            Spacer(),
            Row(
              children: [
                Icon(Icons.people, color: Colors.black),
                SizedBox(width: 5),
                Text('30',
                    style: TextStyle(color: Colors.black)), // Viewer count
              ],
            ),
          ],
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Video player section
          Expanded(
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
          // Chat input section
          _buildChatInput(),
        ],
      ),
    );
  }

  // Chat input section
  Widget _buildChatInput() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                hintText: 'Type a message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              // Handle send message action
            },
            icon: const Icon(Icons.send),
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}
