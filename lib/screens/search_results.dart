import 'package:flutter/material.dart';

import 'package:proyek_akhir_semester/models/food_entry.dart';
import 'package:proyek_akhir_semester/widgets/food_card.dart';

class SearchResultsPage extends StatefulWidget {
  final String query;
  final List<Food> foodItems;

  const SearchResultsPage({
    super.key,
    required this.query,
    required this.foodItems,
  });

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  bool sortByPriceDescending = false;

  void _toggleSortOrder() {
    setState(() {
      sortByPriceDescending = !sortByPriceDescending;
      widget.foodItems.sort((a, b) {
        double priceA = double.tryParse(
                a.fields.price.replaceAll(RegExp(r'[^0-9.]'), '')) ??
            0;
        double priceB = double.tryParse(
                b.fields.price.replaceAll(RegExp(r'[^0-9.]'), '')) ??
            0;
        if (sortByPriceDescending) {
          return priceB.compareTo(priceA);
        } else {
          return priceA.compareTo(priceB);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    int crossAxisCount = orientation == Orientation.portrait ? 2 : 4;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
        backgroundColor: const Color(0xFF592634),
      ),
      body: Container(

        color: const Color(0xFFFBFCF8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(

                children: [
                  Text(
                    'Results for "${widget.query}"',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      sortByPriceDescending
                          ? Icons.arrow_downward
                          : Icons.arrow_upward,
                    ),
                    onPressed: _toggleSortOrder,
                  ),
                ],
              ),
              Expanded(
                child: GridView.builder(
                  itemCount: widget.foodItems.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (context, index) {
                    final item = widget.foodItems[index];
                    return FoodCard(food: item);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
