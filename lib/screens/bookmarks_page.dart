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

          final screenWidth = MediaQuery.of(context).size.width;

          // Calculate number of columns based on screen width
          final crossAxisCount = switch (screenWidth) {
            < 600 => 1, // Mobile
            < 900 => 2, // Tablet
            < 1200 => 3, // Small desktop
            _ => 4, // Large desktop
          };

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 0.8,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
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
