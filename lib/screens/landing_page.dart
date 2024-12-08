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
      appBar: AppBar(
        title: const Text('Yum Yogya'),
        backgroundColor: const Color(0xFFFBFCF8),
      ),
      drawer: const CustomDrawer(),
      bottomNavigationBar: const CustomNavbar(),
      body: Container(
        color: const Color(0xFFFBFCF8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                color: const Color(0xFFFBFCF8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome to YumYogya!',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Discover the best food in Yogyakarta.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                color: const Color(0xFFFBFCF8),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'For You',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    const SizedBox(height: 10),
                    FutureBuilder<List<Food>>(
                      future: foodItemsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Text('No food items found.');
                        } else {
                          final foodItems = snapshot.data!;
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: foodItems.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                            ),
                            itemBuilder: (context, index) {
                              final item = foodItems[index];
                              return FoodCard(food: item);
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
