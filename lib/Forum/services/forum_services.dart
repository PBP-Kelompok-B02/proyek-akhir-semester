// lib/Forum/services/forum_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proyek_akhir_semester/internal/auth.dart';

class ForumService {
  static const String baseUrl = 'https://b02.up.railway.app/forum';

  static Future<bool> deleteForum(int forumId, CookieRequest request) async {
    try {
      final response = await request.postJson(
        '$baseUrl/$forumId/delete/mobile/',
        jsonEncode({}),
      );
      return response['status'] == 'success';
    } catch (e) {
      print('Error deleting forum: $e');
      return false;
    }
  }

static Future<bool> deleteReply(int replyId, CookieRequest request) async {
    try {
      final response = await request.postJson(
        '$baseUrl/$replyId/delete-reply/mobile/',
        jsonEncode({}),
      );
      return response['status'] == 'success';
    } catch (e) {
      print('Error deleting reply: $e');
      return false;
    }
  }
}