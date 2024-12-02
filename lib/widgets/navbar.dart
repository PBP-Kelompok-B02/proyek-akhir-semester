// navbar.dart
import 'package:flutter/material.dart';

class CustomNavbar extends StatelessWidget {
  const CustomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: const Color(0xFF592634), // Header color
      child: SizedBox(
        height: 60.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Add this line
          children: [
            // Home icon
            IconButton(
              icon: const Icon(Icons.home),
              color: const Color(0xFFFBFCF8),
              onPressed: () {
                // Handle Home button press
              },
            ),
            // Search icon
            IconButton(
              icon: const Icon(Icons.search),
              color: const Color(0xFFFBFCF8),
              onPressed: () {
                // Handle Search button press
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
