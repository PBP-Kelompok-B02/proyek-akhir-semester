import 'package:flutter/material.dart';
import 'package:proyek_akhir_semester/screens/search.dart';

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
            // Home icon
            IconButton(
              icon: const Icon(Icons.home),
              color: const Color(0xFFFBFCF8),
              onPressed: () {
                // Navigate to Home page
                Navigator.pushNamed(context, '/');
              },
            ),
            // Search icon
            IconButton(
              icon: const Icon(Icons.search),
              color: const Color(0xFFFBFCF8),
              onPressed: () {
                // Navigate to Search page
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
                'assets/logo.png', // Ensure this path is correct
              ),
            ),
            // Bookmark icon
            IconButton(
              icon: const Icon(Icons.bookmark),
              color: const Color(0xFFFBFCF8),
              onPressed: () {
                // Handle Bookmark button press
              },
            ),
            // Profile icon
            IconButton(
              icon: const Icon(Icons.person),
              color: const Color(0xFFFBFCF8),
              onPressed: () {
                // Handle Profile button press
              },
            ),
          ],
        ),
      ),
    );
  }
}
