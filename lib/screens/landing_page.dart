import 'package:flutter/material.dart';
import 'package:proyek_akhir_semester/internal/auth.dart';
import 'package:proyek_akhir_semester/widgets/drawer.dart';
import 'package:proyek_akhir_semester/widgets/navbar.dart';
import 'package:proyek_akhir_semester/models/food_entry.dart';
import 'package:proyek_akhir_semester/widgets/food_card.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late Future<List<Food>> foodItemsFuture;

  @override
  void initState() {
    super.initState();
    foodItemsFuture = fetchFood(CookieRequest());
  }

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

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    int crossAxisCount = orientation == Orientation.portrait ? 2 : 4;

    return Scaffold(
      drawer: const CustomDrawer(),
      bottomNavigationBar: const CustomNavbar(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 100.0, // Increase to give space for both titles
            backgroundColor: const Color(0xFFFBFCF8),
            flexibleSpace: FlexibleSpaceBar(
              // Move the 'Yum Yogya' and 'For You' into the background so they scroll away
              background: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Yum Yogya',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ),
              ),
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
                      crossAxisCount:
                          orientation == Orientation.portrait ? 2 : 4,
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
