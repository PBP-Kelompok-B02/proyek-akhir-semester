import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../../internal/auth.dart';

class StyledFoodForm extends StatefulWidget {
  final String? foodId; 
  final Map<String, dynamic>? initialData;

  const StyledFoodForm({
    Key? key,
    this.foodId,
    this.initialData,
  }) : super(key: key);

  @override
  State<StyledFoodForm> createState() => _StyledFoodFormState();
}

class _StyledFoodFormState extends State<StyledFoodForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _restaurantController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _openTimeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _nameController.text = widget.initialData!['name'] ?? '';
      _priceController.text = widget.initialData!['price']?.toString() ?? '';
      _restaurantController.text = widget.initialData!['restaurant'] ?? '';
      _addressController.text = widget.initialData!['address'] ?? '';
      _contactController.text = widget.initialData!['contact'] ?? '';
      _openTimeController.text = widget.initialData!['open_time'] ?? '';
      _descriptionController.text = widget.initialData!['description'] ?? '';
      _imageUrlController.text = widget.initialData!['image'] ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _restaurantController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    _openTimeController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Color(0xFF602231),
      ),
      prefixIcon: Icon(
        icon,
        color: const Color(0xFF602231),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF602231)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: const Color(0xFF602231).withOpacity(0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF602231), width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.foodId != null ? 'Edit Makanan' : 'Tambah Makanan'),
        backgroundColor: const Color(0xFF602231),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF602231).withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: _buildInputDecoration('Nama Makanan', Icons.restaurant_menu),
                        validator: (value) => value?.isEmpty ?? true ? 'Mohon isi nama makanan' : null,
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _priceController,
                        decoration: _buildInputDecoration('Harga', Icons.attach_money)
                            .copyWith(prefixText: 'Rp '),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value?.isEmpty ?? true) return 'Mohon isi harga';
                          if (int.tryParse(value!) == null) return 'Harga harus berupa angka';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _restaurantController,
                        decoration: _buildInputDecoration('Nama Restoran', Icons.store),
                        validator: (value) => value?.isEmpty ?? true ? 'Mohon isi nama restoran' : null,
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _addressController,
                        decoration: _buildInputDecoration('Alamat', Icons.location_on),
                        maxLines: 2,
                        validator: (value) => value?.isEmpty ?? true ? 'Mohon isi alamat' : null,
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _contactController,
                        decoration: _buildInputDecoration('Kontak', Icons.phone),
                        validator: (value) => value?.isEmpty ?? true ? 'Mohon isi kontak' : null,
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _openTimeController,
                        decoration: _buildInputDecoration('Jam Buka', Icons.access_time),
                        validator: (value) => value?.isEmpty ?? true ? 'Mohon isi jam buka' : null,
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _descriptionController,
                        decoration: _buildInputDecoration('Deskripsi', Icons.description),
                        maxLines: 3,
                        validator: (value) => value?.isEmpty ?? true ? 'Mohon isi deskripsi' : null,
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _imageUrlController,
                        decoration: _buildInputDecoration('URL Gambar', Icons.image),
                        validator: (value) {
                          if (value?.isEmpty ?? true) return 'Mohon isi URL gambar';
                          if (!(Uri.tryParse(value!)?.isAbsolute ?? false)) {
                            return 'Mohon masukkan URL yang valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final data = {
                              'name': _nameController.text,
                              'price': _priceController.text,
                              'restaurant': _restaurantController.text,
                              'address': _addressController.text,
                              'contact': _contactController.text,
                              'open_time': _openTimeController.text,
                              'description': _descriptionController.text,
                              'image': _imageUrlController.text,
                            };

                            try {
                              final response = await request.postJson(
                                widget.foodId != null
                                    ? "https://b02.up.railway.app/profile/edit-flutter/${widget.foodId}/"
                                    : "https://b02.up.railway.app/profile/create-flutter/",
                                jsonEncode(data),
                              );

                              if (mounted) {
                                if (response['status'] == 'success') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(widget.foodId != null
                                          ? "Makanan berhasil diperbarui!"
                                          : "Makanan baru berhasil disimpan!"),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  Navigator.pop(context);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Terdapat kesalahan, silakan coba lagi."),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Error: $e"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF602231),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          widget.foodId != null ? 'Simpan Perubahan' : 'Simpan',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}