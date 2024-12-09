import 'package:flutter/material.dart';

import 'package:proyek_akhir_semester/internal/auth.dart';
import 'package:proyek_akhir_semester/models/food_entry.dart';
import 'search_results.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String query = '';
  double minPrice = 0;
  double maxPrice = double.infinity;
  bool filterPriceEnabled = false;
  bool sortByPriceDescending = false;
  final _minPriceController = TextEditingController();
  final _maxPriceController = TextEditingController();

  Future<List<Food>> fetchFood(CookieRequest request) async {
    final response = await request.get("https://b02.up.railway.app/json/");
    var data = response;
    List<Food> listFood = [];
    for (var d in data) {
      if (d != null) {
        listFood.add(Food.fromJson(d));
      }
    }
    return listFood;
  }

  void navigateToResults() async {
    CookieRequest request = CookieRequest();
    List<Food> foodItems = await fetchFood(request);

    List<Food> filteredItems = foodItems.where((food) {
      bool matchesQuery =
          food.fields.name.toLowerCase().contains(query.toLowerCase());
      bool matchesPrice = true;
      if (filterPriceEnabled) {
        double price = double.tryParse(
                food.fields.price.replaceAll(RegExp(r'[^0-9.]'), '')) ??
            0;
        matchesPrice = price >= minPrice && price <= maxPrice;
      }
      return matchesQuery && matchesPrice;
    }).toList();

    if (sortByPriceDescending) {
      filteredItems.sort((a, b) {
        double priceA = double.tryParse(
                a.fields.price.replaceAll(RegExp(r'[^0-9.]'), '')) ??
            0;
        double priceB = double.tryParse(
                b.fields.price.replaceAll(RegExp(r'[^0-9.]'), '')) ??
            0;
        return priceB.compareTo(priceA);
      });
    } else {
      filteredItems.sort((a, b) {
        double priceA = double.tryParse(
                a.fields.price.replaceAll(RegExp(r'[^0-9.]'), '')) ??
            0;
        double priceB = double.tryParse(
                b.fields.price.replaceAll(RegExp(r'[^0-9.]'), '')) ??
            0;
        return priceA.compareTo(priceB);
      });
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultsPage(
          query: query,
          foodItems: filteredItems,
        ),
      ),
    );
  }

  void _showPriceFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filter by Price'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CheckboxListTile(
                title: const Text('Enable Price Filter'),
                value: filterPriceEnabled,
                onChanged: (value) {
                  setState(() {
                    filterPriceEnabled = value ?? false;
                  });
                },
              ),
              TextField(
                controller: _minPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Minimum Price'),
              ),
              TextField(
                controller: _maxPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Maximum Price'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  minPrice = double.tryParse(_minPriceController.text) ?? 0;
                  maxPrice = double.tryParse(_maxPriceController.text) ??
                      double.infinity;
                });
                Navigator.pop(context);
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        backgroundColor: const Color(0xFF592634),
      ),
      body: Container(

        color: const Color(0xFFFBFCF8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Search for food',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => query = value,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _showPriceFilterDialog,
                    child: const Text('Filter by Price'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        sortByPriceDescending = !sortByPriceDescending;
                      });
                    },
                    child: Text(
                      sortByPriceDescending ? 'Sort Price ↓' : 'Sort Price ↑',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: navigateToResults,
                child: const Text('Search'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}