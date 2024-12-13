import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyek_akhir_semester/Forum/models/forum_data.dart';
import 'package:proyek_akhir_semester/Forum/services/forum_services.dart';
import 'package:proyek_akhir_semester/internal/auth.dart';

class ForumCard extends StatefulWidget {
  final ForumDatum forum;
  final VoidCallback onForumUpdated;

  const ForumCard({
    Key? key,
    required this.forum,
    required this.onForumUpdated,
  }) : super(key: key);

  @override
  State<ForumCard> createState() => _ForumCardState();
}

class _ForumCardState extends State<ForumCard> {
  final TextEditingController _replyController = TextEditingController();
  bool _isExpanded = false;

  String _formatDateTime(String timestamp) {
    // Handle null or empty timestamp
    if (timestamp.isEmpty) {
      return "";
    }
    
    try {
    DateTime dateTime = DateTime.parse(timestamp);
    
    // Daftar nama bulan
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    
    // Format jam
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');
    String amPm = dateTime.hour >= 12 ? 'p.m.' : 'a.m.';
    if (dateTime.hour > 12) hour = (dateTime.hour - 12).toString();
    if (hour == '0') hour = '12';
    
    // Format lengkap: "Dec. 13, 2024, 9:40 a.m."
    return "${months[dateTime.month - 1]}. ${dateTime.day}, ${dateTime.year}, $hour:$minute $amPm";
    } catch (e) {
      print('Error formatting date: $e');
      return timestamp;  // Return original timestamp if parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.read<CookieRequest>();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          // Forum Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        widget.forum.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8B0000),
                        ),
                      ),
                    ),
                    if (widget.forum.createdBy == request.username)
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: _deleteForum,
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  widget.forum.description,
                  style: const TextStyle(fontSize: 14, height: 1.5),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      widget.forum.createdBy,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.access_time, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      _formatDateTime(widget.forum.createdAt),
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Replies Section
          if (widget.forum.replies.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.chat_bubble_outline, 
                    size: 16, 
                    color: Color(0xFF8B0000)
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Tanggapan (${widget.forum.replies.length})',
                    style: const TextStyle(
                      color: Color(0xFF8B0000),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ...widget.forum.replies.map((reply) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            reply.content,
                            style: const TextStyle(height: 1.5),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.person_outline, size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                reply.createdBy,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _formatDateTime(reply.createdAt),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (reply.createdBy == request.username)
                      IconButton(
                        icon: const Icon(Icons.delete_outline, 
                          color: Colors.red, 
                          size: 20,
                        ),
                        onPressed: () => _deleteReply(reply),
                      ),
                  ],
                ),
              )).toList(),
            const SizedBox(height: 8),
          ],

          // Reply Input Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _replyController,
                  decoration: InputDecoration(
                    hintText: 'Tulis tanggapan Anda...',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF8B0000)),
                    ),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _submitReply,
                  icon: const Icon(Icons.send),
                  label: const Text('Kirim Tanggapan'),
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
        ],
      ),
    );
  }

  Future<void> _submitReply() async {
    if (_replyController.text.isEmpty) return;

    final request = context.read<CookieRequest>();
    
    try {
      final response = await request.postJson(
        'https://b02.up.railway.app/forum/${widget.forum.id}/reply/mobile/',
        jsonEncode(<String, String>{
          'content': _replyController.text,
        }),
      );

      if (response['status'] == 'success') {
        _replyController.clear();
        widget.onForumUpdated();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Tanggapan berhasil ditambahkan!"),
            backgroundColor: Colors.green,      
            )
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal menambahkan tanggapan"))
        );
      }
    }
  }

  Future<void> _deleteForum() async {
    final request = context.read<CookieRequest>();
    
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Forum'),
        content: const Text('Apakah Anda yakin ingin menghapus forum ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'Batal',
              style: TextStyle(
                color: Color(0xFF000000),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Hapus',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final success = await ForumService.deleteForum(widget.forum.id, request);
      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Forum berhasil dihapus!"),
          backgroundColor: Colors.green,
          )
        );
        widget.onForumUpdated();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal menghapus forum"))
        );
      }
    }
  }

  Future<void> _deleteReply(Reply reply) async {
    final request = context.read<CookieRequest>();
    
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Tanggapan'),
        content: const Text('Apakah Anda yakin ingin menghapus tanggapan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
            style: TextButton.styleFrom(foregroundColor: Colors.black),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Hapus'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final success = await ForumService.deleteReply(reply.id, request);
      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Tanggapan berhasil dihapus!"))
        );
        widget.onForumUpdated();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal menghapus tanggapan"))
        );
      }
    }
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }
}