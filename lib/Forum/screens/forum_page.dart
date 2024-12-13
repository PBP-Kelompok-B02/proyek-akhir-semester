import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:proyek_akhir_semester/Forum/models/forum_data.dart';
import 'package:proyek_akhir_semester/Forum/widgets/forum_card.dart';
import 'package:proyek_akhir_semester/Forum/widgets/create_forum_page.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({super.key});
  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  List<ForumDatum> _forums = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchForums();
  }

  Future<void> _refreshForums() async {
    setState(() => _isLoading = true);
    await fetchForums();
  }

  Future<void> fetchForums() async {
    try {
      final response = await http.get(Uri.parse('https://b02.up.railway.app/forum/json'));
      if (response.statusCode == 200 && mounted) {
        setState(() {
          _forums = (jsonDecode(response.body) as List)
              .map((data) => ForumDatum.fromJson(data))
              .toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('YumYogya Forum',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: const Color(0xFF8B0000),
      ),
      body: Container(
        color: Colors.grey[100],
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text(
                    'Tempat berdiskusi dan berbagi pengalaman',
                    style: TextStyle(fontSize: 16, height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                    'kuliner Yogyakarta',
                    style: TextStyle(fontSize: 16, height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CreateForumPage()),
                      );
                      if (result == true) await fetchForums();
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah Forum Baru'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B0000),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: _refreshForums,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _forums.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: ForumCard(
                              forum: _forums[index],
                              onForumUpdated: _refreshForums,
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}