import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:proyek_akhir_semester/models/food_entry.dart';
import 'package:provider/provider.dart';
import 'package:proyek_akhir_semester/internal/auth.dart';
import 'package:image_picker/image_picker.dart';

class FoodDetailPage extends StatefulWidget {
  final String foodId;

  const FoodDetailPage({
    Key? key,
    required this.foodId,
  }) : super(key: key);

  @override
  _FoodDetailPageState createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends State<FoodDetailPage> {
  late Map<String, dynamic> foodDetails;
  bool isLoading = true;
  final TextEditingController _reviewController = TextEditingController();
  String base64image = ""; // Add this line
  final ImagePicker _picker = ImagePicker(); // Add this line

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

  // Add this method
  Future<void> pickImage() async {
    try {
      final XFile? pickedImage =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        final bytes = await pickedImage.readAsBytes();
        setState(() {
          base64image = base64Encode(bytes);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gambar berhasil dipilih')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memilih gambar')),
      );
    }
  }

  Future<void> submitReview() async {
    if (_reviewController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review tidak boleh kosong')),
      );
      return;
    }

    final request = context.read<CookieRequest>();

    try {
      final response = await request.post(
        'https://b02.up.railway.app/food-details/json/${widget.foodId}/',
        {
          'review': _reviewController.text,
          'image': base64image, // Add this line
        },
      );
      if (response['success'] == true) {
        _reviewController.clear();
        setState(() {
          base64image = ""; // Reset image
        });
        fetchFoodDetails(); // Refresh the reviews
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Review berhasil ditambahkan')),
        );
      } else {
        throw Exception('Failed to submit review');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengirim review')),
      );
    }
  }

  Future<void> deleteReview(int reviewId) async {
    final request = context.read<CookieRequest>();

    try {
      final response = await request.post(
          'https://b02.up.railway.app/food-details/json/delete-review/$reviewId/',
          {});

      if (response['success'] == true) {
        fetchFoodDetails(); // Refresh the reviews
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Review berhasil dihapus')),
        );
      } else {
        throw Exception('Failed to delete review');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menghapus review')),
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
                        final isCurrentUser = review['user'] ==
                            context.watch<CookieRequest>().username;

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
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(review['review']),
                              if (review['image_url'] != null &&
                                  review['image_url'].isNotEmpty)
                                Image(
                                  image: NetworkImage(
                                      'https://yumyogya.up.railway.app${review['image_url']}'),
                                ),
                            ],
                          ),
                          trailing: isCurrentUser
                              ? IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => deleteReview(review['id']),
                                  color: Colors.red,
                                )
                              : null,
                        );
                      },
                    ),

              // Add review form at the bottom
              if (context.watch<CookieRequest>().loggedIn) ...[
                const SizedBox(height: 16),
                TextField(
                  controller: _reviewController,
                  decoration: const InputDecoration(
                    labelText: 'Tulis ulasan Anda',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: pickImage,
                        icon: const Icon(Icons.image),
                        label: const Text('Pilih Gambar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown[200],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: submitReview,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown[700],
                        ),
                        child: const Text(
                          'Kirim Ulasan',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                if (base64image.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'Gambar terpilih',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ] else ...[
                const SizedBox(height: 16),
                const Text(
                  'Silakan login untuk memberikan ulasan',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
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
