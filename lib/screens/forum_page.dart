import 'package:flutter/material.dart';

class ForumPage extends StatelessWidget {
  const ForumPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forum'),
        backgroundColor: const Color(0xFF592634),
      ),
      body: const Center(
        child: Text(
          'Halaman Forum',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
