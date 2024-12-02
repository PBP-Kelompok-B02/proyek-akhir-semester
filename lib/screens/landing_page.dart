import 'package:flutter/material.dart';
import 'package:proyek_akhir_semester/widgets/drawer.dart';
import 'package:proyek_akhir_semester/widgets/navbar.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  // Sample list of food items
  final List<Map<String, String>> foodItems = [
    {'name': 'Gudeg', 'image': 'assets/ayam.jpg', 'price': 'Rp 20.000'},
    {'name': 'Bakpia', 'image': 'assets/ayam.jpg', 'price': 'Rp 15.000'},
    {'name': 'Sate Klathak', 'image': 'assets/ayam.jpg', 'price': 'Rp 25.000'},
    {'name': 'Nasi Goreng', 'image': 'assets/ayam.jpg', 'price': 'Rp 18.000'},
    {'name': 'Mie Ayam', 'image': 'assets/ayam.jpg', 'price': 'Rp 12.000'},
    {'name': 'Es Dawet', 'image': 'assets/ayam.jpg', 'price': 'Rp 10.000'},
  ];

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
        color:
            const Color(0xFFFBFCF8), // Set your desired background color here
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Top section with header and other elements
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
                    // Add other widgets here
                  ],
                ),
              ),
              // "For You" section
              Container(
                padding: const EdgeInsets.all(16.0),
                color: const Color(0xFFFBFCF8),
                child: Column(
                  children: [
                    // "For You" section title
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'For You',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Food items grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: foodItems.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                      ),
                      itemBuilder: (context, index) {
                        final item = foodItems[index];
                        return Card(
                          color: const Color(0xFFFBFCF8),
                          child: Column(
                            children: [
                              Image.asset(
                                item['image']!,
                                width: double.infinity,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(item['name']!),
                                    Text(item['price']!),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
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
