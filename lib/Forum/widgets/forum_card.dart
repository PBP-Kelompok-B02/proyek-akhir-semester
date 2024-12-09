// lib/Forum/widgets/forum_card.dart

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
            const SnackBar(content: Text("Tanggapan berhasil ditambahkan!"))
          );
        }
      }
    } catch (e) {
      print('Error submitting reply: $e');
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
            child: const Text('Batal'),
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
      final success = await ForumService.deleteForum(widget.forum.id, request);
      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Forum berhasil dihapus!"))
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
  Widget build(BuildContext context) {
    final request = context.read<CookieRequest>();
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Forum Title with Delete Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.forum.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (widget.forum.createdBy == request.username)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: _deleteForum,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Forum Description
            Text(widget.forum.description),
            
            // Forum Author & Time
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.person, size: 16),
                  const SizedBox(width: 4),
                  Text(widget.forum.createdBy),
                  const SizedBox(width: 16),
                  Text(widget.forum.createdAt),
                ],
              ),
            ),

            // Replies Section
            if (widget.forum.replies.isNotEmpty) ...[
              const Divider(),
              const Text(
                'Tanggapan',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8B0000),
                ),
              ),
              const SizedBox(height: 8),
              ...widget.forum.replies.map((reply) => Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(reply.content),
                          Row(
                            children: [
                              const Icon(Icons.person_outline, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                reply.createdBy,
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                reply.createdAt,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (reply.createdBy == request.username)
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                        onPressed: () => _deleteReply(reply),
                      ),
                  ],
                ),
              )).toList(),
            ],

            // Reply Input
            const Divider(),
            TextField(
              controller: _replyController,
              decoration: const InputDecoration(
                hintText: 'Tulis tanggapan Anda...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _submitReply,
              icon: const Icon(Icons.send),
              label: const Text('Kirim Tanggapan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B0000),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}