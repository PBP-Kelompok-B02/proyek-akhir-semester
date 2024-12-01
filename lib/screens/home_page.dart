import 'package:flutter/material.dart';
import '../models/food.dart';
import 'detail_makanan.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Food> foods = [
      Food(
        name: "Cumi Bakar",
        rating: "4.5",
        description: "Delicious grilled squid served with special sauce.",
        price: 10500,
        restaurantName: "Seafood Delight",
        restaurantAddress: "Jl. Laut No. 1, Jakarta",
      ),
      Food(
        name: "Ayam Betutu",
        rating: "4.7",
        description: "Traditional Balinese spiced chicken.",
        price: 15000,
        restaurantName: "Bali Spice",
        restaurantAddress: "Jl. Pulau Dewata No. 99, Bali",
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Food List"),
      ),
      body: ListView.builder(
        itemCount: foods.length,
        itemBuilder: (context, index) {
          final food = foods[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: const Icon(Icons.fastfood),
              title: Text(food.name),
              subtitle: Text("Rating: ${food.rating}"),
              onTap: () {
                // Navigasi ke halaman detail makanan
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailMakananPage(
                      name: food.name,
                      rating: food.rating,
                      description: food.description,
                      price: food.price,
                      restaurantName: food.restaurantName,
                      restaurantAddress: food.restaurantAddress,
                      reviews: [], // Anda dapat menambahkan review di sini
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
