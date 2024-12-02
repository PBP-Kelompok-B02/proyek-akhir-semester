import 'package:flutter/material.dart';
import 'search_results.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String query = '';
  bool sortByPriceDescending = false;

  final List<Map<String, String>> foodItems = [
    {'name': 'Gudeg', 'image': 'assets/ayam.jpg', 'price': 'Rp 20.000'},
    {'name': 'Bakpia', 'image': 'assets/ayam.jpg', 'price': 'Rp 15.000'},
    {'name': 'Sate Klathak', 'image': 'assets/ayam.jpg', 'price': 'Rp 25.000'},
    {'name': 'Nasi Goreng', 'image': 'assets/ayam.jpg', 'price': 'Rp 18.000'},
    {'name': 'Mie Ayam', 'image': 'assets/ayam.jpg', 'price': 'Rp 12.000'},
    {'name': 'Es Dawet', 'image': 'assets/ayam.jpg', 'price': 'Rp 10.000'},
  ];

  void navigateToResults() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultsPage(
          query: query,
          sortByPriceDescending: sortByPriceDescending,
          foodItems: foodItems,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        backgroundColor: const Color(0xFF592634),
      ),
      body: Container(
        color:
            const Color(0xFFFBFCF8), // Set your desired background color here
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Search for food',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          query = value;
                        });
                      },
                      onSubmitted: (value) {
                        setState(() {
                          query = value;
                        });
                        navigateToResults();
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: navigateToResults,
                    child: const Text('View All'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
