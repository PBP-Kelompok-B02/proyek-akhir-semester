
// screens/forum/forum_page.dart
import 'package:flutter/material.dart';

// models/forum_models.dart
class ForumPost {
  final String title;
  final String description;
  final String createdBy;
  final String createdAt;
  final List<ForumReply> replies;

  ForumPost({
    required this.title,
    required this.description,
    required this.createdBy,
    required this.createdAt,
    required this.replies,
  });
}

class ForumReply {
  final String content;
  final String createdBy;
  final String createdAt;

  ForumReply({
    required this.content,
    required this.createdBy,
    required this.createdAt,
  });
}



class ForumPage extends StatelessWidget {
  ForumPage({super.key});

  final List<ForumPost> forums = [
    ForumPost(
      title: "Rekomendasi wedang uwuh",
      description: "Rekomendasi wedang uwuh di daerah A yang enak!",
      createdBy: "lisa123",
      createdAt: "Nov. 10, 2024, 6:07 a.m.",
      replies: [
        ForumReply(
          content: "di toko xyz ada yg enak",
          createdBy: "lisa123",
          createdAt: "Nov. 10, 2024, 6:08 a.m.",
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar dengan warna yang lebih gelap
          SliverAppBar(
            backgroundColor: const Color(0xFF800000),
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: const Text(
                'YumYogya Forum',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              background: Container(
                color: const Color(0xFF800000),
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 50.0), // Tambah padding bottom
                    child: Text(
                      'Tempat berdiskusi dan berbagi pengalaman kuliner Yogyakarta',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  titlePadding: const EdgeInsets.only(bottom: 16.0), // Tambah padding bottom
              ),
            ),

          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Diskusi Terbaru',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF800000),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CreateForumPage()),
                          );
                        },
                        icon: Icon(Icons.add, color: Colors.white),
                        label: Text(
                          'Tambah Forum Baru',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF800000),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ...forums.map((forum) => ForumCard(forum: forum)).toList(),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}



class CreateForumPage extends StatefulWidget {
  const CreateForumPage({super.key});

  @override
  State<CreateForumPage> createState() => _CreateForumPageState();
}

class _CreateForumPageState extends State<CreateForumPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _showLoadingOverlay() {
    setState(() => _isLoading = true);
  }

  void _hideLoadingOverlay() {
    setState(() => _isLoading = false);
  }

  Future<void> _createForum() async {
    _showLoadingOverlay();
    // Implementasi create forum
    await Future.delayed(const Duration(seconds: 2));
    _hideLoadingOverlay();
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: const Color(0xFF800000),
                expandedHeight: 200,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.edit, color: Colors.white, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Buat Forum Baru',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  background: Container(
                    color: const Color(0xFF800000),
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Diskusikan topik kuliner yang Anda inginkan di YumYogya',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Judul Forum',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF800000),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _titleController,
                              decoration: InputDecoration(
                                hintText: 'Masukkan judul forum yang menarik',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor: Colors.grey[50],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Deskripsi',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF800000),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _descriptionController,
                              maxLines: 5,
                              decoration: InputDecoration(
                                hintText: 'Jelaskan detail topik yang ingin Anda diskusikan...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor: Colors.grey[50],
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                OutlinedButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                    side: BorderSide(color: Colors.grey[300]!),
                                  ),
                                  child: const Text('Kembali'),
                                ),
                                const SizedBox(width: 16),
                                ElevatedButton(
                                  onPressed: _createForum,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF800000),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                  ),
                                  child: const Text('Buat Forum'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
        if (_isLoading)
          Container(
            color: Colors.black54,
            child: Center(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF800000),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text('Membuat forum...',
                          style: TextStyle(color: Colors.grey[700])),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}


class ForumCard extends StatelessWidget {
  final ForumPost forum;

  const ForumCard({super.key, required this.forum});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              forum.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF800000),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              forum.description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '${forum.createdBy} • ${forum.createdAt}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Tanggapan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF800000),
              ),
            ),
            const SizedBox(height: 12),
            ...forum.replies.map((reply) => ReplyCard(reply: reply)).toList(),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: 'Tulis tanggapan Anda...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF800000),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  'Kirim Tanggapan',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReplyCard extends StatelessWidget {
  final ForumReply reply;

  const ReplyCard({super.key, required this.reply});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            reply.content,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            '${reply.createdBy} • ${reply.createdAt}',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}