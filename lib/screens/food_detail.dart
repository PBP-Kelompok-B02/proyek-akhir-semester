import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FoodDetailPage extends StatefulWidget {
  final String foodId;

  const FoodDetailPage({
    super.key,
    required this.foodId,
  });

  @override
  _FoodDetailPageState createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends State<FoodDetailPage> {
  late Map<String, dynamic> foodDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFoodDetails();
  }

  Future<void> fetchFoodDetails() async {
    final response = await http.get(
      Uri.parse(
          'https://b02.up.railway.app/food-details/json/${widget.foodId}'),
    );

    if (response.statusCode == 200) {
      setState(() {
        foodDetails = jsonDecode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch food details')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Loading..."),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final food = foodDetails['food'];

    return Scaffold(
      appBar: AppBar(
        title: Text(food['name']),
        backgroundColor: Colors.brown[700],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar makanan
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  food['image'],
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Nama makanan
              Text(
                food['name'],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              const SizedBox(height: 16),

              // Detail makanan
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade100,
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow("Harga", "Rp ${food['price']}"),
                    const SizedBox(height: 8),
                    _buildDetailRow("Deskripsi", food['description']),
                    const SizedBox(height: 8),
                    _buildDetailRow("Restoran", food['restaurant']),
                    const SizedBox(height: 8),
                    _buildDetailRow("Waktu Buka", food['open_time']),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Ulasan makanan
              const Text(
                '📝 Ulasan Makanan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 8),
              // Placeholder for reviews or a message
              foodDetails['reviews'].isEmpty
                  ? const Text(
                      'Belum ada ulasan. Jadilah yang pertama memberikan ulasan!',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: foodDetails['reviews'].length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final review = foodDetails['reviews'][index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.brown[100],
                            child: Text(
                              review['user'][0].toUpperCase(),
                              style: const TextStyle(color: Colors.brown),
                            ),
                          ),
                          title: Text(
                            review['user'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.brown),
                          ),
                          subtitle: Text(review['review']),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
