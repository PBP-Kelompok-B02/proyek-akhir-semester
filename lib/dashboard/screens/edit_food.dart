import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyek_akhir_semester/dashboard/widgets/form.dart';
import 'dart:convert';
import '../../internal/auth.dart';
import 'package:proyek_akhir_semester/models/food_entry.dart';

// Di file edit_food_page.dart
class EditFoodPage extends StatefulWidget {
  final String foodId;

  const EditFoodPage({super.key, required this.foodId});

  @override
  State<EditFoodPage> createState() => _EditFoodPageState();
}

class _EditFoodPageState extends State<EditFoodPage> {
  bool _isLoading = true;
  Map<String, dynamic>? foodData;

  @override
  void initState() {
    super.initState();
    fetchFoodDetails();
  }

  Future<void> fetchFoodDetails() async {
    final request = context.read<CookieRequest>();
    try {
      final response = await request.get(
        'https://b02.up.railway.app/profile/get-food/${widget.foodId}/',
      );

      if (response['status'] == 'success') {
        setState(() {
          foodData = response['food'];
          _isLoading = false;
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Gagal mengambil data makanan"),
              backgroundColor: Colors.red,
            ),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Makanan'),
          backgroundColor: const Color(0xFF602231),
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return StyledFoodForm(
      foodId: widget.foodId,
      initialData: foodData,
    );
  }
}