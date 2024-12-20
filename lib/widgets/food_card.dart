import 'package:flutter/material.dart';
import 'package:proyek_akhir_semester/models/food_entry.dart';
import 'package:proyek_akhir_semester/screens/food_detail.dart';

class FoodCard extends StatelessWidget {
  final Food food;

  const FoodCard({
    Key? key,
    required this.food,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the food detail page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FoodDetailPage(food: food),
          ),
        );
      },
      child: Card(
        color: const Color(0xFFFBFCF8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            food.fields.image.isNotEmpty
                ? Image.network(
                    food.fields.image,
                    width: double.infinity,
                    height: 100,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: double.infinity,
                    height: 100,
                    color: Colors.grey,
                    child: const Icon(Icons.image_not_supported),
                  ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                food.fields.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Price: Rp ${food.fields.price}',
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 16,
                ),
              ),
            ),
            // Add other fields if necessary
          ],
        ),
      ),
    );
  }
}
