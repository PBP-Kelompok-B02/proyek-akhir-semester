import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:proyek_akhir_semester/Forum/models/forum_data.dart';
import 'package:proyek_akhir_semester/Forum/widgets/forum_card.dart';
import 'package:proyek_akhir_semester/Forum/widgets/create_forum_page.dart';
import 'package:proyek_akhir_semester/internal/auth.dart';
import 'package:proyek_akhir_semester/screens/login.dart';

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
      final response = await http.get(
        Uri.parse('https://b02.up.railway.app/forum/json')
      );
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
      print('Error fetching forums: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'YumYogya Forum',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          )
        ),
        backgroundColor: const Color(0xFF8B0000),
      ),
      body: Container(
        color: Colors.grey[100],
        child: Column(
          children: [
            // Header Section
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
                  
                  // Conditional Create Forum Button
                  if (!request.isGuest) // Show only if not a guest
                    ElevatedButton.icon(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreateForumPage()
                          ),
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
                    )
                  // Ganti bagian else pada conditional rendering button dengan:
                  else
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3F3),
                        border: Border.all(color: const Color(0xFF8B0000).withOpacity(0.2)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                        context, 
                        MaterialPageRoute(builder: (context) => const LoginPage())); // Sesuaikan dengan route login page Anda
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.lock_outline,
                              color: Color(0xFF8B0000),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Login untuk membuat forum baru',
                              style: TextStyle(
                                color: const Color(0xFF8B0000),
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            // Forums List Section
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: _refreshForums,
                      child: _forums.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.forum_outlined,
                                    size: 64,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Belum ada forum',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: _forums.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: ForumCard(
                                    forum: _forums[index],
                                    onForumUpdated: _refreshForums,
                                    isGuest: request.isGuest,
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