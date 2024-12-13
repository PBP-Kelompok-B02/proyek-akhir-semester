import 'package:flutter/material.dart';
import 'package:proyek_akhir_semester/dashboard/profile.dart';
import 'package:proyek_akhir_semester/screens/search.dart';
import 'package:proyek_akhir_semester/screens/bookmarks_page.dart';
import 'package:proyek_akhir_semester/screens/forum_page.dart'; // Pastikan file ini ada dan benar




class CustomNavbar extends StatelessWidget {
  const CustomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: const Color(0xFF592634),
      child: SizedBox(
        height: 60.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Forum icon
            IconButton(
              icon: const Icon(Icons.chat),
              color: const Color(0xFFFBFCF8),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ForumPage()), // Pastikan ForumPage didefinisikan
                );
              },
            ),
            // Search icon
            IconButton(
              icon: const Icon(Icons.search),
              color: const Color(0xFFFBFCF8),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchPage()),
                );
              },
            ),
            // Logo in the middle
            SizedBox(
              width: 60,
              height: 60,
              child: Image.asset(
                'assets/logo.png', // Pastikan path ini sesuai dengan lokasi logo Anda
                fit: BoxFit.contain,
              ),
            ),
            // Bookmark icon
            IconButton(
              icon: const Icon(Icons.bookmark),
              color: const Color(0xFFFBFCF8),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BookmarksPage()),
                );
              },
            ),
            // Profile icon
            IconButton(
              icon: const Icon(Icons.person),
              color: const Color(0xFFFBFCF8),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Dashboard()), // Pastikan ProfilePage didefinisikan
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
