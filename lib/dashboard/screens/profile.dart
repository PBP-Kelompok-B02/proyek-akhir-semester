import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:proyek_akhir_semester/dashboard/screens/add_food.dart';
import 'package:proyek_akhir_semester/dashboard/screens/food_list.dart';
import 'package:proyek_akhir_semester/internal/auth.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  String username = "";
  int foodCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
    
    // Fetch initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchUserData();
      _fetchFoodCount();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserData() async {
    final request = context.read<CookieRequest>();
    username = request.username!;
  }

  Future<void> _fetchFoodCount() async {
    final request = context.read<CookieRequest>();
    try {
      final response = await request.get('https://b02.up.railway.app/profile/json/');
      setState(() {
        foodCount = response.length;
      });
    } catch (e) {
      // Handle error
      print('Error fetching food count: $e');
    }
  }

  Widget _buildAnimatedCard({
      required IconData icon,
      required String title,
      required VoidCallback onTap,
    }) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Interval(0.4, 1.0, curve: Curves.easeOut),
        )),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(15),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Row(
                children: [
                  Icon(icon, color: const Color(0xFF602231), size: 28),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ),
          ),
        ),
      );
    }

 void _showChangePasswordDialog(CookieRequest request) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const Row(
        children: [
          Icon(Icons.key, color: Color(0xFF602231)),
          SizedBox(width: 10),
          Text(
            'Ubah Password',
            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF602231)),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              controller: oldPasswordController,
              decoration: InputDecoration(
                labelText: 'Old Password',
                labelStyle: const TextStyle(color: Color(0xFF602231)),
                prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF602231)),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF602231)),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF602231)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              obscureText: true,
              controller: newPasswordController,
              decoration: InputDecoration(
                labelText: 'New Password',
                prefixIcon: const Icon(Icons.lock_reset, color: Color(0xFF602231)),
                labelStyle: const TextStyle(color: Color(0xFF602231)),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF602231)),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF602231)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              obscureText: true,
              controller: confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                labelStyle: const TextStyle(color: Color(0xFF602231)),
                prefixIcon: const Icon(Icons.check_circle_outline, color: Color(0xFF602231)),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF602231)),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF602231)),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async => Navigator.pop(context),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            final response = await request.postJson(
              'https://b02.up.railway.app/profile/change-password-flutter/',
              jsonEncode({
                'old_password': oldPasswordController.text,
                'new_password': newPasswordController.text,
                'confirm_password': confirmPasswordController.text,
              }),
            );

            if (response['status'] == 'success') {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password berhasil diubah!')),
              );
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(response['message'])),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF602231),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text('Ubah Password'),
        ),
      ],
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: const Color(0xFFFBFCF8),
      body: RefreshIndicator(
        onRefresh: () async {
          await _fetchFoodCount();
          await _fetchUserData();
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 170.0,
              floating: false,
              pinned: true,
              backgroundColor: const Color(0xFF602231),
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center, 
                  children: [
                    Text(
                      username,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14, // Ukuran lebih kecil
                      ),
                    ),
                  ],
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF602231),
                        Color(0xFF602231).withOpacity(0.8),
                      ],
                    ),
                  ),
                  child: Center(
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white24,
                        child: Icon(Icons.person, size: 40, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Jumlah makanan di daftar Anda',
                      style: TextStyle(
                        color: Color(0xFF602231),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 500),
                      tween: Tween(begin: 0, end: foodCount.toDouble()),
                      builder: (context, value, child) {
                        return Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF602231), Color(0xFF7D2D3E)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                value.toInt().toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'Makanan',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    _buildAnimatedCard(
                      icon: Icons.add_circle_outline,
                      title: 'Tambah Makanan',
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AddFoodPage()),
                        );
                        _fetchFoodCount();
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildAnimatedCard(
                      icon: Icons.list_alt,
                      title: 'Lihat Daftar Makanan',
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const FoodListPage()),
                        );
                        _fetchFoodCount();
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildAnimatedCard(
                      icon: Icons.lock_outline,
                      title: 'Ubah Password',
                      onTap: () => _showChangePasswordDialog(request),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}