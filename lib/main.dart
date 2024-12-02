import 'package:flutter/material.dart';
import 'screens/landing_page.dart';
import 'screens/search.dart';
import 'screens/search_results.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YumYogya',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF592634)),
      ),
      home: const LandingPage(),
      routes: {
        '/search': (context) => const SearchPage(),
        // Add other routes here
      },
    );
  }
}
