import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  late AnimationController _counterController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _counterAnimation;
  String username = "";
  int foodCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _counterController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _counterAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _counterController, curve: Curves.elasticOut),
    );
    _controller.forward();
    _counterController.forward();
    
    // Fetch initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchUserData();
      _fetchFoodCount();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _counterController.dispose();
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

  Widget _buildFoodCounter() {
    return ScaleTransition(
      scale: _counterAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF602231),
                const Color(0xFF7D2D3E),
                const Color(0xFF602231).withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF602231).withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Makanan',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TweenAnimationBuilder<double>(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeOutCubic,
                            tween: Tween(begin: 0, end: foodCount.toDouble()),
                            builder: (context, value, child) {
                              return Text(
                                value.toInt().toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                          const Text(
                            ' Items',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.restaurant_menu,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.white70,
                      size: 14,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Tambahkan makanan di daftar Anda',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 400, 
          maxHeight: 500, 
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF602231).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.key, color: Color(0xFF602231)),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Ubah Password',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF602231),
                      ),
                    ),
                  ),
                  // Close button
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildPasswordField(
                        controller: oldPasswordController,
                        label: 'Password Lama',
                        icon: Icons.lock_outline,
                      ),
                      const SizedBox(height: 12),
                      _buildPasswordField(
                        controller: newPasswordController,
                        label: 'Password Baru',
                        icon: Icons.lock_reset,
                      ),
                      const SizedBox(height: 12),
                      _buildPasswordField(
                        controller: confirmPasswordController,
                        label: 'Konfirmasi Password',
                        icon: Icons.check_circle_outline,
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Batal',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _handlePasswordChange(request, context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF602231),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Ubah Password'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _buildPasswordField({
  required TextEditingController controller,
  required String label,
  required IconData icon,
}) {
  return TextField(
    controller: controller,
    obscureText: true,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: const Color(0xFF602231).withOpacity(0.8),
        fontSize: 14,
      ),
      prefixIcon: Icon(icon, color: const Color(0xFF602231), size: 20),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 12,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF602231)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF602231), width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: const Color(0xFF602231).withOpacity(0.5),
        ),
      ),
    ),
  );
}

Future<void> _handlePasswordChange(CookieRequest request, BuildContext context) async {
  try {
    final response = await request.postJson(
      'https://b02.up.railway.app/profile/change-password-flutter/',
      jsonEncode({
        'old_password': oldPasswordController.text,
        'new_password': newPasswordController.text,
        'confirm_password': confirmPasswordController.text,
      }),
    );

    if (!context.mounted) return;

    if (response['status'] == 'success') {
      oldPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
      
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password berhasil diubah!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message']),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e) {
    if (!context.mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Terjadi kesalahan. Silakan coba lagi.'),
        backgroundColor: Colors.red,
      ),
    );
  }
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
              iconTheme: const IconThemeData(color: Colors.white),
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
                        fontSize: 14,
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
                    _buildFoodCounter(), // New counter widget
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