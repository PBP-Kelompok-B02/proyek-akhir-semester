import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:proyek_akhir_semester/models/food_entry.dart';

class FoodDetailPage extends StatefulWidget {
  final Food food;
  final bool isLoggedIn;

  const FoodDetailPage({
    super.key,
    required this.food,
    required this.isLoggedIn,
  });

  @override
  _FoodDetailPageState createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends State<FoodDetailPage> {
  final TextEditingController _reviewController = TextEditingController();
  File? _selectedImage;
  List<dynamic> reviews = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReviews();
  }

  // Fetch existing reviews
  Future<void> fetchReviews() async {
    final url = Uri.parse(
        'http://127.0.0.1:8000/food-details/${widget.food.pk}/'); // Ganti URL API Anda
    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
      });

      if (response.statusCode == 200) {
        setState(() {
          final responseData = json.decode(response.body);
          reviews = responseData['reviews'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load reviews');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }

  // Pick image
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  // Submit review
  Future<void> submitReview() async {
    if (_reviewController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review tidak boleh kosong')),
      );
      return;
    }

    final url = Uri.parse(
        'http://127.0.0.1:8000/food-details/${widget.food.pk}/'); // Ganti URL API Anda
    try {
      final request = http.MultipartRequest('POST', url)
        ..fields['review'] = _reviewController.text
        ..headers.addAll({
          'Content-Type': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
        });

      // Add image if selected
      if (_selectedImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          _selectedImage!.path,
        ));
      }

      final response = await request.send();
      if (response.statusCode == 200) {
        setState(() {
          fetchReviews(); // Refresh reviews
          _reviewController.clear();
          _selectedImage = null;
        });
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
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.food.fields.name),
        backgroundColor: const Color(0xFF592634),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image
                    widget.food.fields.image.isNotEmpty
                        ? Image.network(
                            widget.food.fields.image,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: double.infinity,
                            height: 200,
                            color: Colors.grey,
                            child: const Icon(Icons.image_not_supported),
                          ),
                    const SizedBox(height: 16),

                    // Details
                    Text(
                      widget.food.fields.name,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7A2E2E),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Harga: Rp ${widget.food.fields.price}',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Color(0xFF1D741B),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Deskripsi: ${widget.food.fields.description}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),

                    // Review Section
                    const Text(
                      '🖋️ Ulasan Makanan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7A2E2E),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Display existing reviews
                    ...reviews.map((review) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text(review['user']),
                          subtitle: Text(review['content']),
                        ),
                      );
                    }).toList(),

                    // Add review form if logged in
                    if (widget.isLoggedIn) ...[
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
                      if (_selectedImage != null)
                        Image.file(
                          _selectedImage!,
                          height: 100,
                        ),
                      TextButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.upload),
                        label: const Text('Upload Foto (Opsional)'),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: submitReview,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF592634),
                        ),
                        child: const Text('Kirim Ulasan'),
                      ),
                    ] else ...[
                      const Text(
                        'Kamu harus login untuk memberikan review.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ],
                ),
              ),
            ),
    );
  }
}

