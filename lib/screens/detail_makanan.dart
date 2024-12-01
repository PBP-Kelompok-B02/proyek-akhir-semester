import 'package:flutter/material.dart';
import '../widgets/review_list.dart';
import 'add_review.dart';

class DetailMakananPage extends StatelessWidget {
  final String name;
  final String rating;
  final String description;
  final int price;
  final String restaurantName;
  final String restaurantAddress;
  final List<Map<String, String>> reviews;

  const DetailMakananPage({
    super.key,
    required this.name,
    required this.rating,
    required this.description,
    required this.price,
    required this.restaurantName,
    required this.restaurantAddress,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nama makanan
            Text(
              name,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),

            // Rating makanan
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber),
                Text(
                  ' $rating',
                  style: const TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // Deskripsi makanan
            const Text(
              "Description",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              description,
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),

            // Harga makanan
            const Text(
              "Price",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Rp $price',
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),

            // Nama restoran
            const Text(
              "Restaurant",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              restaurantName,
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),

            // Alamat restoran
            const Text(
              "Address",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              restaurantAddress,
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),

            // Review Section
            const Text(
              "Reviews",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            reviews.isNotEmpty
                ? ReviewList(reviews: reviews)
                : const Text(
                    "No reviews available.",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
            const SizedBox(height: 16.0),

            // Tombol untuk menambahkan review
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddReviewPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 20.0),
                ),
                child: const Text(
                  "Add Review",
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
