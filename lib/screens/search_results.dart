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
  late Future<List<Food>> foodItemsFuture;

  @override
  void initState() {
    super.initState();
    foodItemsFuture = fetchFoodItems();
  }

  Future<List<Food>> fetchFoodItems() async {
    // Replace with your actual data fetching logic
    return widget.foodItems;
  }

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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 50,
            backgroundColor: const Color(0xFFFBFCF8),
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Results for ${widget.query}'),
              background: const ColoredBox(color: Color(0xFFFBFCF8)),
            ),
          ),
          SliverFillRemaining(
            child: FutureBuilder<List<Food>>(
              future: foodItemsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No food items found.'));
                } else {
                  final foodItems = snapshot.data!;
                  return GridView.builder(
                    itemCount: foodItems.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                    ),
                    itemBuilder: (context, index) {
                      return FoodCard(food: foodItems[index]);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
