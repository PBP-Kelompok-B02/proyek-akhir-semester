import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:proyek_akhir_semester/Forum/menu.dart';
import 'package:proyek_akhir_semester/internal/auth.dart';

// create_forum_page.dart
class CreateForumPage extends StatefulWidget {
  const CreateForumPage({Key? key}) : super(key: key);

  @override
  State<CreateForumPage> createState() => _CreateForumPageState();
}

class _CreateForumPageState extends State<CreateForumPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  Future<void> _createForum() async {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      return;
    }

    setState(() => _isLoading = true);
    final request = context.read<CookieRequest>();

    try {
      final response = await request.postJson(
        'https://b02.up.railway.app/forum/submit-forum/mobile/',
        jsonEncode(<String, String>{
          'title': _titleController.text,
          'description': _descriptionController.text,
        }),
      );

      if (response['status'] == 'success') {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Forum berhasil dibuat!"))
          );
          // Kembali ke ForumPage dengan refresh
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ForumPage()),
          );
        }
      }
    } catch (e) {
      print('Error creating forum: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Buat Forum Baru',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF8B0000),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Judul Forum',
              style: TextStyle(color: Color(0xFF8B0000)),
            ),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Masukkan judul forum yang menarik',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Deskripsi',
              style: TextStyle(color: Color(0xFF8B0000)),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: 'Jelaskan detail topik yang ingin Anda diskusikan...',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Kembali'),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : () async {
                    setState(() => _isLoading = true);
                    
                    try {
                      await _createForum();
                      if (mounted) {  // Tambahkan pengecekan mounted
                        Navigator.pop(context, true);
                      }
                    } finally {
                      if (mounted) {  // Tambahkan ini
                        setState(() => _isLoading = false);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B0000),
                    foregroundColor: Colors.white,
                  ),
                  child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Buat Forum'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}