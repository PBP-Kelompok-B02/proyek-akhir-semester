// lib/screens/bookmarks_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyek_akhir_semester/widgets/bookmark_provider.dart';
import 'package:proyek_akhir_semester/widgets/food_card.dart';

class BookmarksPage extends StatelessWidget {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
      ),
      body: Consumer<BookmarkProvider>(
        builder: (context, bookmarkProvider, child) {
          final bookmarkedFoods = bookmarkProvider.bookmarkedFoods;
          if (bookmarkedFoods.isEmpty) {
            return const Center(
              child: Text('No bookmarked foods yet'),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: bookmarkedFoods.length,
            itemBuilder: (context, index) {
              return FoodCard(food: bookmarkedFoods.elementAt(index));
            },
          );
        },
      ),
    );
  }
}