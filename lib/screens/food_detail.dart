import 'package:flutter/material.dart';
import 'package:proyek_akhir_semester/models/food_entry.dart';

class FoodDetailPage extends StatelessWidget {
  final Food food;

  const FoodDetailPage({
    Key? key,
    required this.food,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(food.fields.name),
        backgroundColor: const Color(0xFF592634),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            food.fields.image.isNotEmpty
                ? Image.network(
                    food.fields.image,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.grey,
                    child: const Icon(Icons.image_not_supported),
                  ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                food.fields.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Price: Rp ${food.fields.price}',
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Description:',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                food.fields.description,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            // Add other details like restaurant, address, contact, etc.
          ],
        ),
      ),
    );
  }
}
