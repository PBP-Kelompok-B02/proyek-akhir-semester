import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';  // Untuk jsonDecode
import 'package:proyek_akhir_semester/Forum/models/forum_data.dart';  // Import model Forum
import 'package:proyek_akhir_semester/Forum/widgets/forum_card.dart'; // Import widget ForumCard
import 'package:proyek_akhir_semester/Forum/widgets/create_forum_page.dart'; // Import halaman create forum


class ForumPage extends StatefulWidget {
  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  List<ForumDatum> _forums = [];  // Ubah Forum menjadi ForumDatum sesuai model Anda
  bool _isLoading = true;

  // Method untuk refresh data
  Future<void> _refreshForums() async {
    setState(() {
      _isLoading = true;
    });
    await fetchForums();
  }

  @override
  void initState() {
    super.initState();
    fetchForums();
  }

  // Forum Page
void _openCreateForum() async {
  if (!mounted) return;  // Tambahkan ini

  setState(() {
    _isLoading = true;
  });
  
  try {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateForumPage()),
    );
    
    if (result == true && mounted) {  // Tambahkan pengecekan mounted
      await fetchForums();
    }
  } finally {
    if (mounted) {  // Tambahkan ini
      setState(() {
        _isLoading = false;
      });
    }
  }
}

  Future<void> fetchForums() async {
    try {
      final response = await http.get(
        Uri.parse('https://b02.up.railway.app/forum/json'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        // Tambahkan pengecekan mounted sebelum setState
        if (mounted) {  // Tambahkan ini
          setState(() {
            _forums = jsonData.map((data) => ForumDatum.fromJson(data)).toList();
            _isLoading = false;
          });
        }
      } else {
        print('Failed to load forums. Status code: ${response.statusCode}');
        throw Exception('Failed to load forums');
      }
    } catch (e) {
      print('Error fetching forums: $e');
      if (mounted) {  // Tambahkan ini
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tambahkan ini di bagian build method Scaffold
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'YumYogya Forum',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF8B0000),
      ),
      body: Column(
        children: [
          // Forum Description
          Container(
            padding: const EdgeInsets.all(16),
            child: const Column(
              children: [
                Text(
                  'Tempat berdiskusi dan berbagi pengalaman',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'kuliner Yogyakarta',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          
          // Add New Forum Button
          // Di forum_page.dart
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton.icon(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateForumPage()),
                );
                
                if (result == true) {
                  // Refresh forum list jika forum berhasil dibuat
                  await fetchForums();
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Tambah Forum Baru'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B0000),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ),
          
          // Forums List
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _forums.length,
                    itemBuilder: (context, index) {
                      return ForumCard(
                        forum: _forums[index],
                        onForumUpdated: _refreshForums,  // Tambahkan ini
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateForumPage()),
          );
          
          if (result == true && mounted) {
            // Refresh forum list jika forum berhasil dibuat
            setState(() => _isLoading = true);
            await fetchForums();
            setState(() => _isLoading = false);
          }
        },
        backgroundColor: const Color(0xFF8B0000),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}