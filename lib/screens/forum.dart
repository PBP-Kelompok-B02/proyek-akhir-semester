import 'package:flutter/material.dart';

class ForumPage extends StatefulWidget {
  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  final List<String> _posts = [];
  final TextEditingController _textController = TextEditingController();

  void _addPost(String text) {
    if (text.isEmpty) return;
    setState(() {
      _posts.insert(0, text);
    });
    _textController.clear();
  }

  Widget _buildPostItem(String text) {
    return ListTile(
      title: Text(text),
    );
  }

  Widget _buildTextComposer() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration.collapsed(hintText: 'Write a post'),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () => _addPost(_textController.text),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forum'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                return _buildPostItem(_posts[index]);
              },
            ),
          ),
          Divider(height: 1.0),
          _buildTextComposer(),
        ],
      ),
    );
  }
}
